
DROP TABLE IF EXISTS ZestawMaterialu;
CREATE TABLE ZestawMaterialu
(
  Id_materialow   INT         NOT NULL AUTO_INCREMENT,
  Zestaw_material VARCHAR(30) NULL    ,
  Cena_kupna      DOUBLE      NULL    ,
  Cena_sprzedazy  DOUBLE      NULL    ,
  PRIMARY KEY (Id_materialow)
);


INSERT INTO ZestawMaterialu (Zestaw_material, Cena_kupna, Cena_sprzedazy) VALUES
   ("Zestaw 1", "199", "250");





DROP TABLE IF EXISTS Klient;
CREATE TABLE Klient
(
  Id_klienta INT AUTO_INCREMENT PRIMARY KEY,
  Imie VARCHAR(64) NULL,
  Nazwisko VARCHAR(64) NULL,
  Telefon VARCHAR(64) NULL,
  Miasto VARCHAR(64) NULL,
  Kod_pocztowy VARCHAR(64) NULL,
  Adres VARCHAR(264) NULL    
);



DROP TABLE IF EXISTS Kwalifikacje;
CREATE TABLE Kwalifikacje
(
  Id_kwalifikacji INT AUTO_INCREMENT PRIMARY KEY,
  Kwalifikacja    VARCHAR(30) NULL
);




DROP TABLE IF EXISTS PakietSprzetowy;
CREATE TABLE PakietSprzetowy
(
  Id_sprzet   INT AUTO_INCREMENT PRIMARY KEY,
  Typ_pakietu VARCHAR(60) NULL
);


DROP TABLE IF EXISTS Pracownicy;
CREATE TABLE Pracownicy
(
  Id_pracownika   INT         NOT NULL AUTO_INCREMENT,
  Id_kwalifikacji INT         NULL    ,
  Imie            VARCHAR(30) NOT NULL,
  Nazwisko        VARCHAR(30) NOT NULL,
  Telefon         VARCHAR(24) NULL    ,
  PRIMARY KEY (Id_pracownika)
);

ALTER TABLE Pracownicy
  ADD CONSTRAINT FK_Kwalifikacje_TO_Pracownicy
    FOREIGN KEY (Id_kwalifikacji)
    REFERENCES Kwalifikacje (Id_kwalifikacji);


DROP TABLE IF EXISTS KosztyStałe;
CREATE TABLE KosztyStałe
(
  Id_miesiaca              INT    NOT NULL AUTO_INCREMENT,
  Pracownik_finanse        INT    NULL    ,
  Wyplata_finanse          DOUBLE NULL    ,
  Pracownik_administracja  INT    NULL    ,
  Wyplata_administracja    DOUBLE       NULL    ,
  Zaplata_usluga_gwarancji DOUBLE NULL    ,
  PRIMARY KEY (Id_miesiaca)
);
ALTER TABLE KosztyStałe
  ADD CONSTRAINT FK_Pracownicy_TO_KosztyStałe
    FOREIGN KEY (Pracownik_finanse)
    REFERENCES Pracownicy (Id_pracownika);

ALTER TABLE KosztyStałe
  ADD CONSTRAINT FK_Pracownicy_TO_KosztyStałe1
    FOREIGN KEY (Pracownik_administracja)
    REFERENCES Pracownicy (Id_pracownika);


DROP TABLE IF EXISTS Ekipa;
CREATE TABLE Ekipa
(
  Id_ekipa            INT    NOT NULL AUTO_INCREMENT,
  Pracownik_1         INT    NULL    ,
  Pracownik_2         INT    NULL    ,
  Pracownik_3         INT    NULL    ,
  Pracownik_4         INT    NULL    ,
  Pakiet_sprzetu      INT    NULL    ,
  Cena_zlecenia_ekipy DOUBLE NULL     COMMENT 'Jeden dzien pracy',
  Zysk_firmy_ekipy    DOUBLE NULL    ,
  PRIMARY KEY (Id_ekipa)
);

ALTER TABLE Ekipa
  ADD CONSTRAINT FK_Pracownicy_TO_Ekipa
    FOREIGN KEY (Pracownik_1)
    REFERENCES Pracownicy (Id_pracownika);

ALTER TABLE Ekipa
  ADD CONSTRAINT FK_PakietSprzetowy_TO_Ekipa
    FOREIGN KEY (Pakiet_sprzetu)
    REFERENCES PakietSprzetowy (Id_sprzet);
ALTER TABLE Ekipa
  ADD CONSTRAINT FK_Pracownicy_TO_Ekipa1
    FOREIGN KEY (Pracownik_2)
    REFERENCES Pracownicy (Id_pracownika);

ALTER TABLE Ekipa
  ADD CONSTRAINT FK_Pracownicy_TO_Ekipa2
    FOREIGN KEY (Pracownik_3)
    REFERENCES Pracownicy (Id_pracownika);

ALTER TABLE Ekipa
  ADD CONSTRAINT FK_Pracownicy_TO_Ekipa3
    FOREIGN KEY (Pracownik_4)
    REFERENCES Pracownicy (Id_pracownika);


DROP TABLE IF EXISTS Zlecenia;
CREATE TABLE Zlecenia
(
  Id_zlecenia                INT    NOT NULL AUTO_INCREMENT,
  Id_klienta                 INT    NULL    ,
  Id_ekipa                   INT    NULL    ,
  Id_materialow              INT    NULL    ,
  Data_przyjecia_zlecenia    DATE   NULL    ,
  Data_rozpoczecia_prac      DATE   NULL    ,
  Data_zakonczenia_prac      DATE   NULL    ,
  Data_zakonczenia_gwarancji DATE   NULL    ,
  Cena_zlecenia_ekipy        DOUBLE NULL    ,
  Cena_zysku_ekipy           DOUBLE NULL    ,
  Cena_materialu_zlecenia    DOUBLE NULL    ,
  Cena_zysku_materialu       DOUBLE NULL    ,
  PRIMARY KEY (Id_zlecenia)
);

ALTER TABLE Zlecenia
  ADD CONSTRAINT FK_Ekipa_TO_Zlecenia
    FOREIGN KEY (Id_ekipa)
    REFERENCES Ekipa (Id_ekipa);

ALTER TABLE Zlecenia
  ADD CONSTRAINT FK_Klient_TO_Zlecenia
    FOREIGN KEY (Id_klienta)
    REFERENCES Klient (Id_klienta);



ALTER TABLE Zlecenia
  ADD CONSTRAINT FK_ZestawMaterialu_TO_Zlecenia
    FOREIGN KEY (Id_materialow)
    REFERENCES ZestawMaterialu (Id_materialow);
