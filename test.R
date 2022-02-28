# test file!

# gameLogsMissing <- readRDS("GameLogsMissing.RDS")


cleanPlayerDraft <- read.csv("CleanPlayerDraft.csv")

GLC <- readRDS("GameLogsClean.RDS")

w05 <- read.csv("Raw WAR Files/2005 WAR.csv")


library(tidyverse)
Players <- cleanPlayerDraft %>% 
  filter(!ID_missing)

notPlayers <- cleanPlayerDraft %>% 
  filter(ID_missing)


minors2 <- GLC$`459943`$minors
minors <- GLC$`452249`$minors
majors <- GLC$`452249`$majors

# library(lubridate)

# add a bool to majors and minors for isMinors 

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




minors <- left_join(minors, allgame)


for (i in seq_along(list)) {
  
}




