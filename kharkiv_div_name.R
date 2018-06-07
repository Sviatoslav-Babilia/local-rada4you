install.packages("jsonlite") #³íñòàëþºìî ïàêåò jsonlite

library(jsonlite) #Çàïóñêàºìî íåîáõ³äí³ äëÿ ðîáîòè á³áë³îòåêè
library(dplyr)
library(stringr)

kh_div <- fromJSON(readLines('https://kharkiv.rada4you.org/api/divisions.json', warn = "F", encoding = "UTF-8"))

first_el <- as.numeric (kh_div$id [2]) #ç÷èòóºìî id (³äåíòèô³êàòîð) ïåðøîãî ãîëîñóâàííÿ
num_div <- as.numeric (kh_div$count[[1]]) #ç÷èòóºìî çàãàëüíó ê³ëüê³ñòü ãîëîñóâàíü
final_id <- first_el + num_div - 1 #âèçíà÷àºìî id (³äåíòèô³êàòîð) îñòàííüîãî ãîëîñóâàííÿ

voting_names <- data.frame() # ñòâîðþºìî ïóòñòèé äàòàôðåéì äëÿ çàïèñó â íüîãî äàíèõ

for (i in first_el:final_id){ # Ïðîïèñóºì öèêë, ÿêèé ïåðåáèðàòèìå ID â³ä ïåðøîãî äî îñòàííüîãî ãîëîñóâàííÿ 
  url <- sprintf("https://kharkiv.rada4you.org/api/division.json?division=%s", i) # ôîðìóºìî ïîñèëàííÿ íà àäðåñó ç ³íôîðìàö³ºþ ïðî ãîëîñóâàííÿ, ÿêà çì³íþâàòèìåòüñÿ â öèêë³
    res_names <- fromJSON(readLines(url, warn = "F", encoding = "UTF-8")) #ç÷èòóºìî ïîòî÷íå ãîëîñóâàííÿ
    b = data.frame(id = res_names$id, #ôîðìóºìî ðÿäîê ç ³íôîðìàö³ºþ ïðî ïîòð³áíå ãîëîñóâàííÿ äëÿ çàïèñó ó íàø äàòàôðåéì
                   date = res_names$date,
                   number = res_names$number,
                   name = res_names$name,
                   clock_time = res_names$clock_time)
  voting_names <- rbind (voting_names, b) #ïðèºäíóºìî íàø ðÿäîê äî çàãàëëüíîãî äàòàôðåéìó
  print(i)
}
  
write.csv (voting_names, file = "kharkiv_names.csv", row.names = F) #ôîðìóºìî ç îòðèìàíîãî äàòàôðåéìó csv-ôàéë
