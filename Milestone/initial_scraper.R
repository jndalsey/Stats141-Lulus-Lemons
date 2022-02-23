# Initial scraper for first step of project

library(tidyverse)
library(rvest)
library(XML)

main_url <- read_html("https://www.baseball-reference.com/draft/?year_ID=2005&draft_round=1&draft_type=junreg&query_type=year_round&from_type_jc=0&from_type_hs=0&from_type_4y=0&from_type_unk=0")

playertable <- main_url %>% 
  html_nodes(".right, .left, .center") %>% 
  html_text()

pt <- matrix(playertable, ncol = 25, byrow = TRUE)


tail(playertable)




node <- main_url %>% 
  html_node(".left:nth-child(10) a:nth-child(1)") %>% 
  html_text()

page <- session("https://www.baseball-reference.com/draft/?year_ID=2005&draft_round=1&draft_type=junreg&query_type=year_round&from_type_jc=0&from_type_hs=0&from_type_4y=0&from_type_unk=0") %>% 
  session_follow_link(node) %>% 
  read_html() %>% 
  html_table()

page

page[[1]]

l <- list()

l['a'] = 2


# 



d <- readHTMLTable("https://www.baseball-reference.com/players/u/uptonju01.shtml")


# 







# before you run this code you need to update R

# DO NOT RUN

# lib_loc <- "C:/Users/apdev/Documents/R/win-library/3.3"
# to_install <- unname(installed.packages(lib.loc = lib_loc)[, "Package"])
# to_install
# install.packages(pkgs = to_install)

# devtools::install_github("BillPetti/baseballr")
library(baseballr)


d05 <- baseballr::get_draft_mlb(2005)










