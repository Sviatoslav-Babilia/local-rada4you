install.packages("jsonlite") #інсталюємо необхідні для роботи пакети
install.packages("dplyr")


library(jsonlite) #Запусткаємо необхідні для роботи бібліотеки
library(dplyr)

kh_dep <- fromJSON(readLines('https://lviv.rada4you.org/api/mps.json', warn = "F", encoding = "UTF-8")) #зчитуємо інформацію про депутатів міської ради


voting_results <- data.frame() #формуємо пустий датафрейм, куди записуватимемо статистику голосувань по кожному депутату 

for (i in kh_dep$deputy_id) { #в циклі перебираємо ідентифікатори кожного депутата
  url <- sprintf("https://lviv.rada4you.org/api/mp.json?deputy_id=%s", i) #формуємо посилання на сторінку депутата з помісячними статистичниими даними
  res_march <- fromJSON(readLines(url, warn = "F")) #зчитуємо дані поточної сторінки
  res_march1 <- res_march$mp_infos #виділяємо статистичні дані результатів голосувань
  k <- filter(res_march1, res_march1$date_mp_info > "2017-12-01" & res_march1$date_mp_info < "2018-06-01") #формуємо перелік за потрібний нам період
  z <- filter (kh_dep, kh_dep$deputy_id == i) #виділяємо прізвище і ім'я поточного депутата
  #Створюємо рядок з наступними даними
  a = data.frame(first_name = z$first_name, #Ім'я
                 last_name = z$last_name, # прізвище
                 dep_id = i, # ідентифікатор депутата
                 rebellions = sum (k$rebellions), # сума голосів проти лінії фракції. Для позафракційних, або представників фракцій де <5 депутатів цей показник не обчислюється
                 not_voted = sum (k$not_voted), #кількість голосів "Не голосував"
                 absent = sum (k$absent), # кількість голосувань, коли депутат відсутній
                 against = sum (k$against), # кількість голосувань "Проти"
                 aye_voted = sum (k$aye_voted), # кількість голосувань "За"
                 abstain = sum (k$abstain), # кількість голосувань "утримався"
                 votes_possible = sum (k$votes_possible), #Загальна кількість голосувань
                 votes_attended = sum (k$votes_attended)) #Кількість голосувань, під час яких депутат був присутній
  
  voting_results <- rbind(voting_results, a) #Прив'язуємо утворений рядок до датафрейму
  print (i) #Допоміжні рядки для демонстрації виконання програми
  print(z)
}

write.csv (voting_results, file = "lviv_period.csv", row.names = F) #Записуємо результати в csv-файл