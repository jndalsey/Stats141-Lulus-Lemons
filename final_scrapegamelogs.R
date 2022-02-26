#################### final_scrapegamelogs.R ####################

##### libraries

library(tidyverse)

# devtools::install_github("BillPetti/baseballr") # before you run this code you need to update R
library(baseballr)







hu <- fg_batter_game_logs(playerid = 1902, year = 2004)
hu2 <- fg_milb_batter_game_logs(playerid = 1902, year = 2006)



l <- list("steve" = list("minors" = data.frame(1, 2, 3, 4),
                         "majors" = data.frame(1, 2, 3, 4)),
          "joe" = list("minors" = data.frame(1, 2, 3, 4),
                       "majors" = data.frame(1, 2, 3, 4)))
l$steve$minors
