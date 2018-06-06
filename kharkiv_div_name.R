install.packages("") #���������� ����� jsonlite

library(jsonlite) #��������� ��������� ��� ������ ��������
library(dplyr)
library(stringr)

kh_div <- fromJSON(readLines('https://kharkiv.rada4you.org/api/divisions.json', warn = "F", encoding = "UTF-8"))

first_el <- as.numeric (kh_div$id [2]) #������� id (�������������) ������� �����������
num_div <- as.numeric (kh_div$count[[1]]) #������� �������� ������� ����������
final_id <- first_el + num_div - 1 #��������� id (�������������) ���������� �����������

voting_names <- data.frame() # ��������� ������� ��������� ��� ������ � ����� �����

for (i in first_el:final_id){ # �������� ����, ���� ������������ ID �� ������� �� ���������� ����������� 
  url <- sprintf("https://kharkiv.rada4you.org/api/division.json?division=%s", i) # ������� ��������� �� ������ � ����������� ��� �����������, ��� �������������� � ����
    res_names <- fromJSON(readLines(url, warn = "F", encoding = "UTF-8")) #������� ������� �����������
    b = data.frame(id = res_names$id, #������� ����� � ����������� ��� ������� ����������� ��� ������ � ��� ���������
                   date = res_names$date,
                   number = res_names$number,
                   name = res_names$name,
                   clock_time = res_names$clock_time)
  voting_names <- rbind (voting_names, b) #�������� ��� ����� �� ����������� ����������
  print(i)
}
  
write.csv (voting_names, file = "kharkiv_names.csv", row.names = F) #������� � ���������� ���������� csv-����