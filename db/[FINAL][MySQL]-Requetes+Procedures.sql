USE SAE301;

-- ROLE : ENSEIGNANT-CHERCHEUR

-- Requête 1 : noms et statuts de toutes les expérimentations d'une équipe de recherche

SELECT NameTeam, NomExpe, Statut
FROM EXPERIMENTATION
INNER JOIN TEAM ON EXPERIMENTATION.IdExpe = TEAM.IdExpe
WHERE NameTeam = 'Team A';


-- Requête 2 : nom, prénom et mail de tous les participants d'une expérimentation ayant donné leur consentement
-- VUE nécessaire:

DROP VIEW IF EXISTS ParticipantsInscrits;

CREATE VIEW ParticipantsInscrits AS
SELECT NomUser, PrenomUser, BirthUser, GenderUser, MailUser, NomRole,
       ConscentInscription, NomStatutInscript,
       EXPERIMENTATION.IdExpe, NomExpe, DescExpe, DateDebExpe, DateFinExpe,
       Statut AS ExpeStatut
FROM USER_
INNER JOIN ROLE ON USER_.IdRole = ROLE.IdRole
INNER JOIN PARTICIPER ON PARTICIPER.IdUser = USER_.IdUser
INNER JOIN INSCRIPTION ON PARTICIPER.IdInscription = INSCRIPTION.IdInscription
INNER JOIN STATUTINSCRIPTION ON INSCRIPTION.IdStatutInscript = STATUTINSCRIPTION.IdStatutInscript
INNER JOIN EXPERIMENTATION ON EXPERIMENTATION.IdExpe = PARTICIPER.IdExpe;

-- Test de la vue :
-- SELECT * FROM ParticipantsInscrits;

SELECT NomUser, PrenomUser, MailUser
FROM ParticipantsInscrits
WHERE ConscentInscription = 1 AND NomExpe = 'Expérience 1';


-- Requête 3 : suivi des inscriptions
-- Pour chaque expérimentation : nombre de participants par statut d'inscription et nombre de consentements recueillis parmi eux

SELECT IdExpe, NomExpe, NomStatutInscript,
       COUNT(*) AS NbParticipants,
       SUM(CASE WHEN ConscentInscription = 1 THEN 1 ELSE 0 END) AS NbConsentements
FROM ParticipantsInscrits
GROUP BY IdExpe, NomExpe, NomStatutInscript
ORDER BY NomExpe, NomStatutInscript;


-- PROCEDURES STOCKEES

-- Procédure 1 : créer une expérimentation
DROP PROCEDURE IF EXISTS CreerExperimentation;

DELIMITER $$

CREATE PROCEDURE CreerExperimentation(
    IN p_NomExpe      VARCHAR(50),
    IN p_DateDebExpe  DATE,
    IN p_DateFinExpe  DATE,
    IN p_Statut       VARCHAR(50),
    IN p_IdLabo       INT,
    IN p_DescExpe     TEXT
)
BEGIN
    DECLARE v_IdExpe INT;

    -- Gestion des erreurs
    IF p_NomExpe IS NULL OR p_NomExpe = '' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Le nom de l''expérimentation est obligatoire.', MYSQL_ERRNO = 50001;
    END IF;

    IF p_DateDebExpe IS NULL OR p_DateFinExpe IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Les dates de début et de fin sont obligatoires.', MYSQL_ERRNO = 50002;
    END IF;

    IF p_DateFinExpe < p_DateDebExpe THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La date de fin ne peut pas être antérieure à la date de début.', MYSQL_ERRNO = 50003;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM LABORATOIRE WHERE IdLabo = p_IdLabo) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Le laboratoire n''existe pas.', MYSQL_ERRNO = 50004;
    END IF;

    IF EXISTS (SELECT 1 FROM EXPERIMENTATION WHERE NomExpe = p_NomExpe) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Une expérimentation possède déja ce nom', MYSQL_ERRNO = 50005;
    END IF;

    -- Création
    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            RESIGNAL;
        END;

        START TRANSACTION;

        SET v_IdExpe = (SELECT COALESCE(MAX(IdExpe), 0) + 1 FROM EXPERIMENTATION);

        INSERT INTO EXPERIMENTATION (IdExpe, NomExpe, DescExpe, DateDebExpe, DateFinExpe, Statut, IdLabo)
        VALUES (v_IdExpe, p_NomExpe, p_DescExpe, p_DateDebExpe, p_DateFinExpe, p_Statut, p_IdLabo);

        COMMIT;
    END;
END$$

DELIMITER ;


-- Procédure 2 : créer un créneau pour une expérimentation
DROP PROCEDURE IF EXISTS CreerCreneau;

DELIMITER $$

CREATE PROCEDURE CreerCreneau(
    IN p_IdExpe       INT,
    IN p_NomCreneau   VARCHAR(50),
    IN p_DateCreneau  DATE,
    IN p_DebCreneau   TIME,
    IN p_FinCreneau   TIME
)
BEGIN
    DECLARE v_DateDebExpe DATE;
    DECLARE v_DateFinExpe DATE;
    DECLARE v_IdCreneau INT;

    SELECT DateDebExpe, DateFinExpe INTO v_DateDebExpe, v_DateFinExpe
    FROM EXPERIMENTATION WHERE IdExpe = p_IdExpe;


    -- Contrôles
    IF v_DateDebExpe IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Expérimentation introuvable.', MYSQL_ERRNO = 50010;
    END IF;

    IF p_NomCreneau IS NULL OR p_NomCreneau = '' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Le nom du créneau est obligatoire.', MYSQL_ERRNO = 50011;
    END IF;

    IF p_FinCreneau <= p_DebCreneau THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'L''heure de fin doit être postérieure à l''heure de début.', MYSQL_ERRNO = 50012;
    END IF;

    IF p_DateCreneau < v_DateDebExpe OR p_DateCreneau > v_DateFinExpe THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La date du créneau doit être comprise dans la période de l''expérimentation.', MYSQL_ERRNO = 50013;
    END IF;

    -- Création
    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            RESIGNAL;
        END;

        START TRANSACTION;

        -- Pas de chevauchement avec un autre créneau de la même expérimentation le même jour
        IF EXISTS (SELECT 1 FROM CRENEAU
                    WHERE IdExpe = p_IdExpe
                    AND DateCreneau = p_DateCreneau
                    AND DebCreneau < p_FinCreneau
                    AND FinCreneau > p_DebCreneau) THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Ce créneau chevauche un créneau existant de cette expérimentation.', MYSQL_ERRNO = 50014;
        END IF;

        SET v_IdCreneau = (SELECT COALESCE(MAX(IdCreneau), 0) + 1 FROM CRENEAU);

        INSERT INTO CRENEAU (IdCreneau, NomCreneau, DateCreneau, DebCreneau, FinCreneau, IdExpe)
        VALUES (v_IdCreneau, p_NomCreneau, p_DateCreneau, p_DebCreneau, p_FinCreneau, p_IdExpe);

        COMMIT;
    END;
END$$

DELIMITER ;



-- Procédure 3 : changer le statut d'inscription d'un participant à une expérimentation
DROP PROCEDURE IF EXISTS ChangerStatutInscription;

DELIMITER $$

CREATE PROCEDURE ChangerStatutInscription(
    IN p_IdUser            INT,
    IN p_IdExpe            INT,
    IN p_IdStatutInscript  INT
)
BEGIN
    -- Contrôles
    IF NOT EXISTS (SELECT 1 FROM PARTICIPER
                   WHERE IdUser = p_IdUser AND IdExpe = p_IdExpe) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Ce participant n''est pas inscrit à cette expérimentation.', MYSQL_ERRNO = 50020;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM STATUTINSCRIPTION
                   WHERE IdStatutInscript = p_IdStatutInscript) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Statut d''inscription introuvable.', MYSQL_ERRNO = 50021;
    END IF;

    -- Mise à jour
    UPDATE INSCRIPTION SET IdStatutInscript = p_IdStatutInscript
    WHERE IdInscription IN (SELECT IdInscription FROM PARTICIPER WHERE IdUser = p_IdUser AND IdExpe = p_IdExpe);
END$$

DELIMITER ;



USE SAE301;

-- EXEMPLES D'UTILISATION
-- 1. CreerExperimentation
CALL CreerExperimentation(
    'Expérience 11',
    '2024-11-01',
    '2024-11-10',
    'En cours',
    5,
    'Etude de la perception des couleurs en environnement virtuel'
);

-- Vérification :
SELECT IdExpe, NomExpe, DateDebExpe, DateFinExpe, Statut, IdLabo
FROM EXPERIMENTATION
WHERE NomExpe = 'Expérience 11';


-- 2. CreerCreneau
CALL CreerCreneau(
    1,
    'Creneau 11',
    '2024-01-02',
    '14:00:00',
    '16:00:00'
);

-- Vérification :
SELECT IdCreneau, NomCreneau, DateCreneau, DebCreneau, FinCreneau
FROM CRENEAU
WHERE IdExpe = 1;

-- 3. ChangerStatutInscription
-- Avant :
SELECT NomUser, PrenomUser, NomExpe, ConscentInscription, NomStatutInscript
FROM ParticipantsInscrits
WHERE NomUser = 'Voisee' AND NomExpe = 'Expérience 5';

CALL ChangerStatutInscription(6, 5, 3);

-- Après :
SELECT NomUser, PrenomUser, NomExpe, ConscentInscription, NomStatutInscript
FROM ParticipantsInscrits
WHERE NomUser = 'Voisee' AND NomExpe = 'Expérience 5';

/* pour le participant */
/* requêtes classiques dabord */

/* permet de lister les expérimentations en cours avec le nom du laboratoire associé */
SELECT
    E.IdExpe,
    E.NomExpe,
    E.DescExpe,
    E.DateDebExpe,
    E.DateFinExpe,
    E.Statut,
    L.NomLabo
FROM EXPERIMENTATION AS E
INNER JOIN LABORATOIRE AS L
    ON L.IdLabo = E.IdLabo
WHERE E.Statut = 'En cours'
ORDER BY E.DateDebExpe;

/* permet de lister les documents associés à une expérimentation donnée */
SET @IdExpe = 1;
SELECT
    D.NomDoc,
    D.UrlDoc
FROM DOCUMENT AS D
WHERE D.IdExpe = @IdExpe
ORDER BY D.NomDoc;

/* permet de lister les créneaux associés à une expérimentation donnée */ 
SET @IdExpe = 1;
SELECT
    E.NomExpe,
    C.DateCreneau,
    C.NomCreneau,
    C.DebCreneau,
    C.FinCreneau
FROM CRENEAU AS C
INNER JOIN EXPERIMENTATION AS E
    ON E.IdExpe = C.IdExpe
WHERE C.IdExpe = @IdExpe
ORDER BY C.DateCreneau, C.DebCreneau;

/* les procédures stockées ensuite */

/* permet de lister les expérimentations auxquelles un participant est inscrit avec son statut d'inscription */
DROP PROCEDURE IF EXISTS SP_MesExperimentations;

DELIMITER $$

CREATE PROCEDURE SP_MesExperimentations(
    IN p_IdUser INT
)
BEGIN
    SELECT
        E.IdExpe,
        E.NomExpe,
        E.DateDebExpe,
        E.DateFinExpe,
        E.Statut AS StatutExpe,
        SI.NomStatutInscript AS StatutInscription,
        L.NomLabo
    FROM PARTICIPER AS P
    INNER JOIN EXPERIMENTATION AS E
        ON E.IdExpe = P.IdExpe
    INNER JOIN INSCRIPTION AS I
        ON I.IdInscription = P.IdInscription
    INNER JOIN STATUTINSCRIPTION AS SI
        ON SI.IdStatutInscript = I.IdStatutInscript
    INNER JOIN LABORATOIRE AS L
        ON L.IdLabo = E.IdLabo
    WHERE P.IdUser = p_IdUser
    ORDER BY E.DateDebExpe DESC;
END$$

DELIMITER ;

CALL SP_MesExperimentations(6);

/* permet de récupérer les créneaux de toutes les expérimentations auxquelles participe l'utilisateur.*/
DROP PROCEDURE IF EXISTS SP_MonPlanning;

DELIMITER $$

CREATE PROCEDURE SP_MonPlanning(
    IN p_IdUser INT
)
BEGIN
    SELECT
        E.NomExpe,
        C.NomCreneau,
        C.DateCreneau,
        C.DebCreneau,
        C.FinCreneau
    FROM PARTICIPER AS P
    INNER JOIN EXPERIMENTATION AS E
        ON E.IdExpe = P.IdExpe
    INNER JOIN CRENEAU AS C
        ON C.IdExpe = E.IdExpe
    WHERE P.IdUser = p_IdUser
    ORDER BY C.DateCreneau, C.DebCreneau;
END$$

DELIMITER ;

CALL SP_MonPlanning(6);

/* permet de récupérer les documents de toutes les expérimentations auxquelles participe l'utilisateur.*/
DROP PROCEDURE IF EXISTS SP_MesDocuments;

DELIMITER $$

CREATE PROCEDURE SP_MesDocuments(
    IN p_IdUser INT
)
BEGIN
    SELECT DISTINCT
        E.NomExpe,
        D.NomDoc,
        D.UrlDoc
    FROM PARTICIPER AS P
    INNER JOIN EXPERIMENTATION AS E
        ON E.IdExpe = P.IdExpe
    INNER JOIN DOCUMENT AS D
        ON D.IdExpe = E.IdExpe
    WHERE P.IdUser = p_IdUser
    ORDER BY E.NomExpe, D.NomDoc;
END$$

DELIMITER ;

CALL SP_MesDocuments(6);

/* pour l'administrateur */ 
/* requêtes classiques dabord */

/* permet de lister tous les utilisateurs avec leur rôle associé */
SELECT
    U.IdUser,
    U.NomUser,
    U.PrenomUser,
    U.MailUser,
    R.NomRole
FROM USER_ AS U
INNER JOIN ROLE AS R
    ON R.IdRole = U.IdRole
ORDER BY R.NomRole, U.NomUser;

/* permet de lister le nombre de ressources par type de ressource */
SELECT
    TR.IdTypeRess,
    TR.NomTypeRess,
    COUNT(R.IdRess) AS NombreRessources
FROM TYPERESSOURCE AS TR
LEFT JOIN RESSOURCE AS R
    ON R.IdTypeRess = TR.IdTypeRess
GROUP BY TR.IdTypeRess, TR.NomTypeRess
ORDER BY NombreRessources DESC;

/* permet de lister les 20 derniers logs avec leur niveau de log associé */
SELECT
    L.IdLog,
    L.DateLog,
    L.TimeLog,
    LL.NameLogLevel,
    L.CorpsLog
FROM LOG AS L
INNER JOIN LOGLEVEL AS LL
    ON LL.IdLogLevel = L.IdLogLevel
ORDER BY
    L.DateLog DESC,
    L.TimeLog DESC,
    L.IdLog DESC
LIMIT 20;

/* les procédures stockées ensuite */

/* permet de récupérer les statistiques globales de la plateforme */
DROP PROCEDURE IF EXISTS SP_StatistiquesPlateforme;

DELIMITER $$

CREATE PROCEDURE SP_StatistiquesPlateforme()
BEGIN
    SELECT
        (SELECT COUNT(*) FROM USER_)
            AS NombreUtilisateurs,
        (SELECT COUNT(*) FROM ROLE)
            AS NombreRoles,
        (SELECT COUNT(*) FROM LABORATOIRE)
            AS NombreLaboratoires,
        (SELECT COUNT(*) FROM EXPERIMENTATION)
            AS NombreExperimentations,
        (SELECT COUNT(*) FROM INSCRIPTION)
            AS NombreInscriptions,
        (SELECT COUNT(*) FROM RESSOURCE)
            AS NombreRessources,
        (SELECT COUNT(*) FROM DOCUMENT)
            AS NombreDocuments,
        (SELECT COUNT(*) FROM LOG)
            AS NombreLogs;
END$$

DELIMITER ;

CALL SP_StatistiquesPlateforme();

/* permet de rechercher les logs par niveau de log */
DROP PROCEDURE IF EXISTS SP_RechercherLogs;

DELIMITER $$

CREATE PROCEDURE SP_RechercherLogs(
    IN p_IdLogLevel INT
)
BEGIN
    SELECT
        L.IdLog,
        L.DateLog,
        L.TimeLog,
        LL.NameLogLevel,
        L.CorpsLog
    FROM LOG AS L
    INNER JOIN LOGLEVEL AS LL
        ON LL.IdLogLevel = L.IdLogLevel
    WHERE L.IdLogLevel = p_IdLogLevel
    ORDER BY L.DateLog DESC, L.TimeLog DESC, L.IdLog DESC;
END$$

DELIMITER ;

CALL SP_RechercherLogs(1);

/* permet de récupérer le nombre d'utilisateurs par rôle */
DROP PROCEDURE IF EXISTS SP_UtilisateursParRole;

DELIMITER $$

CREATE PROCEDURE SP_UtilisateursParRole()
BEGIN
    SELECT
        R.IdRole,
        R.NomRole,
        COUNT(U.IdUser) AS NombreUtilisateurs
    FROM ROLE AS R
    LEFT JOIN USER_ AS U
        ON U.IdRole = R.IdRole
    GROUP BY R.IdRole, R.NomRole
    ORDER BY NombreUtilisateurs DESC;
END$$

DELIMITER ;

CALL SP_UtilisateursParRole();
