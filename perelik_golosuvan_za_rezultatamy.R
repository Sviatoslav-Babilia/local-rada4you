
library(jsonlite) #��������� ��������� ��� ������ ��������

lv_div <- fromJSON(readLines('https://lviv.rada4you.org/api/divisions.json', warn = "F", encoding = "UTF-8")) #������� ���� ��� ���������� ������� �������������� ����������

#first_el <- as.numeric (lv_div$id [2]) #������� id (�������������) ������� �����������
first_el <- 18
num_div <- as.numeric (lv_div$count[[1]]) #������� �������� ������� ����������
final_id <- first_el + num_div - 1 #��������� id (�������������) ���������� �����������

voting_names_koz <- data.frame() # ��������� ������ ��������� ��� ������ � ����� �����
count <- 0
for (i in first_el:final_id){ # �������� ����, ���� ������������ ID �� ������� �� ���������� ����������� 
  url <- sprintf("https://lviv.rada4you.org/api/division.json?division=%s", i) # ������� ��������� �� ������ � ����������� ��� �����������, ��� �������������� � ����
  res_names <- fromJSON(readLines(url, warn = "F", encoding = "UTF-8")) #������� ������� �����������
  res_kozlovskiy <- subset (res_names$votes, res_names$votes$deputy_id == 31) # �������� ��������� ����������� �������� �������� � ID = 31
  if (i != 2853) {
    if (res_names$date > "2017-01-01" & res_names$date < "2018-01-01") {
      if (res_kozlovskiy$vote == "aye") { # � ������� ���������� ������� �� �������� ������� ���������� �����������
      count <- count + 1 # ˳������� ��� ��������� ������� ����������
      b = data.frame(id = res_names$id, #������� ����� � ����������� ��� ������� ����������� ��� ������ � ��� ���������
                     date = res_names$date,
                     number = res_names$number,
                     name = res_names$name,
                     clock_time = res_names$clock_time,
                     result = res_names$result)
      print(b)
      voting_names_koz <- rbind (voting_names_koz, b) #�������� ��� ����� �� ����������� ����������
      }
      }
    }
  print(i) #��������� ����� ��� ���������� ����� ��������� ��������
}

write.csv (voting_names_koz, file = "result_names.csv", row.names = F) #������� � ���������� ���������� csv-����