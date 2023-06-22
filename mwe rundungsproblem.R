#Excel-Datei einlesen, dann: 
select(Dokumentgruppe, Dokumentname, Anfang, Ende, Code)%>%
filter(Dokumentgruppe == "Konsens")%>%
  mutate(Anfang_2 = str_sub(Anfang, -1), # Zehntelsekunde, d.h. Stelle hinterm Komma extrahieren
         Ende_2 = str_sub(Ende, -1))%>% # Zehntelsekunde, d.h. Stelle hinterm Komma extrahieren 
  mutate(start_1 = ymd_hms(ymd("2000-01-01") + hms(Anfang)), 
         end_1 = ymd_hms(ymd("2000-01-01") + hms(Ende)), 
         turnID = 1:n(),
         code = Code)%>%
  mutate(start = case_when(Anfang_2 > 4 ~ (ymd_hms(start_1) + seconds(1)), TRUE~ ymd_hms(start_1)))%>% # aufrunden ab 5 oder mehr Zehntelsekunden, sonst abrunden für Start 
  mutate(end = case_when(Ende_2 > 4 ~ (ymd_hms(end_1) + seconds(1)), TRUE ~ ymd_hms(end_1)))%>% # aufrunden ab 5 oder mehr Zehntelsekunden, sonst abrunden für Ende
  select(Dokumentname, Dokumentgruppe, code, turnID, start, end)