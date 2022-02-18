# milestone 1 code



# Collect official MLB draft data!

# before you run this code you need to update R

# devtools::install_github("BillPetti/baseballr")
library(baseballr)

d05 <- baseballr::get_draft_mlb(2005)




# Scrape additional draft data from baseball reference

library(tidyverse)
library(rvest)
library(XML)

# reading 1st round of draft

url <- "https://www.baseball-reference.com/draft/?year_ID=2005&draft_round=1&draft_type=junreg&query_type=year_round&from_type_jc=0&from_type_hs=0&from_type_4y=0&from_type_unk=0"

main_page <- read_html(url)

playermat <- main_page %>% 
  html_nodes(".right, .left, .center") %>% 
  html_text() %>% 
  matrix(ncol = 25, byrow = TRUE)

playermat <- playermat[-nrow(playermat),]

playerdf <- as.data.frame(playermat[-1,])
colnames(playerdf) <- playermat[1,]

for (i in 2:12) {
  Sys.sleep(sample(2:4, 1))
  
  url <- str_replace(url, paste0("draft_round=", i-1), paste0("draft_round=", i))
  
  main_page <- read_html(url)
  
  playermat <- main_page %>% 
    html_nodes(".right, .left, .center") %>% 
    html_text() %>% 
    matrix(ncol = 25, byrow = TRUE)
  
  playermat <- playermat[-nrow(playermat),]
  
  playerdf_temp <- as.data.frame(playermat[-1,])
  colnames(playerdf_temp) <- playermat[1,]
  
  playerdf <- rbind(playerdf, playerdf_temp)
}

colnames(playerdf)[13] <- "G_bat"
colnames(playerdf)[18] <- "G_pitch"

# write.csv(playerdf, "Raw_05_Draft.csv", row.names = FALSE)

# playerdf <- read.csv("Raw_05_Draft.csv")




# Clean data

pdf <- playerdf %>% 
  mutate(Bonus = as.numeric(gsub(",", "", substr(Bonus, 2, 10))),
         Name = substr(Name, 1, nchar(Name) - 9),
         Name = ifelse(substr(Name, 1, 1) == "*", substr(Name, 2, nchar(Name)), Name))




# Join Data

final_players <- left_join(pdf, d05, by = c("Name" = "person_full_name"))

write.csv(final_players, "Milestone_2.18.22_Data.csv", row.names = FALSE)


aaaaaaa <- read.csv("Milestone_2.18.22_Data.csv")



