#################### clean_scrapedraft.R ####################

##### citations

# Bill Petti's package
# https://www.smartfantasybaseball.com/tag/player-id/

##### libraries

library(tidyverse)

# devtools::install_github("BillPetti/baseballr") # before you run this code you need to update R
library(baseballr)

##### data

# read in data created by final_scrapedraft.R
scrapedPlayerDraft <- read.csv("ScrapedPlayerDraft.csv")

# read in register
reg <- read.csv("MasterRegister.csv")

# read in ID key
key <- readxl::read_xlsx("SFBB-Player-ID-Map.xlsx", sheet = "PLAYERIDMAP")

# read in chadwick
chad <- chadwick_player_lu()

##### clean

# get only top 2players with a signing bonus > 0

cleanPlayerDraft <- data.frame()

for (yr in min(scrapedPlayerDraft$Year):max(scrapedPlayerDraft$Year)) {
  singleYear <- scrapedPlayerDraft %>%
    filter(Year == yr) %>% 
    arrange(desc(Bonus)) %>% 
    filter(!is.na(Bonus)) %>% 
    filter(Bonus > 0)
  
  cleanPlayerDraft <- rbind(cleanPlayerDraft, singleYear)
}

# remove 3 corrupt data points

which(is.na(cleanPlayerDraft$person_id)) # [1]  376  930 1575

cleanPlayerDraft <- cleanPlayerDraft %>% 
  filter(!is.na(person_id))

# Year Rnd DT OvPck FrRnd RdPck        Tm Signed   Bonus           Name Pos WAR G_bat  AB HR    BA   OPS G_pitch  W  L ERA
# 376  2006   2 NA    67 FrRnd    23    Astros      Y  550000   Sergio Perez RHP  NA    NA  NA NA    NA    NA      NA NA NA  NA
# 930  2008   1 NA    12 FrRnd    12 Athletics      Y 1910000   Jemile Weeks  2B 1.5   260 955  4 0.255 0.667      NA NA NA  NA
# 1575 2010   4 NA   143 FrRnd    28   Red Sox      Y 1310000 Garin Cecchini  SS 0.2    13  35  1 0.229 0.725      NA NA NA  NA
# WHIP SV Type                         Drafted.Out.of bis_player_id pick_round headshot_link is_drafted is_pass school_name
# 376    NA NA  4Yr        University of Tampa (Tampa, FL)            NA       <NA>          <NA>         NA      NA        <NA>
#   930    NA NA  4Yr University of Miami (Coral Gables, FL)            NA       <NA>          <NA>         NA      NA        <NA>
#   1575   NA NA   HS  Alfred M. Barbe HS (Lake Charles, LA)

##### create lookup keys

simpleReg <- reg %>% 
  filter(!is.na(key_mlbam)) %>% 
  filter(!is.na(key_fangraphs)) %>% 
  select(key_mlbam, key_fangraphs)

simpleKey <- key %>% 
  filter(!is.na(MLBID)) %>% 
  filter(!is.na(IDFANGRAPHS)) %>% 
  select(MLBID, IDFANGRAPHS)

simpleChad <- chad %>% 
  filter(!is.na(key_mlbam)) %>% 
  filter(!is.na(key_fangraphs)) %>% 
  select(key_mlbam, key_fangraphs)

fullLookup <- full_join(simpleReg, simpleKey, by = c("key_mlbam" = "MLBID")) %>% 
  full_join(simpleChad, by = "key_mlbam") %>% 
  transmute(person_id = key_mlbam,
            RegLookup = ifelse(!is.na(key_fangraphs.x), key_fangraphs.x, IDFANGRAPHS),
            KeyLookup = ifelse(!is.na(IDFANGRAPHS), IDFANGRAPHS, RegLookup),
            ChadLookup = ifelse(!is.na(key_fangraphs.y), key_fangraphs.y, RegLookup),
            Disputed = (RegLookup != KeyLookup) | (RegLookup != ChadLookup) | (ChadLookup != KeyLookup)) %>% 
  distinct()

##### join data with lookup keys

cleanPlayerDraft <- left_join(cleanPlayerDraft, fullLookup, by = "person_id")

cleanPlayerDraft <- cleanPlayerDraft %>% 
  mutate(ID_missing = is.na(RegLookup))

##### write csv

write.csv(cleanPlayerDraft, "CleanPlayerDraft.csv", row.names = FALSE)

#### read csv

# data <- read.csv("CleanPlayerDraft.csv")
