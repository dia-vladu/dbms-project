-- UPDATE QUERIES
--------------------------------------------------------------------------------------------------------------------------------
-- 1. The value of contracts for which more than 2 years have passed since the date of signing should be changed to 0.
UPDATE contracte_de_sponsorizare
SET valoare = 
DECODE((SYSDATE - data_semnare)/365, GREATEST((SYSDATE - data_semnare)/365, 2), 0, valoare);
--------------------------------------------------------------------------------------------------------------------------------
-- 2. Double the value, add two months to the signing date and change the description for the sponsorship contracts
-- that have the highest value.
UPDATE contracte_de_sponsorizare
SET valoare = valoare / 2, descriere = 'Contract prelungit', data_semnare = ADD_MONTHS(data_semnare,2)
WHERE valoare>= ALL(SELECT valoare FROM contracte_de_sponsorizare);
--------------------------------------------------------------------------------------------------------------------------------
-- 3. Change the gender of the users so that the initial appears as a capital letter.
UPDATE utilizatori
SET gen = SUBSTR(INITCAP(gen), 0, 1);
--------------------------------------------------------------------------------------------------------------------------------
-- 4. Add a new record to the BUSINESSURI table.
INSERT INTO Businessuri (ID_BUSINESS, NUME, EMAIL, CEO, DATA_INFIINTARE)
VALUES(1005, 'eMAG', 'eMag@gmail.com', 'Tudor Manea', to_date('10-10-2001', 'dd-mm-yyyy'));
--------------------------------------------------------------------------------------------------------------------------------
-- 5. Round up the duration of videos that exceed 8 minutes and 50 seconds and for which the first appearance of the letter 'a' 
-- in the video type is in an odd position.
UPDATE videos
SET durata=ROUND(durata)
WHERE durata>8.50 AND MOD(INSTR(LOWER(tip),'a'),2) = 1;
--------------------------------------------------------------------------------------------------------------------------------
-- 6. Delete the records with the contracts signed by the businesses established in 2010.
DELETE FROM contracte_de_sponsorizare
WHERE id_business in (SELECT id_business FROM businessuri WHERE EXTRACT(YEAR FROM data_infiintare) = 2010);
--------------------------------------------------------------------------------------------------------------------------------
-- 7. Change the name of users whose last name starts with 'V' or whose first name ends with 'i', so that it is written
-- in capital letters.
UPDATE utilizatori
SET nume = UPPER(nume)
WHERE nume LIKE 'V%' OR prenume LIKE '%i';
--------------------------------------------------------------------------------------------------------------------------------
-- QUERIES WITH JOIN & GROUP
--------------------------------------------------------------------------------------------------------------------------------
-- 1. Display the id, name, first name and the number of comments made that have a description, for all registered users.
SELECT u.id_utilizator, u.nume, u.prenume, COUNT(c.descriere) nr_comentarii
FROM utilizatori u, comentarii c
WHERE u.id_utilizator = c.id_utilizator (+)
GROUP BY u.id_utilizator, u.nume, u.prenume
ORDER BY id_utilizator ASC;
--------------------------------------------------------------------------------------------------------------------------------
-- 2. Display the total amount received by each content creator and the number of businesses with which he/she collaborated.
SELECT u.nume_creator, SUM(c.valoare) valoare_totala, COUNT(DISTINCT(c.id_business)) nr_businessuri
FROM utilizatori u, contracte_de_sponsorizare c
WHERE u.id_utilizator = c.id_utilizator
GROUP BY u.nume_creator;
--------------------------------------------------------------------------------------------------------------------------------
-- 3. Make multiple groupings according to the id of the users and of the businesses from the CONTRACTE_DE_SPONSORIZARE table.
SELECT id_utilizator, id_business, SUM(valoare)
FROM contracte_de_sponsorizare
GROUP BY GROUPING SETS((id_utilizator, id_business), (id_business), (id_utilizator));
--------------------------------------------------------------------------------------------------------------------------------
-- 4. Display the id, the name of the content creators who signed sponsorship contracts in 2018 and the number of contracts
-- signed that year, by each.
SELECT u.id_utilizator, u.nume_creator, COUNT(c.numar_contract) nr_contracte
FROM utilizatori u , contracte_de_sponsorizare c
WHERE c.id_utilizator = u.id_utilizator AND TO_CHAR(c.data_semnare,'yyyy') = 2018
GROUP BY u.id_utilizator, u.nume_creator;
--------------------------------------------------------------------------------------------------------------------------------
-- 5. Display the emails of the content creators with whom each business has collaborated.
SELECT b.id_business, b.nume, u.email
FROM utilizatori u, businessuri b, contracte_de_sponsorizare c
WHERE u.id_utilizator = c.id_utilizator AND c.id_business = b.id_business
GROUP BY b.id_business, b.nume, u.email
ORDER BY id_business ASC;
--------------------------------------------------------------------------------------------------------------------------------
-- 6. Display the users who have a channel.
SELECT ROWNUM, id_utilizator, nume, prenume
FROM utilizatori u
WHERE EXISTS
(SELECT * FROM channels c
WHERE u.id_utilizator=c.id_utilizator);
--------------------------------------------------------------------------------------------------------------------------------
-- 7. Display the subtotal of the duration for each channel, and also the total.
SELECT  NVL(id_channel, 0) channel, NVL(id_video, 0) video, SUM(durata) durata
FROM videos
GROUP BY ROLLUP (id_channel, id_video)
ORDER BY id_channel ASC;
--------------------------------------------------------------------------------------------------------------------------------
-- SUBQUERIES
--------------------------------------------------------------------------------------------------------------------------------
-- 1. Display the id, name and surname of users whose email is not found on any sponsorship contract.
SELECT id_utilizator, nume, prenume
FROM utilizatori
WHERE email IN (SELECT email FROM utilizatori WHERE id_utilizator NOT IN (SELECT id_utilizator FROM contracte_de_sponsorizare));
--------------------------------------------------------------------------------------------------------------------------------
-- 2. Display the id, name and surname of the users who left comments on the videos posted by the channels opened by the user
-- with the id = 1.
SELECT id_utilizator, nume, prenume
FROM utilizatori
WHERE id_utilizator IN (SELECT id_utilizator FROM comentarii WHERE id_video IN 
(SELECT id_video FROM videos WHERE id_channel IN 
(SELECT id_channel FROM channels WHERE id_utilizator = 1)));
--------------------------------------------------------------------------------------------------------------------------------
-- 3. Display the id of promos that are assigned to ads whose name starts with 'B' and that do not appear in the videos 
-- posted by the content creator PewDiePie.
SELECT id_promovare
FROM promovari
WHERE id_reclama IN (SELECT id_reclama FROM reclame WHERE nume LIKE 'B%')
AND id_video NOT IN(SELECT id_video FROM videos WHERE id_channel IN
 (SELECT id_channel FROM channels WHERE id_utilizator =
 (SELECT id_utilizator FROM utilizatori WHERE nume_creator = 'PewDiePie')));
--------------------------------------------------------------------------------------------------------------------------------
-- 4. Display the id and subscription date for subscriptions made by content creators who have more than 1 channel open.
SELECT id_abonament, data_abonare
FROM abonamente
WHERE id_utilizator IN
(SELECT id_utilizator
FROM channels
GROUP BY id_utilizator
HAVING COUNT(id_channel) > 1);
--------------------------------------------------------------------------------------------------------------------------------
-- 5. Display the number and date of signing for the sponsorship contracts that have a value higher than the average and 
-- that were signed by content creators.
SELECT numar_contract, data_semnare
FROM contracte_de_sponsorizare
WHERE valoare > (SELECT AVG(valoare) FROM contracte_de_sponsorizare) AND
id_utilizator IN (SELECT id_utilizator FROM utilizatori WHERE nume_creator IS NOT NULL);
--------------------------------------------------------------------------------------------------------------------------------
-- CREATE VIEWS QUERIES
--------------------------------------------------------------------------------------------------------------------------------
-- 1. Create a view containing data about the sponsorship contracts signed in 2020.
CREATE OR REPLACE VIEW contracte_2020 AS
SELECT numar_contract, data_semnare, valoare
FROM contracte_de_sponsorizare
WHERE EXTRACT(year FROM data_semnare)= 2020;
SELECT * FROM contracte_2020;
--------------------------------------------------------------------------------------------------------------------------------
-- 2. Create a view that contains data about young users of the platform (a young user is a user under 25 years old).
CREATE OR REPLACE VIEW utilizatori_tineri AS
SELECT *
FROM utilizatori
WHERE (SYSDATE - data_nastere)/365<25
WITH CHECK OPTION;
SELECT * FROM utilizatori_tineri;
--------------------------------------------------------------------------------------------------------------------------------
-- 3. Create a view with users who have left more than one comment.
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
-- 4. Create a view to display the amount of tax to be paid for each contract. Tax will be calculated as follows:
--      - if the value of the contract is between 10,000 and 20,000, 7% is taxed
--      - if the value of the contract exceeds 20,000, 9% is taxed
--      - otherwise, 5% is taxed.
CREATE OR REPLACE VIEW impozite AS
SELECT numar_contract, data_semnare, valoare,
(CASE
WHEN (valoare BETWEEN 10000 AND 20000) THEN  valoare*0.07
    WHEN (valoare>20000) THEN valoare*0.09
    ELSE valoare*0.05
END) impozit
FROM contracte_de_sponsorizare;
SELECT * FROM impozite;
