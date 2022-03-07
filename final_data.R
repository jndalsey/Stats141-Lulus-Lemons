#################### final_data.R ####################

##### libraries

library(tidyverse)

##### data in

cleanPlayerDraft <- read.csv("CleanPlayerDraft.csv")

##### clean variables

Players <- cleanPlayerDraft %>% 
  filter(!ID_missing) %>% 
  transmute(Year = Year,
            DraftRound = Rnd,
            OverallPick = OvPck,
            RounddPick = RdPck,
            DraftTeam = Tm,
            Signed = (Signed == "Y"),
            Bonus = Bonus,
            Name = Name,
            DraftPos = Pos,
            PrimaryPos = person_primary_position_abbreviation,
            Career_WAR = WAR,
            Career_G_bat = G_bat,
            Career_AB = AB,
            Career_HR = HR,
            Career_BA = BA,
            Career_OPS = OPS,
            Career_G_pitch = G_pitch,
            Career_W = W,
            Career_L = L,
            Career_ERA = ERA,
            Career_WHIP = WHIP,
            Career_SV = SV,
            PrevType = Type,
            DraftedOutOf = Drafted.Out.of,
            isDrafted = is_drafted,
            SchoolName = school_name,
            Person_ID = person_id,
            BirthDate = person_birth_date,
            CurrentAge = person_current_age,
            ActivePlayer = person_active,
            LastPlayedDate = person_last_played_date,
            MLBDebut = person_mlb_debut_date,
            BatSide = person_bat_side_code,
            PitchSide = person_pitch_hand_code,
            RegLookup = RegLookup)


##### write players

write.csv(Players, "Players.csv", row.names = FALSE)

##### data in

w05 <- read.csv("Raw WAR Files/2005 WAR.csv")
w06 <- read.csv("Raw WAR Files/2006 WAR.csv")
w07 <- read.csv("Raw WAR Files/2007 WAR.csv")
w08 <- read.csv("Raw WAR Files/2008 WAR.csv")
w09 <- read.csv("Raw WAR Files/2009 WAR.csv")
w10 <- read.csv("Raw WAR Files/2010 WAR.csv")
w11 <- read.csv("Raw WAR Files/2011 WAR.csv")
w12 <- read.csv("Raw WAR Files/2012 WAR.csv")
w13 <- read.csv("Raw WAR Files/2013 WAR.csv")
w14 <- read.csv("Raw WAR Files/2014 WAR.csv")
w15 <- read.csv("Raw WAR Files/2015 WAR.csv")
w16 <- read.csv("Raw WAR Files/2016 WAR.csv")
w17 <- read.csv("Raw WAR Files/2017 WAR.csv")
w18 <- read.csv("Raw WAR Files/2018 WAR.csv")
w19 <- read.csv("Raw WAR Files/2019 WAR.csv")

w05 <- mutate(w05, Year = 2005)
w06 <- mutate(w06, Year = 2006)
w07 <- mutate(w07, Year = 2007)
w08 <- mutate(w08, Year = 2008)
w09 <- mutate(w09, Year = 2009)
w10 <- mutate(w10, Year = 2010)
w11 <- mutate(w11, Year = 2011)
w12 <- mutate(w12, Year = 2012)
w13 <- mutate(w13, Year = 2013)
w14 <- mutate(w14, Year = 2014)
w15 <- mutate(w15, Year = 2015)
w16 <- mutate(w16, Year = 2016)
w17 <- mutate(w17, Year = 2017)
w18 <- mutate(w18, Year = 2018)
w19 <- mutate(w19, Year = 2019)

WAR <- bind_rows(w05, w06, w07, w08, w09, w10, w11, w12, w13, w14, w15, w16, w17, w18, w19)

WAR <- WAR %>% 
  transmute(Name = Name,
            RegLookup = as.character(playerid),
            Team = Team,
            Pos = Pos,
            PA = PA,
            IP = IP,
            PrimaryWAR = Primary.WAR,
            TotalWAR = Total.WAR,
            Year = Year)

##### write WAR

write.csv(WAR, "WAR.csv", row.names = FALSE)
