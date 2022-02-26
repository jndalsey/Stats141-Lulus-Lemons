#################### clean_scrapedraft.R ####################

##### libraries

library(tidyverse)

##### data

# read in data created by final_scrapedraft.R
scrapedPlayerDraft <- read.csv("ScrapedPlayerDraft.csv")

# read in register
reg <- read.csv("MasterRegister.csv")

# read in ID key
key <- readxl::read_xlsx("SFBB-Player-ID-Map.xlsx", sheet = "PLAYERIDMAP")

##### clean

# get only top 200 players by signing bonus per year

cleanPlayerDraft <- data.frame()

for (yr in min(scrapedPlayerDraft$Year):max(scrapedPlayerDraft$Year)) {
  singleYear <- scrapedPlayerDraft %>%
    filter(Year == yr) %>% 
    arrange(desc(Bonus))
  
  top200 <- singleYear[1:200, ]
  
  cleanPlayerDraft <- rbind(cleanPlayerDraft, top200)
}

##### join data with lookup keys










##### write csv

write.csv(cleanPlayerDraft, "CleanPlayerDraft.csv", row.names = FALSE)

#### read csv

# data <- read.csv("CleanPlayerDraft.csv")


