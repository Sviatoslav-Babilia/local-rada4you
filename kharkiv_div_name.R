install.packages("") #інсталюємо пакет jsonlite

library(jsonlite) #Запускаємо необхідні для роботи бібліотеки
library(dplyr)
library(stringr)

kh_div <- fromJSON(readLines('https://kharkiv.rada4you.org/api/divisions.json', warn = "F", encoding = "UTF-8"))

first_el <- as.numeric (kh_div$id [2]) #зчитуємо id (ідентифікатор) першого голосування
num_div <- as.numeric (kh_div$count[[1]]) #зчитуємо загальну кількість голосувань
final_id <- first_el + num_div - 1 #визначаємо id (ідентифікатор) останнього голосування

voting_names <- data.frame() # створюємо путстий датафрейм для запису в нього даних

for (i in first_el:final_id){ # Прописуєм цикл, який перебиратиме ID від першого до останнього голосування 
  url <- sprintf("https://kharkiv.rada4you.org/api/division.json?division=%s", i) # формуємо посилання на адресу з інформацією про голосування, яка змінюватиметься в циклі
    res_names <- fromJSON(readLines(url, warn = "F", encoding = "UTF-8")) #зчитуємо поточне голосування
    b = data.frame(id = res_names$id, #формуємо рядок з інформацією про потрібне голосування для запису у наш датафрейм
                   date = res_names$date,
                   number = res_names$number,
                   name = res_names$name,
                   clock_time = res_names$clock_time)
  voting_names <- rbind (voting_names, b) #приєднуємо наш рядок до загалльного датафрейму
  print(i)
}
  
write.csv (voting_names, file = "kharkiv_names.csv", row.names = F) #формуємо з отриманого датафрейму csv-файл
