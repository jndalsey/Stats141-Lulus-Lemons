# test file!

# gameLogsMissing <- readRDS("GameLogsMissing.RDS")


# cleanPlayerDraft <- read.csv("CleanPlayerDraft.csv") # old file
Players <- read.csv("Players.csv")

GLC <- readRDS("GameLogsClean.RDS")

# w05 <- read.csv("Raw WAR Files/2005 WAR.csv") # old file
WAR <- read.csv("WAR.csv")


# this is already done in players.csv

# Players <- cleanPlayerDraft %>% 
#   filter(!ID_missing)
# 
# notPlayers <- cleanPlayerDraft %>% 
#   filter(ID_missing)




isPitcher <- GLC$`452249`$isPitcher # tells you if that player is a pitcher
minors <- GLC$`452249`$minors # gives you their minor stats
majors <- GLC$`452249`$majors # guves you their major stats

library(tidyverse)
library(lubridate)

# add a bool to majors and minors for isMinors and isPitcher

majors <- majors %>% 
  mutate(isMinors = FALSE,
         isPitcher = GLC$`452249`$isPitcher) # make sure this is for the correct player
minors <- minors %>% 
  mutate(isMinors = TRUE,
         isPitcher = GLC$`452249`$isPitcher) # make sure this is for the correct player

allgames <- bind_rows(majors, minors) %>% 
  select(playerid, Date, isMinors, isPitcher) %>% 
  arrange(Date) #%>% 
  #mutate(Datediff = Date - lag(Date))

# need to fix the last part for lag


for (i in seq_along(GLC)) {
  # do the thing for each player
}


# output should be a list with a single data frame (allgames) inside


