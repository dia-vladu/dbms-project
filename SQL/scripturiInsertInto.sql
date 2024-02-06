INSERT INTO Businessuri (ID_BUSINESS, NUME, EMAIL, CEO, DATA_INFIINTARE)
VALUES(1000, 'Skillshare', 'skillshare@gmail.com', 'Matt Cooper', to_date('10-11-2010', 'dd-mm-yyyy'));

INSERT INTO Businessuri (ID_BUSINESS, NUME, EMAIL, CEO, DATA_INFIINTARE)
VALUES(1001, 'Shopify', 'shopify@gmail.com', 'Tobias Lutke', to_date('10-09-2006', 'dd-mm-yyyy'));

INSERT INTO Businessuri (ID_BUSINESS, NUME, EMAIL, CEO, DATA_INFIINTARE)
VALUES(1002, 'Candy Crush', 'candy.crush@gmail.com', 'King', to_date('12-04-2012', 'dd-mm-yyyy'));

INSERT INTO Businessuri (ID_BUSINESS, NUME, EMAIL, CEO, DATA_INFIINTARE)
VALUES(1003, 'Kylie Cosmetics', 'Kylie.Cosmetics@gmail.com', 'Kylie Jenner', to_date('19-07-2014', 'dd-mm-yyyy'));

INSERT INTO Businessuri (ID_BUSINESS, NUME, EMAIL, CEO, DATA_INFIINTARE)
VALUES(1004, 'Unicef', 'UNICEF@gmail.com', 'Ludwik Rajchman', to_date('11-12-1946', 'dd-mm-yyyy'));
--------------------------------------------------------------------------------------------------------------------------------
INSERT INTO Reclame (ID_RECLAMA, NUME, DURATA, DESCRIERE)
VALUES (500,'Buy the game now.', NULL, NULL);

INSERT INTO Reclame (ID_RECLAMA, NUME, DURATA, DESCRIERE)
VALUES (501, 'Black Friday Altex', 0.30, 'Reducere 70% la aspiratoare.');

INSERT INTO Reclame (ID_RECLAMA, NUME, DURATA, DESCRIERE)
VALUES (502,'Join now ', 1, 'Join our sport club.');

INSERT INTO Reclame (ID_RECLAMA, NUME, DURATA, DESCRIERE)
VALUES (503,'Find your half', NULL, 'Try our new dating app now.');

INSERT INTO Reclame (ID_RECLAMA, NUME, DURATA, DESCRIERE)
VALUES (504,'Colectie noua.', 1.3, NULL);
--------------------------------------------------------------------------------------------------------------------------------
INSERT INTO Utilizatori (ID_UTILIZATOR, NUME, PRENUME, EMAIL, DATA_NASTERE, GEN, NUME_CREATOR)
VALUES(0001, 'Kjellberg', 'Felix', 'felix.Kj@gmail.com', to_date('24-10-1989', 'dd-mm-yyyy'), 'masculin', 'PewDiePie');

INSERT INTO Utilizatori (ID_UTILIZATOR, NUME, PRENUME, EMAIL, DATA_NASTERE, GEN, NUME_CREATOR)
VALUES(0002, 'Okerman', 'Vince', 'vince.okerman@gmail.com', to_date('10-08-1998', 'dd-mm-yyyy'), 'masculin', 'Vexx');

INSERT INTO Utilizatori (ID_UTILIZATOR, NUME, PRENUME, EMAIL, DATA_NASTERE, GEN)
VALUES(0003, 'Vladu', 'Diana Ioana', 'diana.vladu.09@gmail.com', to_date('09-10-2001', 'dd-mm-yyyy'), 'feminin');

INSERT INTO Utilizatori (ID_UTILIZATOR, NUME, PRENUME, EMAIL, DATA_NASTERE, GEN, NUME_CREATOR)
VALUES(0004, 'Hirschi', 'Alexandra Mary', 'alexandra.hirschi@gmail.com', to_date('21-09-1985', 'dd-mm-yyyy'), 'feminin',
'Supercar Blondie');

INSERT INTO Utilizatori (ID_UTILIZATOR, NUME, PRENUME, EMAIL, DATA_NASTERE, GEN)
VALUES(0005, 'Ionescu', 'Andrei', 'andrei.ionesco@gmail.com', to_date('25-06-1999', 'dd-mm-yyyy'), 'masculin');

INSERT INTO Utilizatori (ID_UTILIZATOR, NUME, PRENUME, EMAIL, DATA_NASTERE, GEN, NUME_CREATOR)
VALUES(0006, 'Oakley', 'Gaz', 'gaz.oakley@gmail.com', to_date('24-11-1994', 'dd-mm-yyyy'), 'masculin', 'Avant-Garde Vegan');

INSERT INTO Utilizatori (ID_UTILIZATOR, NUME, PRENUME, EMAIL, DATA_NASTERE, GEN, NUME_CREATOR)
VALUES(0007, 'Steininger', 'Jeffrey', 'jeff.stein@gmail.com', to_date('15-11-1985', 'dd-mm-yyyy'), 'trans', 'Jeffrey Star');
--------------------------------------------------------------------------------------------------------------------------------
INSERT INTO Contracte_de_sponsorizare (NUMAR_CONTRACT, ID_UTILIZATOR, ID_BUSINESS, DATA_SEMNARE, VALOARE, DESCRIERE)
VALUES (11, 1, 1001, to_date('20-12-2018', 'dd-mm-yyyy'), 10000, NULL);
	
INSERT INTO Contracte_de_sponsorizare (NUMAR_CONTRACT, ID_UTILIZATOR, ID_BUSINESS, DATA_SEMNARE, VALOARE, DESCRIERE)
VALUES (12, 1, 1001, to_date('10-10-2020', 'dd-mm-yyyy'), 25000, NULL);

INSERT INTO Contracte_de_sponsorizare (NUMAR_CONTRACT, ID_UTILIZATOR, ID_BUSINESS, DATA_SEMNARE, VALOARE, DESCRIERE)
VALUES (13, 2, 1000, to_date('09-11-2021', 'dd-mm-yyyy'), 12000, NULL);

INSERT INTO Contracte_de_sponsorizare (NUMAR_CONTRACT, ID_UTILIZATOR, ID_BUSINESS, DATA_SEMNARE, VALOARE, DESCRIERE)
VALUES (14, 4, 1001, to_date('25-09-2019', 'dd-mm-yyyy'), 9000, 'Contractul contine clauze ascunse.');

INSERT INTO Contracte_de_sponsorizare (NUMAR_CONTRACT, ID_UTILIZATOR, ID_BUSINESS, DATA_SEMNARE, VALOARE, DESCRIERE)
VALUES (15, 4, 1004, to_date('11-12-2020', 'dd-mm-yyyy'), 15000, NULL);

INSERT INTO Contracte_de_sponsorizare (NUMAR_CONTRACT, ID_UTILIZATOR, ID_BUSINESS, DATA_SEMNARE, VALOARE, DESCRIERE)
VALUES (16, 7, 1001, to_date('12-03-2018', 'dd-mm-yyyy'), 25000, NULL);
--------------------------------------------------------------------------------------------------------------------------------
INSERT INTO Channels (ID_CHANNEL, NUME, DATA_DESCHIDERE, TIP, DESCRIERE, ID_UTILIZATOR)
VALUES (0201, 'Vexx Art', to_date('24-04-2015', 'dd-mm-yyyy'), 'ART', 'I am just a guy who likes to draw.', 2);

INSERT INTO Channels (ID_CHANNEL, NUME, DATA_DESCHIDERE, TIP, DESCRIERE, ID_UTILIZATOR)
VALUES (0202, 'Also Vexx', to_date('20-03-2017', 'dd-mm-yyyy'), 'ART', 'Official second channel of Vexx.', 2);

INSERT INTO Channels (ID_CHANNEL, NUME, DATA_DESCHIDERE, TIP, DESCRIERE, ID_UTILIZATOR)
VALUES (0203, 'Avantgardevegan', to_date('07-10-2016', 'dd-mm-yyyy'), 'COOKING', NULL, 6);

INSERT INTO Channels (ID_CHANNEL, NUME, DATA_DESCHIDERE, TIP, DESCRIERE, ID_UTILIZATOR)
VALUES (0204, 'Supercar Blondie', to_date('12-09-2007', 'dd-mm-yyyy'), 'ENTERTAIN.', NULL, 4);

INSERT INTO Channels (ID_CHANNEL, NUME, DATA_DESCHIDERE, TIP, DESCRIERE, ID_UTILIZATOR)
VALUES (0205, 'PewDiePie', to_date('29-04-2010', 'dd-mm-yyyy'), 'ENTERTAIN.', 'I make videos.', 1);

INSERT INTO Channels (ID_CHANNEL, NUME, DATA_DESCHIDERE, TIP, DESCRIERE, ID_UTILIZATOR)
VALUES (0206, 'PiwDiePie Highlights', to_date('21-06-2020', 'dd-mm-yyyy'), 'ENTERTAIN.', 'PewDiePie Highlights and Shorts.', 1);
--------------------------------------------------------------------------------------------------------------------------------
INSERT INTO Abonamente (ID_ABONAMENT, TIP, DATA_ABONARE, ID_UTILIZATOR, ID_CHANNEL)
VALUES (0111, 'NORMAL', to_date('29-04-2020', 'dd-mm-yyyy'), 0003, 0201);

INSERT INTO Abonamente (ID_ABONAMENT, TIP, DATA_ABONARE, ID_UTILIZATOR, ID_CHANNEL)
VALUES (0112, 'NORMAL', to_date('20-12-2020', 'dd-mm-yyyy'), 0003, 0204);

INSERT INTO Abonamente (ID_ABONAMENT, TIP, DATA_ABONARE, ID_UTILIZATOR, ID_CHANNEL)
VALUES (0113, 'PREMIUM', to_date('19-01-2021', 'dd-mm-yyyy'), 0005, 0204);

INSERT INTO Abonamente (ID_ABONAMENT, TIP, DATA_ABONARE, ID_UTILIZATOR, ID_CHANNEL)
VALUES (0114, 'NORMAL', to_date('29-04-2010', 'dd-mm-yyyy'), 0001, 0205);

INSERT INTO Abonamente (ID_ABONAMENT, TIP, DATA_ABONARE, ID_UTILIZATOR, ID_CHANNEL)
VALUES (0115, 'NORMAL', to_date('21-06-2020', 'dd-mm-yyyy'), 0001, 0206);
--------------------------------------------------------------------------------------------------------------------------------
INSERT INTO Videos (ID_VIDEO, TIP, DATA_UPLOAD, DURATA, ID_CHANNEL)
VALUES (20, 'ENTERTAINMENT', to_date('30-12-2019', 'dd-mm-yyyy'), 20.57, 0204);

INSERT INTO Videos (ID_VIDEO, TIP, DATA_UPLOAD, DURATA, ID_CHANNEL)
VALUES (21, 'ART', to_date('27-04-2019', 'dd-mm-yyyy'), 6.35, 0201);
	
INSERT INTO Videos (ID_VIDEO, TIP, DATA_UPLOAD, DURATA, ID_CHANNEL)
VALUES (22, 'ART', to_date('31-03-2018', 'dd-mm-yyyy'), 5.31, 0201);

INSERT INTO Videos (ID_VIDEO, TIP, DATA_UPLOAD, DURATA, ID_CHANNEL)
VALUES (23, 'ART', to_date('15-06-2019', 'dd-mm-yyyy'), 8.58, 0201);

INSERT INTO Videos (ID_VIDEO, TIP, DATA_UPLOAD, DURATA, ID_CHANNEL)
VALUES (24, 'ENTERTAINMENT', to_date('26-11-2021', 'dd-mm-yyyy'), 19.07, 0205);
--------------------------------------------------------------------------------------------------------------------------------
INSERT INTO Comentarii (ID_COMENT, DATA_POSTARE, DESCRIERE, ID_VIDEO, ID_UTILIZATOR)
VALUES(1101, to_date('26-11-2021', 'dd-mm-yyyy'), 'Best cars ever.', 20, 1);

INSERT INTO Comentarii (ID_COMENT, DATA_POSTARE, DESCRIERE, ID_VIDEO, ID_UTILIZATOR)
VALUES(1102, to_date('16-12-2020', 'dd-mm-yyyy'), ':)', 20, 1);

INSERT INTO Comentarii (ID_COMENT, DATA_POSTARE, DESCRIERE, ID_VIDEO, ID_UTILIZATOR)
VALUES(1103, to_date('30-12-2019', 'dd-mm-yyyy'), NULL, 20, 3);

INSERT INTO Comentarii (ID_COMENT, DATA_POSTARE, DESCRIERE, ID_VIDEO, ID_UTILIZATOR)
VALUES(1104, to_date('26-01-2021', 'dd-mm-yyyy'), NULL, 20, 5);

INSERT INTO Comentarii (ID_COMENT, DATA_POSTARE, DESCRIERE, ID_VIDEO, ID_UTILIZATOR)
VALUES(1105, to_date('15-06-2019', 'dd-mm-yyyy'), NULL, 23, 5);

INSERT INTO Comentarii (ID_COMENT, DATA_POSTARE, DESCRIERE, ID_VIDEO, ID_UTILIZATOR)
VALUES(1106, to_date('27-11-2021', 'dd-mm-yyyy'), 'This video is so funny.', 24, 7);
--------------------------------------------------------------------------------------------------------------------------------
INSERT INTO Promovari (ID_PROMOVARE, DESCRIERE, ID_VIDEO, ID_RECLAMA)
VALUES (1010, NULL, 20, 500);

INSERT INTO Promovari (ID_PROMOVARE, DESCRIERE, ID_VIDEO, ID_RECLAMA)
VALUES (1011, 'Promovare noua.', 21, 500);

INSERT INTO Promovari (ID_PROMOVARE, DESCRIERE, ID_VIDEO, ID_RECLAMA)
VALUES (1012, NULL, 20, 503);

INSERT INTO Promovari (ID_PROMOVARE, DESCRIERE, ID_VIDEO, ID_RECLAMA)
VALUES (1013, 'Promovare veche.', 22, 502);

INSERT INTO Promovari (ID_PROMOVARE, DESCRIERE, ID_VIDEO, ID_RECLAMA)
VALUES (1014, 'Promovare recomandata. ', 23, 504);

