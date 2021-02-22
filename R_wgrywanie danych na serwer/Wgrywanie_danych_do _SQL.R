#wgrywanie danych
install.packages("xlsx")
library(xlsx)

#dbConnect z RMariaDB
install.packages("RMariaDB")
library(RMariaDB)

# to musisz zrobiæ, jak chcesz robiæ cokolwiek z serwerem
con_team4 <- dbConnect(RMariaDB::MariaDB(), host = "giniewicz.it",
                       user = "team4", password = "t3@mAP@55", dbname="team4")



#Program do losowania ekip
rm(list=ls())
dane <- read.xlsx("C:/Users/roman/OneDrive/Pulpit/BAZA_projekt/Tabele_wype³nione.xlsx",
                  sheetName = "Zlecenie", header = TRUE)



begin <- as.character(dane$Data_rozpoczecia_prac)
end <- as.character(dane$Data_zakonczenia_prac)
id_ekipy <- as.character(dane$Id_ekipa)

id_ekipy <- rep(0,1000)

for (k in 1:length(id_ekipy)){
  start <- begin[k]
  koniec <- end[k]
  
  dostepna <- rep(TRUE, 50)
  for (j in 1:k){
    if (
      (start <= begin[j] & koniec >= begin[j]) |
      (start <= end[j]   & koniec >= end[j]) |
      (start >= begin[j] & koniec <= end[j])
    ){
      dostepna[id_ekipy[j]] <- FALSE
    }
  }
  print(paste(c("W kroku", k, "dostepne:", which(dostepna))))
  id_ekipy[k] <- sample(which(dostepna), 1)
}

id_ekipy
Id_ekipy<-data.frame(id_ekipy)



library("writexl")
write.xlsx(Id_ekipy,"C:/Users/roman/OneDrive/Pulpit/Studia2020_21/PWR/Bazy danych/BAZA_projekt/Tabele.xlsx")



dane_Kwalifikacje<-read.xlsx2("C:/Users/roman/OneDrive/Pulpit/Studia2020_21/PWR/Bazy danych/BAZA_projekt/Tabele_wype³nione.xlsx",
                              sheetName = "Kwalifikacje", header = TRUE)
#czasami trzeba je przycinaæ bo s¹ wartoœci NA na koñcu
dane_PakietSprzetowy<-read.xlsx2("C:/Users/roman/OneDrive/Pulpit/Studia2020_21/PWR/Bazy danych/BAZA_projekt/Tabele_wype³nione.xlsx",
                              sheetName = "PakietSprzetowy", header = TRUE)
dane_Pracownicy<-read.xlsx2("C:/Users/roman/OneDrive/Pulpit/Studia2020_21/PWR/Bazy danych/BAZA_projekt/Tabele_wype³nione.xlsx",
                              sheetName = "Pracownicy", header = TRUE)
dane_Ekipa<-read.xlsx2("C:/Users/roman/OneDrive/Pulpit/Studia2020_21/PWR/Bazy danych/BAZA_projekt/Tabele_wype³nione.xlsx",
                              sheetName = "Ekipa", header = TRUE)
dane_KosztyStale<-read.xlsx2("C:/Users/roman/OneDrive/Pulpit/Studia2020_21/PWR/Bazy danych/BAZA_projekt/Tabele_wype³nione.xlsx",
                              sheetName = "KosztyStale", header = TRUE)
dane_ZestawMaterialu<-read.xlsx2("C:/Users/roman/OneDrive/Pulpit/Studia2020_21/PWR/Bazy danych/BAZA_projekt/Tabele_wype³nione.xlsx",
                              sheetName = "ZestawMaterialu", header = TRUE)
dane_Klient<-read.xlsx2("C:/Users/roman/OneDrive/Pulpit/Studia2020_21/PWR/Bazy danych/BAZA_projekt/Tabele_wype³nione.xlsx",
                                 sheetName = "Klient", header = TRUE)
dane_Zlecenie <- read.xlsx("C:/Users/roman/OneDrive/Pulpit/Studia2020_21/PWR/Bazy danych/BAZA_projekt/Tabele_wype³nione.xlsx",
                  sheetName = "Zlecenie", header = TRUE)

#wgrywanie danych do GOTOWYCH TABEL, podobna funkcja (READ) robi ¿e z sql do R
dbWriteTable(
  con_team4,
  "Kwalifikacje",
  dane_Kwalifikacje, row.names=FALSE, append = TRUE)

dbWriteTable(
  con_team4,
  "PakietSprzetowy",
  dane_PakietSprzetowy, row.names=FALSE, append = TRUE)

dbWriteTable(
  con_team4,
  "Pracownicy",
  dane_Pracownicy, row.names=FALSE, append = TRUE)

dbWriteTable(
  con_team4,
  "Ekipa",
  dane_Ekipa, row.names=FALSE, append = TRUE)

dbWriteTable(
  con_team4,
  "KosztyStale",
  dane_KosztyStale, row.names=FALSE, append = TRUE)

dbWriteTable(
  con_team4,
  "ZestawMaterialu",
  dane_ZestawMaterialu, row.names=FALSE, append = TRUE)

dbWriteTable(
  con_team4,
  "Klient",
  dane_Klient, row.names=FALSE, append = TRUE)


dbWriteTable(
  con_team4,
  "Zlecenia",
  dane_Zlecenie, row.names=FALSE, append = TRUE)
