final <- read.csv("final.csv")
load("data_clean_time_single.Rdata")
load(data_clean_time_add_season)

library(tidyverse)
library(car)

mlb_data <- inner_join(data_clean_time_add_season, final, by = "RegLookup")
mlb_data <- mlb_data[!is.na(mlb_data$is_miss_3_months_season), ]
mlb_data <- mlb_data[!(mlb_data$PrimaryPos == "DH"), ]
mlb_data$Bonus <- mlb_data$Bonus/1000000
mlb_data[which(mlb_data$PrimaryPos == "1B" | mlb_data$PrimaryPos == "2B" | mlb_data$PrimaryPos == "3B" | 
                 mlb_data$PrimaryPos == "SS" | mlb_data$PrimaryPos == "IF"), ]$PrimaryPos <- "IF"
mlb_data[which(mlb_data$PrimaryPos == "LF" | mlb_data$PrimaryPos == "OF" | mlb_data$PrimaryPos == "RF" | 
                 mlb_data$PrimaryPos == "CF"), ]$PrimaryPos <- "OF"

mlb_data2 <- inner_join(data_clean_time_single, final, by = "RegLookup")
mlb_data2 <- mlb_data2[!is.na(mlb_data2$is_miss_10_months), ]
mlb_data2 <- mlb_data2[!(mlb_data2$PrimaryPos == "DH"), ]
mlb_data2$Bonus <- mlb_data2$Bonus/1000000

options(scipen = 999999)
g1 <- ggplot(mlb_data, aes(x = PrimaryPos, is_miss_3_months_season)) +
  geom_tile(aes(fill = Bonus)) +
  labs(title = "Heatmap of Player Bonuses by Position", y = "Misses 3 months in a season", x = "Primary Position", fill = "Bonus ($mm)") +
  theme(text = element_text(family = "Times New Roman", size = 12), plot.title = element_text(face = "bold", hjust = 0.5)) +
  scale_fill_gradient("Bonus ($mm)", limits = c(0, 1), breaks = seq(0, 1, 0.25), low = "#a36727", high = "#753131", 
                      labels = c("0.0", "1.5", "3.0", "4.5", "6.0"))
g1

g2 <- ggplot(mlb_data2, aes(x = PrimaryPos, is_miss_10_months)) +
  geom_tile(aes(fill = Bonus)) +
  labs(title = "Heatmap of Player Bonuses by Position", y = "Misses 10 months overall", x = "Primary Position", fill = "Bonus ($mm)") +
  theme(text = element_text(family = "Times New Roman", size = 12), plot.title = element_text(face = "bold", hjust = 0.5))
g2