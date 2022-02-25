-- OPERATII DE ACTUALIZARE
--------------------------------------------------------------------------------------------------------------------------------
-- 1. S? se schimbe cu 0 valoarea contractelor pentru care de la data semn?rii au trecut mai mult de 2 ani.
UPDATE contracte_de_sponsorizare
SET valoare = 
DECODE((SYSDATE - data_semnare)/365, GREATEST((SYSDATE - data_semnare)/365, 2), 0, valoare);
--------------------------------------------------------------------------------------------------------------------------------
-- 2. S? se dubleze valoarea, s? se adauge la data semn?rii dou? luni ?i s? se schimbe descrierea pentru contractele de
-- sponsorizare care au valoarea cea mai mare.
UPDATE contracte_de_sponsorizare
SET valoare = valoare / 2, descriere = 'Contract prelungit', data_semnare = ADD_MONTHS(data_semnare,2)
WHERE valoare>= ALL(SELECT valoare FROM contracte_de_sponsorizare);
--------------------------------------------------------------------------------------------------------------------------------
-- 3. S? se modifice genul utilizatorilor astfel încât s? apar? ini?iala drept majuscul?.
UPDATE utilizatori
SET gen = SUBSTR(INITCAP(gen), 0, 1);
--------------------------------------------------------------------------------------------------------------------------------
-- 4. S? se adauge o nou? înregistrare în tabela BUSINESSURI.
INSERT INTO Businessuri (ID_BUSINESS, NUME, EMAIL, CEO, DATA_INFIINTARE)
VALUES(1005, 'eMAG', 'eMag@gmail.com', 'Tudor Manea', to_date('10-10-2001', 'dd-mm-yyyy'));
--------------------------------------------------------------------------------------------------------------------------------
-- 5. S? se rotunjeasc? durata videoclipurilor care dep??esc 8 minute ?i 50 de secunde ?i pentru care prima apari?ie a literei
-- a în tipul videoclipului este pe pozi?ie impar?. 
UPDATE videos
SET durata=ROUND(durata)
WHERE durata>8.50 AND MOD(INSTR(LOWER(tip),'a'),2) = 1;
--------------------------------------------------------------------------------------------------------------------------------
-- 6. S? se ?tearg? înregistr?rile cu contractele semnate de businessul înfiin?at în 2010.
DELETE FROM contracte_de_sponsorizare
WHERE id_business = (SELECT id_business FROM businessuri WHERE EXTRACT(YEAR FROM data_infiintare) = 2010);
--------------------------------------------------------------------------------------------------------------------------------
-- 7. S? se modifice numele utilizatorilor a c?ror nume începe cu V sau a c?ror prenume se termin? cu i, astfel încât s? fie
-- scris cu majuscule.
UPDATE utilizatori
SET nume = UPPER(nume)
WHERE nume LIKE 'V%' OR prenume LIKE '%i';
--------------------------------------------------------------------------------------------------------------------------------
-- OPERATII DE INTEROGARE (JONCTIUNI SI GRUPARI)
--------------------------------------------------------------------------------------------------------------------------------
-- 1. S? se afi?eze id-ul, numele, prenumele ?i num?rul comentariilor f?cute, care au descriere, pentru to?i utilizatorii
-- înregistra?i.
SELECT u.id_utilizator, u.nume, u.prenume, COUNT(c.descriere) nr_comentarii
FROM utilizatori u, comentarii c
WHERE u.id_utilizator = c.id_utilizator (+)
GROUP BY u.id_utilizator, u.nume, u.prenume
ORDER BY id_utilizator ASC;
--------------------------------------------------------------------------------------------------------------------------------
-- 2. S? se afi?eze suma primit? în total de fiecare creator de con?inut ?i num?rul business-urilor cu care a colaborat.
SELECT u.nume_creator, SUM(c.valoare) valoare_totala, COUNT(DISTINCT(c.id_business)) nr_businessuri
FROM utilizatori u, contracte_de_sponsorizare c
WHERE u.id_utilizator = c.id_utilizator
GROUP BY u.nume_creator;
--------------------------------------------------------------------------------------------------------------------------------
-- 3. S? se efectueze grup?ri multiple în func?ie de id-ul uitlizatorilor ?i al businessurilor pentru tabela
-- CONTRACTE_DE_SPONSORIZARE.
SELECT id_utilizator, id_business, SUM(valoare)
FROM contracte_de_sponsorizare
GROUP BY GROUPING SETS((id_utilizator, id_business), (id_business), (id_utilizator));
--------------------------------------------------------------------------------------------------------------------------------
-- 4. S? se afi?eze id-ul, numele creatorilor de con?inut care au semnat contracte de sponsorizare în 2018 ?i num?rul
--contractelor semnate în acest an, de fiecare.	
SELECT u.id_utilizator, u.nume_creator, COUNT(c.numar_contract) nr_contracte
FROM utilizatori u , contracte_de_sponsorizare c
WHERE c.id_utilizator = u.id_utilizator AND TO_CHAR(c.data_semnare,'yyyy') = 2018
GROUP BY u.id_utilizator, u.nume_creator;
--------------------------------------------------------------------------------------------------------------------------------
-- 5. S? se afi?eze emailurile creatorilor de continut cu care a colaborat fiecare business.
SELECT b.id_business, b.nume, u.email
FROM utilizatori u, businessuri b, contracte_de_sponsorizare c
WHERE u.id_utilizator = c.id_utilizator AND c.id_business = b.id_business
GROUP BY b.id_business, b.nume, u.email
ORDER BY id_business ASC;
--------------------------------------------------------------------------------------------------------------------------------
-- 6. S? se afi?eze utilizatorii care au canal.
SELECT ROWNUM, id_utilizator, nume, prenume
FROM utilizatori u
WHERE EXISTS
(SELECT * FROM channels c
WHERE u.id_utilizator=c.id_utilizator);
--------------------------------------------------------------------------------------------------------------------------------
-- 7. S? se afi?eze subtotalul duratei pentru fiecare channel, dar si pertotal.
SELECT  NVL(id_channel, 0) channel, NVL(id_video, 0) video, SUM(durata) durata
FROM videos
GROUP BY ROLLUP (id_channel, id_video)
ORDER BY id_channel ASC;
--------------------------------------------------------------------------------------------------------------------------------
-- OPERATII DE INTEROGARE (SUBCERERI)
--------------------------------------------------------------------------------------------------------------------------------
-- 1. S? se afi?eze id-ul, numele ?i prenumele utilizatorilor a c?ror email nu se reg?se?te pe niciun contract de sponsorizare.
SELECT id_utilizator, nume, prenume
FROM utilizatori
WHERE email IN (SELECT email FROM utilizatori WHERE id_utilizator NOT IN (SELECT id_utilizator FROM contracte_de_sponsorizare));
--------------------------------------------------------------------------------------------------------------------------------
-- 2. S? se afi?eze id-ul, numele ?i prenumele utilizatorilor care au l?sat comentarii videoclipurilor postate de canalele
-- deschise de c?tre utilizatorul cu id-ul = 1.
SELECT id_utilizator, nume, prenume
FROM utilizatori
WHERE id_utilizator IN (SELECT id_utilizator FROM comentarii WHERE id_video IN 
(SELECT id_video FROM videos WHERE id_channel IN 
(SELECT id_channel FROM channels WHERE id_utilizator = 1)));
--------------------------------------------------------------------------------------------------------------------------------
-- 3. S? se afi?eze id-ul promov?rilor care sunt atribuite reclamelor a c?ror nume începe cu B ?i care nu apar în videoclipurile
-- postate de canalul creatorului de con?inut PewDiePie.
SELECT id_promovare
FROM promovari
WHERE id_reclama IN (SELECT id_reclama FROM reclame WHERE nume LIKE 'B%')
AND id_video NOT IN(SELECT id_video FROM videos WHERE id_channel IN
 (SELECT id_channel FROM channels WHERE id_utilizator =
 (SELECT id_utilizator FROM utilizatori WHERE nume_creator = 'PewDiePie')));
--------------------------------------------------------------------------------------------------------------------------------
-- 4. S? se afi?eze id-ul ?i data abon?rii pentru abonamentele f?cute de creatorii de con?inut care au mai mult de 1 canal
-- deschis.
SELECT id_abonament, data_abonare
FROM abonamente
WHERE id_utilizator IN
(SELECT id_utilizator
FROM channels
GROUP BY id_utilizator
HAVING COUNT(id_channel) > 1);
--------------------------------------------------------------------------------------------------------------------------------
-- 5. S? se afi?eze num?rul ?i data semn?rii pentru contractele de sponsorizare care au valoarea mai mare decât cea medie ?i
-- care au fost semnate de creatorii de con?inut.
SELECT numar_contract, data_semnare
FROM contracte_de_sponsorizare
WHERE valoare > (SELECT AVG(valoare) FROM contracte_de_sponsorizare) AND
id_utilizator IN (SELECT id_utilizator FROM utilizatori WHERE nume_creator IS NOT NULL);
--------------------------------------------------------------------------------------------------------------------------------
-- OPERATII CREARE TABELE VIRTUALE
--------------------------------------------------------------------------------------------------------------------------------
-- 1. S? se creeze o tabel? virtual? care s? con?in? date despre contractele de sponsorizare semnate în anul 2020.
CREATE OR REPLACE VIEW contracte_2020 AS
SELECT numar_contract, data_semnare, valoare
FROM contracte_de_sponsorizare
WHERE EXTRACT(year FROM data_semnare)= 2020;
SELECT * FROM contracte_2020;
--------------------------------------------------------------------------------------------------------------------------------
-- 2. S? se creeze o tabel? virtual? care s? con?in? date despre utilizatorii tineri ai platformei (un utilizator tân?r este
-- un utilizator cu vârsta mai mic? de 25 de ani).
CREATE OR REPLACE VIEW utilizatori_tineri AS
SELECT *
FROM utilizatori
WHERE (SYSDATE - data_nastere)/365<25
WITH CHECK OPTION;
SELECT * FROM utilizatori_tineri;
--------------------------------------------------------------------------------------------------------------------------------
-- 3. S? se creeze o tabel? virtual? cu utilizatorii care au l?sat mai mult de un comentariu.
CREATE OR REPLACE VIEW utilizatori_comment AS
SELECT id_utilizator, nume, prenume, email, data_nastere
FROM utilizatori
WHERE id_utilizator IN(
SELECT u.id_utilizator
FROM utilizatori u, comentarii c
WHERE u.id_utilizator = c.id_utilizator
GROUP BY u.id_utilizator
HAVING COUNT(c.id_utilizator)> 1);
SELECT * FROM utilizatori_comment;
--------------------------------------------------------------------------------------------------------------------------------
-- 4. S? se creeze o tabel? virtual? prin care s? se afi?eze valoarea impozitului de pl?tit pentru fiecare contract, calculat? 
-- astfel:
--      - dac? valoarea contractului dep??e?te este între 10.000 ?i 20.000, se impoziteaz? 7%
--      - dac? valoarea contractului dep??e?te 20.000, se impoziteaz? 9%
--      - altfel, se impoziteaz? 5%.
CREATE OR REPLACE VIEW impozite AS
SELECT numar_contract, data_semnare, valoare,
(CASE
WHEN (valoare BETWEEN 10000 AND 20000) THEN  valoare*0.07
    WHEN (valoare>20000) THEN valoare*0.09
    ELSE valoare*0.05
END) impozit
FROM contracte_de_sponsorizare;
SELECT * FROM impozite;