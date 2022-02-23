#################### final_scrapedraft.R ####################

##### libraries

# for the official mlb data and the player lookup functionality

# devtools::install_github("BillPetti/baseballr") # before you run this code you need to update R
library(baseballr)

# for the scraping

library(tidyverse)
library(rvest)
library(XML)

##### prepare to scrape

minYear <- 2005 # the first year to scrape
maxYear <- 2010 # the last year to scrape

minRound <- 1 # the lowest draft round to scrape
maxRound <- 12 # the highest draft round to scrape

playerdf <- data.frame()

##### scrape

for (yr in minYear:maxYear) {
  
  # make a temporary df for the year's draft
  scraped_year <- data.frame()
  
  # loop through rounds in the year's draft
  for (rd in minRound:maxRound) {
    
    # set url
    url <- paste0("https://www.baseball-reference.com/draft/?year_ID=",
                  yr, "&draft_round=", rd, 
                  "&draft_type=junreg&query_type=year_round&from_type_jc=0&from_type_hs=0&from_type_4y=0&from_type_unk=0")
    
    url <- url(url, "rb")
    
    # randomized sys sleep
    Sys.sleep(rnorm(1, 10, 1))
    
    # read the data off the page
    main_page <- read_html(url)
    
    # close the url so you dont get IP banned
    close(url)
    
    playermat <- main_page %>% 
      html_nodes(".right, .left, .center") %>% 
      html_text() %>% 
      matrix(ncol = 25, byrow = TRUE)
    
    # clean up the matrix
    playermat <- playermat[-nrow(playermat),]
    
    # matrix into df
    players_temp <- as.data.frame(playermat[-1,])
    colnames(players_temp) <- playermat[1,]
    
    # append round onto the year
    scraped_year <- rbind(scraped_year, players_temp)
    
    # message for debugging
    cat("Year:", yr, "Round:", rd, "\n")
  }
  
  # fix duplicate column names for scraped year
  colnames(scraped_year)[13] <- "G_bat"
  colnames(scraped_year)[18] <- "G_pitch"
  
  # clean up pick number for scraped year
  scraped_year$OvPck = as.numeric(scraped_year$OvPck)
  
  # obtain official MLB draft data
  mlbdf <- get_draft_mlb(yr)
  
  # join two data frames
  year_complete <- left_join(scraped_year, mlbdf, by = c("OvPck" = "pick_number"))
  
  # if there are already columns in playerdf, then make sure scraped rows exists to append
  if (nrow(playerdf) > 0) {
    goodCols <- colnames(year_complete)[colnames(year_complete) %in% colnames(playerdf)]
    badCols <- colnames(year_complete)[!(colnames(year_complete) %in% colnames(playerdf))]
    
    cat("From", yr, "removed columns:", badCols, "\n")
    
    year_complete <- year_complete %>% 
      select(all_of(goodCols))
  }
  
  # append the complete year draft onto the whole data
  playerdf <- rbind(playerdf, year_complete)
  
  # message for debugging
  cat("Finished year:", yr, "\n")
}

##### clean

pdf <- playerdf %>% 
  mutate(Bonus = as.numeric(gsub(",", "", substr(Bonus, 2, 10))),
         Name = substr(Name, 1, nchar(Name) - 9),
         Name = ifelse(substr(Name, 1, 1) == "*", substr(Name, 2, nchar(Name)), Name))

##### write csv

write.csv(pdf, "ScrapedPlayerDraft.csv", row.names = FALSE)

#### read csv

# data <- read.csv("ScrapedPlayerDraft.csv")
