install.packages("jsonlite") #���������� ��������� ��� ������ ������
install.packages("dplyr")


library(jsonlite) #���������� ��������� ��� ������ ��������
library(dplyr)

kh_dep <- fromJSON(readLines('https://lviv.rada4you.org/api/mps.json', warn = "F", encoding = "UTF-8")) #������� ���������� ��� �������� ����� ����


voting_results <- data.frame() #������� ������ ���������, ���� �������������� ���������� ���������� �� ������� �������� 

for (i in kh_dep$deputy_id) { #� ���� ���������� �������������� ������� ��������
  url <- sprintf("https://lviv.rada4you.org/api/mp.json?deputy_id=%s", i) #������� ��������� �� ������� �������� � ���������� �������������� ������
  res_march <- fromJSON(readLines(url, warn = "F")) #������� ���� ������� �������
  res_march1 <- res_march$mp_infos #�������� ����������� ���� ���������� ����������
  k <- filter(res_march1, res_march1$date_mp_info > "2017-12-01" & res_march1$date_mp_info < "2018-06-01") #������� ������ �� �������� ��� �����
  z <- filter (kh_dep, kh_dep$deputy_id == i) #�������� ������� � ��'� ��������� ��������
  #��������� ����� � ���������� ������
  a = data.frame(first_name = z$first_name, #��'�
                 last_name = z$last_name, # �������
                 dep_id = i, # ������������� ��������
                 rebellions = sum (k$rebellions), # ���� ������ ����� ���� �������. ��� ��������������, ��� ������������ ������� �� <5 �������� ��� �������� �� ������������
                 not_voted = sum (k$not_voted), #������� ������ "�� ���������"
                 absent = sum (k$absent), # ������� ����������, ���� ������� ��������
                 against = sum (k$against), # ������� ���������� "�����"
                 aye_voted = sum (k$aye_voted), # ������� ���������� "��"
                 abstain = sum (k$abstain), # ������� ���������� "���������"
                 votes_possible = sum (k$votes_possible), #�������� ������� ����������
                 votes_attended = sum (k$votes_attended)) #ʳ������ ����������, �� ��� ���� ������� ��� ���������
  
  voting_results <- rbind(voting_results, a) #����'����� ��������� ����� �� ����������
  print (i) #�������� ����� ��� ������������ ��������� ��������
  print(z)
}

write.csv (voting_results, file = "lviv_period.csv", row.names = F) #�������� ���������� � csv-����