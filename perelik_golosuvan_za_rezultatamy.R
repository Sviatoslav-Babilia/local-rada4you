
library(jsonlite) #Запускаємо необхідні для роботи бібліотеки

lv_div <- fromJSON(readLines('https://lviv.rada4you.org/api/divisions.json', warn = "F", encoding = "UTF-8")) #Зчитуємо дані для формування переліку ідентифікаторів голосувань

#first_el <- as.numeric (lv_div$id [2]) #зчитуємо id (ідентифікатор) першого голосування
first_el <- 18
num_div <- as.numeric (lv_div$count[[1]]) #зчитуємо загальну кількість голосувань
final_id <- first_el + num_div - 1 #визначаємо id (ідентифікатор) останнього голосування

voting_names_koz <- data.frame() # створюємо пустий датафрейм для запису в нього даних
count <- 0
for (i in first_el:final_id){ # Прописуєм цикл, який перебиратиме ID від першого до останнього голосування 
  url <- sprintf("https://lviv.rada4you.org/api/division.json?division=%s", i) # формуємо посилання на адресу з інформацією про голосування, яка змінюватиметься в циклі
  res_names <- fromJSON(readLines(url, warn = "F", encoding = "UTF-8")) #зчитуємо поточне голосування
  res_kozlovskiy <- subset (res_names$votes, res_names$votes$deputy_id == 31) # Виділяємо результат голосування обраного депутата з ID = 31
  if (i != 2853) {
    if (res_names$date > "2017-01-01" & res_names$date < "2018-01-01") {
      if (res_kozlovskiy$vote == "aye") { # З переліку голосувань обираємо за потрібним критерієм результату голосування
      count <- count + 1 # Лічильник для отримання кількості голосувань
      b = data.frame(id = res_names$id, #формуємо рядок з інформацією про потрібне голосування для запису у наш датафрейм
                     date = res_names$date,
                     number = res_names$number,
                     name = res_names$name,
                     clock_time = res_names$clock_time,
                     result = res_names$result)
      print(b)
      voting_names_koz <- rbind (voting_names_koz, b) #приєднуємо наш рядок до загалльного датафрейму
      }
      }
    }
  print(i) #допоміжний рядок для візуалізації стану виконання програми
}

write.csv (voting_names_koz, file = "result_names.csv", row.names = F) #формуємо з отриманого датафрейму csv-файл
