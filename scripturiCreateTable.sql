--CREATE TABLE
--------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Businessuri
(
    id_business NUMBER(4) NOT NULL PRIMARY KEY,
    nume VARCHAR2(20) NOT NULL,
    email VARCHAR2(30) NOT NULL,
    ceo VARCHAR2(20),
    data_infiintare DATE,
CONSTRAINT NUME_BUSINESS_UK UNIQUE (nume),
CONSTRAINT EMAIL_BUSINESS_UK UNIQUE (email)
);
--------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Reclame
(
    id_reclama NUMBER(4) NOT NULL PRIMARY KEY,
    nume VARCHAR2(20) NOT NULL,
    durata NUMBER(3,2),
    descriere VARCHAR2(50) ,
CONSTRAINT NUME_RECLAMA_UK UNIQUE (nume)
);
--------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Utilizatori
(
    id_utilizator NUMBER(4) NOT NULL PRIMARY KEY,
    nume VARCHAR2(10) NOT NULL,
    prenume VARCHAR2(20) NOT NULL,
    email VARCHAR2(30) NOT NULL,
    data_nastere DATE NOT NULL,
    gen VARCHAR2(10),
    nume_creator VARCHAR2(20),
    CONSTRAINT EMAIL_UTILIZATOR_UK UNIQUE (email),
    CONSTRAINT NUME_CREATOR_UK UNIQUE (nume_creator)
);
--------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Contracte_de_sponsorizare
(
    numar_contract NUMBER(4),
    id_utilizator NUMBER(4),
    id_business NUMBER(4),
    data_semnare DATE NOT NULL,
    valoare NUMBER(8,2) NOT NULL,
    descriere VARCHAR2(50),
    PRIMARY KEY (numar_contract, id_utilizator, id_business),
    CONSTRAINT ID_UTIL_CONTRACT_FK FOREIGN KEY (id_utilizator) REFERENCES utilizatori (id_utilizator),
    CONSTRAINT ID_BIS_CONTRACT_FK FOREIGN KEY (id_business) REFERENCES businessuri (id_business)
);
--------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Channels
(
    id_channel NUMBER(4) NOT NULL PRIMARY KEY,
    nume VARCHAR2(20) NOT NULL,
    data_deschidere DATE NOT NULL,
    tip VARCHAR2(10) NOT NULL,
    descriere VARCHAR2(50),
    id_utilizator NUMBER(4) NOT NULL,
    CONSTRAINT ID_UTIL_CHANNEL_FK FOREIGN KEY (id_utilizator) REFERENCES utilizatori (id_utilizator),
    CONSTRAINT NUME_CHANNEL_UK UNIQUE (nume)
);
--------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Abonamente
(
    id_abonament NUMBER(4),
    tip VARCHAR2(10) NOT NULL,
    data_abonare DATE NOT NULL,
    id_utilizator NUMBER(4),
    id_channel NUMBER(4),
    PRIMARY KEY(id_abonament, id_utilizator, id_channel),
    CONSTRAINT ID_UTIL_ABONAMENT_FK FOREIGN KEY (id_utilizator) REFERENCES utilizatori (id_utilizator),
    CONSTRAINT ID_CHN_ABONAMENT_FK FOREIGN KEY (id_channel) REFERENCES channels (id_channel)
);
--------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Videos
(
    id_video NUMBER(4) NOT NULL PRIMARY KEY,
    tip VARCHAR2(15) NOT NULL,
    data_upload DATE NOT NULL,
    durata NUMBER(5,2) NOT NULL,
    id_channel NUMBER(4) NOT NULL,
    CONSTRAINT ID_CHN_VIDEO_FK FOREIGN KEY (id_channel) REFERENCES channels (id_channel)
);
--------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Comentarii
(
    id_coment NUMBER(4),
    data_postare DATE NOT NULL,
    descriere VARCHAR2(50),
    id_video NUMBER(4),
    id_utilizator NUMBER(4),
    PRIMARY KEY (id_coment, id_video, id_utilizator),
    CONSTRAINT ID_VIDEO_COMENT_FK FOREIGN KEY (id_video) REFERENCES videos (id_video),
    CONSTRAINT ID_UTIL_COMENT_FK FOREIGN KEY (id_utilizator) REFERENCES utilizatori (id_utilizator)
);
--------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Promovari
(
    id_promovare NUMBER(4),
    descriere VARCHAR2(50),
    id_video NUMBER(4),
    id_reclama NUMBER(4),
    PRIMARY KEY (id_promovare, id_video, id_reclama),
    CONSTRAINT ID_VIDEO_PROMO_FK FOREIGN KEY (id_video) REFERENCES videos (id_video),
    CONSTRAINT ID_RCL_PROMO_FK FOREIGN KEY (id_reclama) REFERENCES reclame (id_reclama)
);
