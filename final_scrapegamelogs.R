#################### final_scrapegamelogs.R ####################

##### citations

# Bill Petti's package
# https://www.smartfantasybaseball.com/tag/player-id/

##### libraries

library(tidyverse)

# devtools::install_github("BillPetti/baseballr") # before you run this code you need to update R
library(baseballr)

##### data

cleanPlayerDraft <- read.csv("CleanPlayerDraft.csv")

##### create scraping key for existing, undisputed results

scrapingKeyClean <- cleanPlayerDraft %>% 
  filter(!ID_missing) %>% 
  filter(!Disputed) %>% 
  select(Name, Pos, person_primary_position_abbreviation, person_id, RegLookup:ID_missing) %>% 
  mutate(isPitcher = Pos %in% c("LHP", "RHP") | person_primary_position_abbreviation %in% c("P"),
         person_id = as.character(person_id)) %>% 
  select(Name, person_id:isPitcher)

##### create scraping key for existing, disputed results

# scrapingKeyDisputed <- cleanPlayerDraft %>%
#   filter(Disputed)  %>% 
#   select(Name, Pos, person_primary_position_abbreviation, person_id, RegLookup:ID_missing) %>% 
#   mutate(isPitcher = Pos %in% c("LHP", "RHP") | person_primary_position_abbreviation %in% c("P"),
#          person_id = as.character(person_id)) %>% 
#   select(Name, person_id:isPitcher)

# there are no disputed results in the current database

##### create scraping key for missing results

# scrapingKeyMissing <- cleanPlayerDraft %>% 
#   filter(ID_missing)  %>% 
#   select(Name, Pos, person_primary_position_abbreviation, person_id, RegLookup:ID_missing) %>% 
#   mutate(isPitcher = Pos %in% c("LHP", "RHP") | person_primary_position_abbreviation %in% c("P"),
#          person_id = as.character(person_id)) %>% 
#   select(Name, person_id:isPitcher)

##### create game logs for missing results

# gameLogsMissing <- list()
# 
# for (i in 1:nrow(scrapingKeyMissing)) { # for each person in the scraping key
#   
#   if (scrapingKeyMissing$isPitcher[i]) { # for pitchers
#     # make a list
#     templist <- list(isPitcher = TRUE,
#                      minors = data.frame(),
#                      majors = data.frame())
#     
#   } else { # for hitters
#     # make a list
#     templist <- list(isPitcher = FALSE,
#                      minors = data.frame(),
#                      majors = data.frame())
#   }
#   
#   # store the list
#   gameLogsMissing[[scrapingKeyMissing$person_id[i]]] <- templist
# }
# 
# saveRDS(gameLogsMissing, file = "GameLogsMissing.RDS")

##### scrape game logs

gameLogsClean <- list()

for (i in 1:nrow(scrapingKeyClean)) {
  
  if (scrapingKeyClean$isPitcher[i]) { # for pitchers
    
    # make minors df
    minors <- data.frame()
    
    # loop through all years they could have played
    for (yr in 2005:2019) {
      
      # make temp
      temp <- data.frame()
      
      # try function stops errors
      try({
        # pull down the game logs
        temp <- fg_milb_pitcher_game_logs(playerid = scrapingKeyClean$RegLookup[i], year = yr)
      }, silent = TRUE)
      
      # bind the game logs to the data frame
      minors <- bind_rows(minors, temp)
    }
    
    # make majors df
    majors <- data.frame()
    
    # loop through all years they could have played
    for (yr in 2005:2019) {
      
      # make temp
      temp <- data.frame()
      
      # try function stops errors
      try({
        # pull down the game logs
        temp <- fg_pitcher_game_logs(playerid = scrapingKeyClean$RegLookup[i], year = yr)
      }, silent = TRUE)
      
      # bind the game logs to the data frame
      majors <- bind_rows(majors, temp)
    }
    
    # make the templist
    templist <- list(isPitcher = TRUE,
                     minors = minors,
                     majors = majors)
    
  } else { # for hitters
    
    # make minors df
    minors <- data.frame()
    
    # loop through all years they could have played
    for (yr in 2005:2019) {
      
      # make temp
      temp <- data.frame()
      
      # try function stops errors
      try({
        # pull down the game logs
        temp <- fg_milb_batter_game_logs(playerid = scrapingKeyClean$RegLookup[i], year = yr)
      }, silent = TRUE)
      
      # bind the game logs to the data frame
      minors <- bind_rows(minors, temp)
    }
    
    # make majors df
    majors <- data.frame()
    
    # loop through all years they could have played
    for (yr in 2005:2019) {
      
      # make temp
      temp <- data.frame()
      
      # try function stops errors
      try({
        # pull down the game logs
        temp <- fg_batter_game_logs(playerid = scrapingKeyClean$RegLookup[i], year = yr)
      }, silent = TRUE)
      
      # bind the game logs to the data frame
      majors <- bind_rows(majors, temp)
    }
    
    # make the templist
    templist <- list(isPitcher = FALSE,
                     minors = minors,
                     majors = majors)
    
  }
  
  # store the list
  gameLogsClean[[scrapingKeyClean$person_id[i]]] <- templist
  
  # what iteration are you on
  if (i %% 10 == 0) { cat("I am on:", i, "\n") }
}

saveRDS(gameLogsClean, file = "GameLogsClean.RDS")

