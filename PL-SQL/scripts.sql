SET SERVEROUTPUT ON

-- PL?SQL BLOCKS WITH CURSORS

-- 1. Display the names of content creators who have signed contracts and classify them by age as: 
-- OLD (>= 30 years) or YOUNG (< 30 years).
VAR v_varsta VARCHAR2(6)
DECLARE
    CURSOR c IS SELECT DISTINCT(id_utilizator), nume, prenume, nume_creator, data_nastere
                FROM utilizatori JOIN contracte_de_sponsorizare USING (id_utilizator);
    v c%ROWTYPE;
BEGIN
    OPEN c;
    LOOP
        FETCH c INTO v;
        EXIT WHEN c%NOTFOUND;
        IF (ROUND(SYSDATE - v.data_nastere)/356)>=30 THEN
            :v_varsta := 'BATRAN';
        ELSE 
            :v_varsta := 'TANAR';
        END IF;
        DBMS_OUTPUT.PUT_LINE(v.nume||' '||v.prenume||' ('||v.nume_creator||')'||' e '
||:v_varsta);
    END LOOP;
    CLOSE c;
END;
/

-- 2. For each user display details about open channels (name, date of opening).
-- If the user is not a content creator, display an info message.
DECLARE
    CURSOR u IS SELECT id_utilizator, nume, prenume, nume_creator
                FROM utilizatori;
    CURSOR v (i utilizatori.id_utilizator%TYPE)IS 
                SELECT nume, data_deschidere, id_utilizator
                FROM channels
                WHERE id_utilizator = i;
BEGIN
    FOR util IN u LOOP
        IF util.nume_creator IS NULL THEN
            DBMS_OUTPUT.PUT_LINE('Utilizatorul: '||util.nume||' '||util.prenume||' nu e creator de continut => nu are canaluri deschise.');
        ELSE 
             DBMS_OUTPUT.PUT_LINE('Utilizatorul: '||util.nume||' '||util.prenume||' ('||util.nume_creator||'}');
             FOR c IN v(util.id_utilizator) LOOP
                DBMS_OUTPUT.PUT_LINE('    '||'Canalul:  '||c.nume||' a fost deschis in data de '|| c.data_deschidere);
            END LOOP;
        END IF;
    END LOOP;
END;
/

-- 3. Display the total value of contracts signed by each content creator. Depending on the number of contracts signed, 
-- each will receive a bonus as follows:
--      - a single signed contract: +10% of its value;
--      - 2 signed contracts: +20% of the total value;
--      - more than 2 signed contracts: +30% of the total value;
-- Display the new total value of signed contracts for each content creator.
DECLARE
    CURSOR u IS SELECT id_utilizator, nume_creator, SUM(valoare) valoare_totala
                FROM utilizatori JOIN contracte_de_sponsorizare USING (id_utilizator)
                GROUP BY id_utilizator, nume_creator;
    v_nr NUMBER;
    v_valoare NUMBER;
BEGIN
    FOR v_u IN u LOOP
        DBMS_OUTPUT.PUT_LINE(v_u.nume_creator||' a semnat contracte in valoare de '||v_u.valoare_totala);
        SELECT COUNT(numar_contract) INTO v_nr
        FROM contracte_de_sponsorizare
        WHERE id_utilizator = v_u.id_utilizator;
        DBMS_OUTPUT.PUT_LINE(' **Numar contracte incheiate: '||v_nr);
        UPDATE contracte_de_sponsorizare
        SET valoare =
            CASE
                WHEN v_nr = 1  THEN
                    valoare + valoare * 0.1
                WHEN v_nr = 2  THEN
                    valoare + valoare * 0.2
                ELSE
                    valoare + valoare * 0.3
            END
        WHERE id_utilizator = v_u.id_utilizator;
        
        SELECT SUM(valoare) INTO v_valoare 
        FROM contracte_de_sponsorizare 
        WHERE id_utilizator=v_u.id_utilizator
        GROUP BY id_utilizator;
        DBMS_OUTPUT.PUT_LINE(' ******Noua valoare totala a contractelor semnate de '||v_u.nume_creator||' este: '||v_valoare);
    END LOOP;
END;
/
ROLLBACK;

-- 4. Truncate the duration for the videos posted on the channel with the given id from the keyboard.
DECLARE
    v_id channels.id_channel%TYPE := &id;
    CURSOR c(p_id videos.id_channel%TYPE) IS SELECT id_video, durata FROM videos 
                                             WHERE id_channel = p_id;
BEGIN
    UPDATE videos
    SET durata = trunc(durata)
    WHERE id_channel = v_id;
    IF SQL%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Canalul cu id-ul '||v_id||': s-au modificat '||SQL%ROWCOUNT||' videoclipuri.');
        FOR v IN c(v_id) LOOP
            DBMS_OUTPUT.PUT_LINE('Videoclipul cu id-ul '||v.id_video||' dureaza '||v.durata||' minute;');
        END LOOP;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Canalul cu id-ul '||v_id||': nu exista!');
    END IF;
END;
/
ROLLBACK;


-- 5. Modify (add) the description of the first 2 comments that do not have a description.
DECLARE
    CURSOR c IS SELECT *
                FROM comentarii 
                WHERE descriere IS NULL
                FETCH FIRST 2 ROWS ONLY;
    v_desc c%ROWTYPE;
BEGIN
    OPEN c;
    FOR v_desc IN c LOOP
        UPDATE comentarii
        SET descriere = 'Ceva'
        WHERE id_coment = v_desc.id_coment;
    END LOOP;
    CLOSE c;
END;
/
ROLLBACK;

-- PL/SQL BLOCKS WITH EXEPTIONS

-- 1. Delete the business with the id given from the keyboard.
DECLARE
    are_contracte EXCEPTION;
    PRAGMA EXCEPTION_INIT(are_contracte,-2292);
    v_id NUMBER := &id;
    v_id_business businessuri.id_business%TYPE;
BEGIN
    SELECT id_business INTO v_id_business FROM businessuri WHERE id_business = v_id;
    IF SQL%FOUND THEN
        DELETE FROM businessuri
        WHERE id_business = v_id;
        DBMS_OUTPUT.PUT_LINE('S-a efectuat stergerea businessului cu id-ul '||v_id);
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('Nu exista businessul cu id-ul '||v_id);
    WHEN are_contracte THEN
        DBMS_OUTPUT.PUT_LINE('Sterge mai intai contractele de sponsorizare incheiate de businessul '||v_id);
END;
/
ROLLBACK;

-- 2. Display the full name for the first 3 users taken in alphabetical order by first name.
DECLARE
    CURSOR c IS SELECT *
                FROM utilizatori
                ORDER BY prenume ASC;
BEGIN
    OPEN c;
    FOR r IN c LOOP
        EXIT WHEN c%ROWCOUNT>3;
        DBMS_OUTPUT.PUT_LINE (r.nume||' '||r.prenume);
    END LOOP;
EXCEPTION
    WHEN CURSOR_ALREADY_OPEN THEN
    DBMS_OUTPUT.PUT_LINE ('Cursorul este deja deschis');
END;
/

-- 3. Insert a new content creator in the Users table. Handle the exception that occurred due to omitting 
-- data entry for a required field.
DECLARE
    valoare_nula EXCEPTION;
    PRAGMA EXCEPTION_INIT(valoare_nula, -01400);
BEGIN
    INSERT INTO utilizatori(id_utilizator, nume, prenume, email, data_nastere, gen, nume_creator)
    VALUES(8, 'Rief', 'Pamela', NULL, '1996-07-09', 'feminin', 'Pamela Rf.');
EXCEPTION
    WHEN valoare_nula THEN DBMS_OUTPUT.PUT_LINE('Date introduse incorect!');
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

-- 4. Display data about a user whose id is given from the keyboard and throw an exception if 
-- the user is not a content creator.
DECLARE
    v_id utilizatori.id_utilizator%TYPE := &id;
    v_nume utilizatori.nume%TYPE;
    v_prenume utilizatori.prenume%TYPE;
    CURSOR c(p_id utilizatori.id_utilizator%TYPE) IS 
	SELECT COUNT(id_channel) nr_channels
            FROM channels
            WHERE id_utilizator = p_id;
    v c%ROWTYPE;
    v_nr NUMBER;
BEGIN
    SELECT nume, prenume
    INTO v_nume, v_prenume
    FROM utilizatori
    WHERE id_utilizator = v_id;
    DBMS_OUTPUT.PUT_LINE('Utilizatorul cu id-ul '||v_id||' este '||v_nume||' '||v_prenume);
    OPEN c(v_id);
        LOOP
            FETCH c INTO v;
            EXIT WHEN c%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('Numar canale deschise: '||v.nr_channels);
        END LOOP;
    v_nr := c%ROWCOUNT;
    IF v_nr != NULL THEN
        DBMS_OUTPUT.PUT_LINE('Utilizatorul cu id-ul '||v_id||' e creator de continut.');
    ELSE
        RAISE_APPLICATION_ERROR(-20000, 'Utilizatorul cu id-ul '||v_id||' nu e creator de continut.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Utilizatorul cu id-ul '||v_id||' nu exista.');
END;
/

-- PL/SQL BLOCKS - FUNCTIONS & PROCEDURES

-- 1. Build a function that checks the existence of a user by id.
CREATE OR REPLACE FUNCTION Exista_utilizator (v_id IN utilizatori.id_utilizator%TYPE)
RETURN BOOLEAN
AS
    id_util utilizatori.id_utilizator%TYPE;
BEGIN
    SELECT id_utilizator INTO id_util FROM utilizatori WHERE id_utilizator = v_id;
    RETURN TRUE;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    RETURN FALSE;
END Exista_utilizator;
/

-- Function call:

DECLARE
    id_u utilizatori.id_utilizator%TYPE := &id;
    exist BOOLEAN := Exista_utilizator(id_u);
BEGIN
    DBMS_OUTPUT.PUT_LINE(
        CASE
            WHEN exist THEN 'Utilizatorul cu id-ul '||id_u||' exista.'
            ELSE 'Utilizatorul cu id-ul '||id_u||' nu exista.'
        END);
END;
/

-- 2. Construct a procedure that inserts a new user with the data entered as input parameters. 
-- Check if the id already exists.
CREATE OR REPLACE PROCEDURE Adauga_utilizator (
util_id utilizatori.id_utilizator%TYPE, util_nume utilizatori.nume%TYPE, 
util_prenume utilizatori.prenume%TYPE, util_email utilizatori.email%TYPE, util_data_nastere utilizatori.data_nastere%TYPE, util_gen utilizatori.gen%TYPE, util_nume_creator utilizatori.nume_creator%TYPE)
AS
    u_id utilizatori.id_utilizator%TYPE;
BEGIN
    IF NOT Exista_utilizator(util_id) THEN
        INSERT INTO utilizatori 
        VALUES(util_id, util_nume, util_prenume, util_email, util_data_nastere, util_gen, util_nume_creator);
        IF SQL%ROWCOUNT != 0 THEN
            DBMS_OUTPUT.PUT_LINE('Utilizatorul a fost adaugat.');
        END IF;
    ELSE 
        RAISE_APPLICATION_ERROR(-20001, 'Utilizatorul cu id-ul '||util_id||' exista deja.');
    END IF;
END Adauga_utilizator;
/

-- Procedure call:

EXECUTE Adauga_utilizator(1, 'Rief', 'Pamela', 'pamela@gmail.com', '09-AUG-1997', 'feminin', 'Pamela Rf.');
EXECUTE Adauga_utilizator(8, 'Rief', 'Pamela', 'pamela@gmail.com', '09-AUG-1997', 'feminin', 'Pamela Rf.');
SELECT * FROM utilizatori;
ROLLBACK;

-- 3. Build the a procedure that takes a user's id as an input parameter and returns the total duration of all videos posted by 
-- that user via an output parameter. Deal with possible errors.
CREATE OR REPLACE PROCEDURE Durata_videos (p_id IN utilizatori.id_utilizator%TYPE, p_durata OUT NUMBER)
AS
    v_id utilizatori.id_utilizator%TYPE;
    CURSOR c(i utilizatori.id_utilizator%TYPE) IS SELECT durata FROM videos 
                                                  JOIN channels USING(id_channel)
                                                  JOIN utilizatori USING (id_utilizator)
                                                  WHERE id_utilizator = i;
    v_nr NUMBER := 0; 
    nu_e_creator EXCEPTION;
BEGIN
    SELECT id_utilizator INTO v_id FROM utilizatori WHERE id_utilizator = p_id;
    p_durata := 0;
    FOR v IN c(p_id) LOOP
        v_nr := v_nr + 1;
        p_durata := p_durata + v.durata;
    END LOOP;
    IF v_nr = 0 THEN
        RAISE nu_e_creator;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Videoclipurile utilizatorului cu id-ul '||v_id||' au o durata totala de '||p_durata||' minute.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Utilizatorul cu id-ul '||p_id||' nu exista.');
    WHEN nu_e_creator THEN
        DBMS_OUTPUT.PUT_LINE('Utilizatorul cu id-ul '||p_id||' nu este creator de continut => nu are videoclipuri.');
END Durata_videos;
/

-- Procedure call:

DECLARE
    v_durata NUMBER;
    v_id utilizatori.id_utilizator%TYPE := &v_id;
BEGIN
    Durata_videos(v_id, v_durata);
END;
/

-- 4. Build a procedure to display the total value of signed contracts for a user whose id is entered from the keyboard. 
-- Handle the case where the user does not exist using a previous function and the case where the user is not a content creator.
CREATE OR REPLACE PROCEDURE Valoare_totala (u_id IN utilizatori.id_utilizator%TYPE)
AS
    v_nr NUMBER;
    val_totala NUMBER;
    nu_e_creator EXCEPTION;
BEGIN
    IF Exista_utilizator(u_id) THEN
        SELECT COUNT(id_channel)
        INTO v_nr
        FROM channels
        WHERE id_utilizator = u_id;
        IF v_nr != 0 THEN
            SELECT SUM(valoare)
            INTO val_totala
            FROM utilizatori JOIN contracte_de_sponsorizare USING (id_utilizator)
            WHERE id_utilizator = u_id
            GROUP BY id_utilizator; 
            DBMS_OUTPUT.PUT_LINE('Utilizatorul cu id-ul '||u_id||' a semnat contracte in valoare de '||val_totala);
        ELSE
            RAISE nu_e_creator;
        END IF;
    ELSE 
        RAISE_APPLICATION_ERROR(-20001, 'Utilizatorul cu id-ul '||u_id||' nu exista');
    END IF;
EXCEPTION
    WHEN nu_e_creator THEN
        DBMS_OUTPUT.PUT_LINE('Utilizatorul cu id-ul '||u_id||' nu e creator de continut.');
END Valoare_totala;
/

-- Procedure call:

EXECUTE Valoare_totala(&id);

-- 5. Build a function that displays how many months ago the video whose id is read from the keyboard was uploaded. 
-- Handle the case where the video with the entered id does not exist.
CREATE OR REPLACE FUNCTION Numar_luni (v_id IN videos.id_video%TYPE)
RETURN NUMBER
AS
   data_up DATE;
BEGIN
    SELECT data_upload
    INTO data_up
    FROM videos
    WHERE id_video = v_id;
    IF SQL%FOUND THEN
        RETURN CEIL(MONTHS_BETWEEN(SYSDATE, data_up));
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    RETURN NULL;
END Numar_luni;
/

-- Function call:

DECLARE
    v_id videos.id_video%TYPE := &id;
    nr_luni NUMBER := Numar_luni(v_id);
BEGIN
    IF nr_luni IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('Video-ul cu id-ul '||v_id||' a fost incarcat acum '||nr_luni||' luni.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Video-ul cu id-ul '||v_id||' nu exista.');
    END IF;
END;
/

-- 6. Build a function that regulates the value of a sponsorship contract signed after 2020, by applying a 15% tax. 
-- An input/output parameter will be used.
CREATE OR REPLACE FUNCTION Valoare_noua (p_nr IN contracte_de_sponsorizare.numar_contract%TYPE, p_val IN OUT contracte_de_sponsorizare.valoare%TYPE)
RETURN BOOLEAN
AS
    v_an NUMBER;
BEGIN
    SELECT EXTRACT(YEAR FROM data_semnare) INTO v_an FROM contracte_de_sponsorizare WHERE numar_contract = p_nr;
    IF v_an >= 2020 THEN
        p_val := p_val - 0.15*p_val;
        UPDATE contracte_de_sponsorizare
        SET valoare = p_val
        WHERE numar_contract = p_nr;
        RETURN TRUE;
    ELSE 
        RETURN FALSE;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN RETURN NULL;
END Valoare_noua;
/

-- Function call:

DECLARE
   CURSOR c IS SELECT numar_contract, valoare FROM contracte_de_sponsorizare;
   v_val_vechie contracte_de_sponsorizare.valoare%TYPE;
BEGIN
    FOR v IN c LOOP
        v_val_vechie := v.valoare;
        IF valoare_noua(v.numar_contract, v.valoare) = FALSE THEN 
            DBMS_OUTPUT.PUT_LINE('Contractul: '||v.numar_contract);
            DBMS_OUTPUT.PUT_LINE('**Valoare veche: '||v_val_vechie);
            DBMS_OUTPUT.PUT_LINE('****Valoare noua: contractul a fost semnat inainte de 2020.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Contractul '||v.numar_contract);
            DBMS_OUTPUT.PUT_LINE('**Valoare veche: '||v_val_vechie);
            DBMS_OUTPUT.PUT_LINE('****Valoare noua: '||v.valoare);
        END IF;
    END LOOP;
END;
/
ROLLBACK;

-- 7. Create a procedure that displays data about users who have content creator names.
CREATE OR REPLACE PROCEDURE Date_creatori
AS
    TYPE util_tab IS TABLE OF utilizatori%ROWTYPE INDEX BY
    PLS_INTEGER;
    v_util util_tab;
BEGIN
    SELECT * BULK COLLECT INTO v_util FROM utilizatori WHERE
    id_utilizator IN (SELECT id_utilizator FROM utilizatori WHERE nume_creator IS NOT NULL);
    FOR i IN v_util.FIRST..v_util.LAST LOOP
    DBMS_OUTPUT.PUT_LINE(v_util(i).nume||' '||v_util(i).prenume||' este '||v_util(i).nume_creator);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Total creatori de continut: '||v_util.count);
END;
/

-- Procedure call:

EXECUTE Date_creatori;

-- PL/SQL PACKAGES

-- 1. Build a package containing the functions and procedures necessary to adjust the values of sponsorship contracts 
-- signed by a user so that those signed after 2020 have a 15% tax applied. Be able to calculate the new total value of 
-- contracts signed by this user and handle possible exceptions.
CREATE OR REPLACE PACKAGE Pachet_reglementare AS
    FUNCTION Exista_utilizator(v_id IN utilizatori.id_utilizator%TYPE)RETURN BOOLEAN;
    FUNCTION Val_cu_taxa(p_nr IN contracte_de_sponsorizare.numar_contract%TYPE, p_val IN OUT contracte_de_sponsorizare.valoare%TYPE)RETURN BOOLEAN;
    PROCEDURE Total_val(u_id IN utilizatori.id_utilizator%TYPE);
END;
/

CREATE OR REPLACE PACKAGE BODY Pachet_reglementare AS
    FUNCTION Exista_utilizator(v_id IN utilizatori.id_utilizator%TYPE)
    RETURN BOOLEAN
    AS
        id_util utilizatori.id_utilizator%TYPE;
    BEGIN
        SELECT id_utilizator INTO id_util FROM utilizatori WHERE id_utilizator = v_id;
        RETURN TRUE;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        RETURN FALSE;
    END Exista_utilizator;
    
    FUNCTION Val_cu_taxa(p_nr IN contracte_de_sponsorizare.numar_contract%TYPE, p_val IN OUT contracte_de_sponsorizare.valoare%TYPE)
    RETURN BOOLEAN
    AS
        v_an NUMBER;
    BEGIN
    SELECT EXTRACT(YEAR FROM data_semnare) INTO v_an FROM contracte_de_sponsorizare WHERE numar_contract = p_nr;
        IF v_an >= 2020 THEN
            p_val := p_val-0.15*p_val;
            RETURN TRUE;
        ELSE 
            RETURN FALSE;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN RETURN NULL;
    END Val_cu_taxa;
    
    PROCEDURE Total_val(u_id IN utilizatori.id_utilizator%TYPE)
    AS
        CURSOR c(p_id utilizatori.id_utilizator%TYPE) IS SELECT numar_contract, valoare FROM contracte_de_sponsorizare
                                                         WHERE id_utilizator = p_id;
        v_nr NUMBER := 0;
        v_total contracte_de_sponsorizare.valoare%TYPE;
    BEGIN
        IF Exista_utilizator(u_id) THEN
            FOR v IN c(u_id) LOOP
                v_nr := v_nr + 1;
                IF Val_cu_taxa(v.numar_contract, v.valoare)THEN
                    UPDATE contracte_de_sponsorizare
                    SET valoare = v.valoare
                    WHERE numar_contract = v.numar_contract;
                END IF;
            END LOOP;
            IF v_nr = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Utilizatorul cu id-ul '||u_id||' nu a semnat contracte de sponsorizare.');
            ELSE
                SELECT SUM(valoare) INTO v_total FROM contracte_de_sponsorizare WHERE id_utilizator = u_id;
                DBMS_OUTPUT.PUT_LINE('Valoarea totala a contractelor semnate de utilizatorul cu id-ul '||u_id||' in urma reglementarii este: '||v_total);
            END IF;
        ELSE
            RAISE_APPLICATION_ERROR(-20000, 'Utilizatorul cu id-ul '||u_id||' nu exista.');
        END IF;
    END Total_val;

END Pachet_reglementare;
/

-- Procedure call from package:

DECLARE
    CURSOR c IS SELECT id_utilizator FROM utilizatori;
BEGIN
    FOR v IN c LOOP
    pachet_reglementare.Total_val(v.id_utilizator);
    END LOOP;
END;
/
ROLLBACK;

-- PL/SQL TRIGGERS

-- 1. Create a trigger that does not allow negative values in the sponsorship contracts table for a contract value.
CREATE OR REPLACE TRIGGER valoare_pozitiva
BEFORE INSERT OR UPDATE OF valoare
ON contracte_de_sponsorizare
FOR EACH ROW
BEGIN
    IF :NEW.valoare<0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Valoarea unui contract nu poate fi negativa!');
    END IF;
END;
/

UPDATE contracte_de_sponsorizare
SET valoare = -10000
WHERE numar_contract = 11;

-- 2. Create a trigger, Business_Update, by which:
--    - at the time of changing the name of a business, to increase the value of the contracts signed by that business.
--    - when deleting a business, automatically delete all records with that business from the sponsorship contracts table.
CREATE OR REPLACE TRIGGER actualizare_business
BEFORE UPDATE OF nume OR DELETE 
ON businessuri
FOR EACH ROW
WHEN (NEW.nume != OLD.nume)
DECLARE
    v_nr_aparitii NUMBER;
    v_id_bus businessuri.id_business%TYPE;
    v_tip VARCHAR2(1);
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    CASE
        WHEN UPDATING THEN v_tip := 'U';
        WHEN DELETING THEN v_tip := 'D';
    END CASE;
    SELECT id_business INTO v_id_bus FROM businessuri WHERE nume = :OLD.nume;
    IF v_tip = 'U' THEN
        SELECT NVL(COUNT(numar_contract),0) INTO v_nr_aparitii FROM contracte_de_sponsorizare WHERE id_business = v_id_bus;
        IF v_nr_aparitii = 0 THEN
            RAISE_APPLICATION_ERROR(-20000, 'Nu exista niciun contract semnat de businessul cu numele '||:OLD.nume);
        ELSE
            UPDATE contracte_de_sponsorizare
            SET valoare = valoare + valoare * 0.1
            WHERE id_business = v_id_bus;
            COMMIT;
        END IF;
    ELSE 
        DELETE FROM contracte_de_sponsorizare WHERE id_business = v_id_bus;
    END IF;
END;
/

UPDATE businessuri
SET nume = 'Shopify.2'
WHERE nume = 'Shopify';

SELECT * FROM contracte_de_sponsorizare;
SELECT * FROM businessuri;

DELETE FROM businessuri
WHERE nume = 'Shopify.2';