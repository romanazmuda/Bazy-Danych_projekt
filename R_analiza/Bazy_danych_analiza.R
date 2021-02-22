rm(list=ls())

library(tidyverse)
library(RMySQL)
library(RMariaDB)
library(DBI)
library(dbplyr)
library(dplyr)
library(lubridate)

db_con <- DBI::dbConnect(drv=RMySQL::MySQL(), #lączenie z bazą danych
                         username = 'team4',
                         password = 't3@mAP@55',
                         db = 'team4',
                         host = 'giniewicz.it',
                         port = 3306)




ekipa <- as.data.frame(tbl(db_con, "Ekipa"))
kwalifikacje <- as.data.frame(tbl(db_con, "Kwalifikacje"))
pracownicy <- as.data.frame(tbl(db_con, "Pracownicy"))
zlecenia <- as.data.frame(tbl(db_con, "Zlecenia"))
pakiet <- as.data.frame(tbl(db_con, "PakietSprzetowy"))
materialy <- as.data.frame(tbl(db_con, "ZestawMaterialu"))
klient <- as.data.frame(tbl(db_con, "Klient"))
koszty <- as.data.frame(tbl(db_con, "KosztyStale"))



head(pracownicy) 
head(ekipa)
head(materialy)
head(kwalifikacje)
head(materialy)
head(zlecenia)

########################################################



#Zadanie 1

oczekujace_zlecenia <- as.data.frame(zlecenia %>%
  mutate(m_przyj=month(Data_przyjecia_zlecenia), r_przyj=year(Data_przyjecia_zlecenia),
         m_rozp=month(Data_rozpoczecia_prac), r_rozp=year(Data_rozpoczecia_prac)) %>%
         group_by(r_przyj, m_przyj,r_rozp,m_rozp) %>%
          tally() %>% #Liczymy unikatowe wartości
          collect()) #Wymusza zapytanie
#tally liczy unikatowe zlecenia


x <- as.vector(c('styczeń',' ','luty',' ', 'marzec',' ','kwiecień',' ','maj',' ','czerwiec',' ','lipiec',
       ' ', 'sierpień', ' ', 'wrzesień', ' ','październik',' ', 'listopad',' ','grudzień',' ','styczeń',
       '', 'luty', ' '))
plot(oczekujace_zlecenia$n, ylab='Liczba oczekujących zleceń',
     main='Zmiana liczby oczekujących zleceń w czasie',xaxt="n",col='red')
lines(oczekujace_zlecenia$n)
grid()
axis(1, at = seq(1, 28, by = 1), labels=x, las=2)
points(x = c(1,3,5,7,9,11,13,15,17,19,21,23,25,27), 
       y = oczekujace_zlecenia$n[which(oczekujace_zlecenia$m_przyj == oczekujace_zlecenia$m_rozp)],
       col = 'green')

legenda <- c('Okresy przejściowe', 'Okresy nieprzejściowe')
legend('bottom' ,legend = legenda, fill=c('red', 'green'))


################################################################
#Zadanie 2
head(ekipa)
head(zlecenia)

zapytanie_2 <- dbGetQuery(db_con, "
                          SELECT Id_zlecenia, Pracownik_1, Pracownik_2, Pracownik_3, Pracownik_4,
                          Data_rozpoczecia_prac, Data_zakonczenia_prac
                          FROM Zlecenia
                          INNER JOIN Ekipa
                          ON Zlecenia.Id_ekipa = Ekipa.Id_ekipa;
                          ")


pracownicy <- as.data.frame(zapytanie_2 %>%
                            mutate(m_rozp=month(Data_rozpoczecia_prac), 
                                   r_zak=year(Data_zakonczenia_prac),
                                   r_rozp=year(Data_rozpoczecia_prac),
                                   m_zak=month(Data_zakonczenia_prac)) %>%
                            group_by(r_rozp, m_rozp, r_zak, m_zak) %>%
                            tally() %>% #Liczymy unikatowe wartości
                            collect()) #Wymusza zapytanie

x_1 <- as.vector(c('styczeń',' ','luty',' ', 'marzec',' ','kwiecień',' ','maj',' ','czerwiec',' ','lipiec',
                 ' ', 'sierpień', ' ', 'wrzesień', ' ','październik',' ', 'listopad',' ','grudzień',' ','styczeń',
                 '', 'luty', ' ','marzec'))

plot(pracownicy$n, ylab='Liczba czynnych pracowników w ciągu każdego miesiąca',
     main='Zmiana liczby czynnych pracowników w ciągu każdego miesiąca',xaxt="n",col='red')
lines(pracownicy$n)
grid()
axis(1, at = seq(1, 29, by = 1), labels=x_1, las=2)
points(x = c(1,3,5,7,9,11,13,15,17,19,21,23,25,27,29), 
       y = pracownicy$n[which(pracownicy$m_rozp == pracownicy$m_zak)],
       col = 'green')

legenda <- c('Okresy przejściowe', 'Okresy nieprzejściowe')
legend('bottom' ,legend = legenda, fill=c('red', 'green'))


################################################################

#Zadanie 3

head(zlecenia)


zapytanie_3_koszty_stale <- dbGetQuery(db_con, "
                          SELECT
                          SUM(Wyplata_finanse) AS S1, SUM(Wyplata_administracja) AS S2,
                          SUM(Zaplata_usluga_gwarancji) AS S3
                          FROM KosztyStale;
                          ")


koszty_stale_bilans <- sum(zapytanie_3_koszty_stale)

materialy_bilans <- as.double(dbGetQuery(db_con, "
                                    SELECT SUM(Cena_kupna)
                                    FROM ZestawMaterialu
                                    "))


bilans <- sum(zlecenia$Cena_zysku_ekipy)+sum(zlecenia$Cena_materialu_zlecenia)-koszty_stale_bilans-materialy_bilans
#Bilans = zysk_fimy_z_ekipy - wynagrodzenie dla pracowników i ekip
bilans
sum(zlecenia$Cena_materialu_zlecenia)

#####################################################################
#Zadanie 4 -  Stwórz listę osób najdłużej czekających na remont

zapytanie_4 <- dbGetQuery(db_con, "SELECT Imie, Nazwisko, DATEDIFF(Data_rozpoczecia_prac, Data_przyjecia_zlecenia) AS Czas
                          FROM Klient
                          INNER JOIN Zlecenia
                          ON Zlecenia.Id_klienta = Klient.Id_klienta
                          ORDER BY Czas DESC;
                          ")

zapytanie_4
######################################################


#Zadanie 5

#Zadanie 5_1 - stworzyc histogram Czasu oczekiwania na remont, podac średni czas oczekiwania, mediane
hist(zapytanie_4$Czas, main='Histogram czasu oczekiwania na remont', xlab = 'Czas oczekiwania w dniach',
     ylab='Czestość')


mean(zapytanie_4$Czas)
median(zapytanie_4$Czas)
summary(zapytanie_4)


#Zadanie 5_2 - procentowy wklad zysku z ekipy w ogólnym zysku, na czym zaroliliśmy najwiecej?
zysk <- sum(zlecenia$Cena_zysku_ekipy) + sum(zlecenia$Cena_materialu_zlecenia)
(sum(zlecenia$Cena_zysku_ekipy)/zysk)*100 #Procent, czyli cos z tych materialów zarobiliśmy

pensja_stacjonarnych <- sum(koszty$Wyplata_finanse)+sum(koszty$Wyplata_administracja)
koszt_serwis_gwarancyjny <- sum(koszty$Zaplata_usluga_gwarancji)
pensja_robole <- sum(zlecenia$Cena_zlecenia_ekipy) - sum(zlecenia$Cena_zysku_ekipy)
#Na co najwiecej wydaliśmy?
wydatki <- pensja_stacjonarnych+koszt_serwis_gwarancyjny+pensja_robole

nazwy <- c("Pensja pracowników biurowych", "Pensja pracowników fizyczynych", "Koszt serwisu gwarancyjnego")
wydatki_proc <- c(pensja_stacjonarnych/wydatki, pensja_robole/wydatki, koszt_serwis_gwarancyjny/wydatki)
kolory <- c('green', 'red', 'blue')
pie(wydatki_proc, col=kolory)
legend(0.4,1.08,legend=nazwy,bty="n",
       fill=kolory, cex=0.8)

head(zlecenia)

#Zapytanie 5_3 - Które zlecenia trwaly najwiecej dni i jakie ekipy je wykonywaly?

zapytanie_5_3 <- dbGetQuery(db_con, "
                            SELECT Id_ekipa, Id_zlecenia,
                            DATEDIFF(Data_zakonczenia_prac, Data_rozpoczecia_prac) AS Czas_pracy
                            FROM Zlecenia
                            GROUP BY Id_ekipa, Id_zlecenia
                            ORDER BY Czas_pracy DESC;
                            ")


hist(zapytanie_5_3$Czas_pracy)


zapytanie_5_3
#Zapytanie 5_4 - Jaki sprzet byl najcześciej wykorzystywany?
zapytanie_5_4 <- dbGetQuery(db_con, "
                            SELECT Pakiet_sprzetu, COUNT(Pakiet_sprzetu) AS
                            Najczestszy_sprzet
                            FROM Ekipa
                            INNER JOIN Zlecenia
                            ON Ekipa.Id_ekipa = Zlecenia.Id_ekipa
                            GROUP BY Pakiet_sprzetu
                            ORDER BY Najczestszy_sprzet DESC
                            LIMIT 1;
                            ")

zapytanie_5_4
