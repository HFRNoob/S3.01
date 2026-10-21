USE SAE301;
GO

-- ROLE : ENSEIGNANT-CHERCHEUR

-- Requête 1 : noms et statuts de toutes les expérimentations d'une équipe de recherche

SELECT NameTeam, NomExpe, Statut
FROM EXPERIMENTATION
INNER JOIN TEAM ON EXPERIMENTATION.IdExpe = TEAM.IdExpe
WHERE NameTeam = 'Team A';
GO


-- Requête 2 : nom, prénom et mail de tous les participants d'une expérimentation ayant donné leur consentement
-- VUE nécessaire:

DROP VIEW IF EXISTS ParticipantsInscrits;
GO

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
GO

-- Test de la vue :
-- SELECT * FROM ParticipantsInscrits;

SELECT NomUser, PrenomUser, MailUser
FROM ParticipantsInscrits
WHERE ConscentInscription = 1 AND NomExpe = 'Expérience 1';
GO


-- Requête 3 : suivi des inscriptions
-- Pour chaque expérimentation : nombre de participants par statut d'inscription et nombre de consentements recueillis parmi eux

SELECT IdExpe, NomExpe, NomStatutInscript,
       COUNT(*) AS NbParticipants,
       SUM(CASE WHEN ConscentInscription = 1 THEN 1 ELSE 0 END) AS NbConsentements
FROM ParticipantsInscrits
GROUP BY IdExpe, NomExpe, NomStatutInscript
ORDER BY NomExpe, NomStatutInscript;
GO


-- PROCEDURES STOCKEES

-- Procédure 1 : créer une expérimentation
DROP PROCEDURE IF EXISTS dbo.CreerExperimentation;
GO

CREATE OR ALTER PROCEDURE dbo.CreerExperimentation
    @NomExpe      VARCHAR(50),
    @DateDebExpe  DATE,
    @DateFinExpe  DATE,
    @Statut       VARCHAR(50),
    @IdLabo       INT,
    @DescExpe     VARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
	DECLARE @IdExpe INT;

    -- Gestion des erreurs
    IF @NomExpe IS NULL OR @NomExpe = ''
        THROW 50001, N'Le nom de l''expérimentation est obligatoire.', 1;

    IF @DateDebExpe IS NULL OR @DateFinExpe IS NULL
        THROW 50002, N'Les dates de début et de fin sont obligatoires.', 1;

    IF @DateFinExpe < @DateDebExpe
        THROW 50003, N'La date de fin ne peut pas être antérieure à la date de début.', 1;

    IF NOT EXISTS (SELECT 1 FROM LABORATOIRE WHERE IdLabo = @IdLabo)
        THROW 50004, N'Le laboratoire n''existe pas.', 1;

    -- Création
    BEGIN TRY
        BEGIN TRANSACTION;
		SET @IdExpe = (SELECT TOP 1 IdExpe FROM EXPERIMENTATION ORDER BY IdExpe DESC) +1;

        INSERT INTO EXPERIMENTATION (IdExpe, NomExpe, DescExpe, DateDebExpe, DateFinExpe, Statut, IdLabo)
        VALUES (@IdExpe, @NomExpe, @DescExpe, @DateDebExpe, @DateFinExpe, @Statut, @IdLabo);

        COMMIT TRANSACTION;
    END TRY
	BEGIN CATCH;
		ROLLBACK TRANSACTION;
	END CATCH;
END;
GO


-- Procédure 2 : créer un créneau pour une expérimentation
DROP PROCEDURE IF EXISTS dbo.CreerCreneau;
GO

CREATE OR ALTER PROCEDURE dbo.CreerCreneau
    @IdExpe       INT,
    @NomCreneau   VARCHAR(50),
    @DateCreneau  DATE,
    @DebCreneau   TIME,
    @FinCreneau   TIME
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DateDebExpe DATE, @DateFinExpe DATE, @IdCreneau INT;

	SELECT @DateDebExpe = DateDebExpe, @DateFinExpe = DateFinExpe FROM EXPERIMENTATION WHERE IdExpe = @IdExpe;


    -- Contrôles
    IF @DateDebExpe IS NULL
        THROW 50010, N'Expérimentation introuvable.', 1;

    IF @NomCreneau IS NULL OR @NomCreneau = ''
        THROW 50011, N'Le nom du créneau est obligatoire.', 1;

    IF @FinCreneau <= @DebCreneau
        THROW 50012, N'L''heure de fin doit être postérieure à l''heure de début.', 1;

    IF @DateCreneau < @DateDebExpe OR @DateCreneau > @DateFinExpe
        THROW 50013, N'La date du créneau doit être comprise dans la période de l''expérimentation.', 1;

    -- Création
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Pas de chevauchement avec un autre créneau de la même expérimentation le même jour
        IF EXISTS (SELECT 1 FROM CRENEAU
					WHERE IdExpe = @IdExpe
                    AND DateCreneau = @DateCreneau
					AND DebCreneau < @FinCreneau
					AND FinCreneau > @DebCreneau)
            THROW 50014, N'Ce créneau chevauche un créneau existant de cette expérimentation.', 1;

        SET @IdCreneau = (SELECT TOP 1 IdExpe FROM CRENEAU ORDER BY IdExpe DESC) +1;

        INSERT INTO CRENEAU (IdCreneau, NomCreneau, DateCreneau, DebCreneau, FinCreneau, IdExpe)
        VALUES (@IdCreneau, @NomCreneau, @DateCreneau, @DebCreneau, @FinCreneau, @IdExpe);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
    END CATCH
END;
GO



-- Procédure 3 : changer le statut d'inscription d'un participant à une expérimentation
DROP PROCEDURE IF EXISTS dbo.ChangerStatutInscription;
GO

CREATE OR ALTER PROCEDURE dbo.ChangerStatutInscription
    @IdUser            INT,
    @IdExpe            INT,
    @IdStatutInscript  INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Contrôles
    IF NOT EXISTS (SELECT 1 FROM PARTICIPER
                   WHERE IdUser = @IdUser AND IdExpe = @IdExpe)
        THROW 50020, N'Ce participant n''est pas inscrit à cette expérimentation.', 1;

    IF NOT EXISTS (SELECT 1 FROM STATUTINSCRIPTION
                   WHERE IdStatutInscript = @IdStatutInscript)
        THROW 50021, N'Statut d''inscription introuvable.', 1;

    -- Mise à jour
    UPDATE INSCRIPTION SET IdStatutInscript = @IdStatutInscript
	WHERE IdInscription IN (SELECT IdInscription FROM PARTICIPER WHERE IdUser = @IdUser AND IdExpe = @IdExpe);
END;
GO



USE SAE301;
GO

-- EXEMPLES D'UTILISATION
-- 1. CreerExperimentation
EXEC dbo.CreerExperimentation
    @NomExpe     = 'Expérience 11',
    @DateDebExpe = '2024-11-01',
    @DateFinExpe = '2024-11-10',
    @Statut      = 'En cours',
    @IdLabo      = 5,
    @DescExpe    = 'Etude de la perception des couleurs en environnement virtuel';

-- Vérification :
SELECT IdExpe, NomExpe, DateDebExpe, DateFinExpe, Statut, IdLabo
FROM EXPERIMENTATION
WHERE NomExpe = 'Expérience 11';
GO


-- 2. CreerCreneau
EXEC dbo.CreerCreneau
    @IdExpe      = 1,
    @NomCreneau  = 'Creneau 11',
    @DateCreneau = '2024-01-02',
    @DebCreneau  = '14:00:00',
    @FinCreneau  = '16:00:00';

-- Vérification :
SELECT IdCreneau, NomCreneau, DateCreneau, DebCreneau, FinCreneau
FROM CRENEAU
WHERE IdExpe = 1;
GO
-- 3. ChangerStatutInscription
-- Avant :
SELECT NomUser, PrenomUser, NomExpe, ConscentInscription, NomStatutInscript
FROM ParticipantsInscrits
WHERE NomUser = 'Voisee' AND NomExpe = 'Expérience 5';

EXEC dbo.ChangerStatutInscription
    @IdUser           = 6,
    @IdExpe           = 5,
    @IdStatutInscript = 3;

-- Après :
SELECT NomUser, PrenomUser, NomExpe, ConscentInscription, NomStatutInscript
FROM ParticipantsInscrits
WHERE NomUser = 'Voisee' AND NomExpe = 'Expérience 5';
GO

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
FROM dbo.EXPERIMENTATION AS E
INNER JOIN dbo.LABORATOIRE AS L
    ON L.IdLabo = E.IdLabo
WHERE E.Statut = 'En cours'
ORDER BY E.DateDebExpe;

GO

/* permet de lister les documents associés à une expérimentation donnée */
DECLARE @IdExpe INT = 1;
SELECT
    D.NomDoc,
    D.UrlDoc
FROM dbo.DOCUMENT AS D
WHERE D.IdExpe = @IdExpe
ORDER BY D.NomDoc;

GO

/* permet de lister les créneaux associés à une expérimentation donnée */ 
DECLARE @IdExpe INT = 1;
SELECT
    E.NomExpe,
    C.DateCreneau,
    C.NomCreneau,
    C.DebCreneau,
    C.FinCreneau
FROM dbo.CRENEAU AS C
INNER JOIN dbo.EXPERIMENTATION AS E
    ON E.IdExpe = C.IdExpe
WHERE C.IdExpe = @IdExpe
ORDER BY C.DateCreneau, C.DebCreneau;

GO

/* les procédures stockées ensuite */

/* permet de lister les expérimentations auxquelles un participant est inscrit avec son statut d'inscription */
CREATE OR ALTER PROCEDURE dbo.SP_MesExperimentations
    @IdUser INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        E.IdExpe,
        E.NomExpe,
        E.DateDebExpe,
        E.DateFinExpe,
        E.Statut AS StatutExpe,
        SI.NomStatutInscript AS StatutInscription,
        L.NomLabo
    FROM dbo.PARTICIPER AS P
    INNER JOIN dbo.EXPERIMENTATION AS E
        ON E.IdExpe = P.IdExpe
    INNER JOIN dbo.INSCRIPTION AS I
        ON I.IdInscription = P.IdInscription
    INNER JOIN dbo.STATUTINSCRIPTION AS SI
        ON SI.IdStatutInscript = I.IdStatutInscript
    INNER JOIN dbo.LABORATOIRE AS L
        ON L.IdLabo = E.IdLabo
    WHERE P.IdUser = @IdUser
    ORDER BY E.DateDebExpe DESC;
END;
GO

EXEC dbo.SP_MesExperimentations @IdUser = 6;

GO

/* permet de récupérer les créneaux de toutes les expérimentations auxquelles participe l'utilisateur.*/
CREATE OR ALTER PROCEDURE dbo.SP_MonPlanning
    @IdUser INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        E.NomExpe,
        C.NomCreneau,
        C.DateCreneau,
        C.DebCreneau,
        C.FinCreneau
    FROM dbo.PARTICIPER AS P
    INNER JOIN dbo.EXPERIMENTATION AS E
        ON E.IdExpe = P.IdExpe
    INNER JOIN dbo.CRENEAU AS C
        ON C.IdExpe = E.IdExpe
    WHERE P.IdUser = @IdUser
    ORDER BY C.DateCreneau, C.DebCreneau;
END;
GO

EXEC dbo.SP_MonPlanning @IdUser = 6;

GO

/* permet de récupérer les documents de toutes les expérimentations auxquelles participe l'utilisateur.*/
CREATE OR ALTER PROCEDURE dbo.SP_MesDocuments
    @IdUser INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT DISTINCT
        E.NomExpe,
        D.NomDoc,
        D.UrlDoc
    FROM dbo.PARTICIPER AS P
    INNER JOIN dbo.EXPERIMENTATION AS E
        ON E.IdExpe = P.IdExpe
    INNER JOIN dbo.DOCUMENT AS D
        ON D.IdExpe = E.IdExpe
    WHERE P.IdUser = @IdUser
    ORDER BY E.NomExpe, D.NomDoc;
END;
GO

EXEC dbo.SP_MesDocuments @IdUser = 6;

GO

/* pour l'administrateur */ 
/* requêtes classiques dabord */

/* permet de lister tous les utilisateurs avec leur rôle associé */
SELECT
    U.IdUser,
    U.NomUser,
    U.PrenomUser,
    U.MailUser,
    R.NomRole
FROM dbo.USER_ AS U
INNER JOIN dbo.ROLE AS R
    ON R.IdRole = U.IdRole
ORDER BY R.NomRole, U.NomUser;

GO
/* permet de lister le nombre de ressources par type de ressource */
SELECT
    TR.IdTypeRess,
    TR.NomTypeRess,
    COUNT(R.IdRess) AS NombreRessources
FROM dbo.TYPERESSOURCE AS TR
LEFT JOIN dbo.RESSOURCE AS R
    ON R.IdTypeRess = TR.IdTypeRess
GROUP BY TR.IdTypeRess, TR.NomTypeRess
ORDER BY NombreRessources DESC;

GO
/* permet de lister les 20 derniers logs avec leur niveau de log associé */
SELECT TOP (20)
    L.IdLog,
    L.DateLog,
    L.TimeLog,
    LL.NameLogLevel,
    L.CorpsLog
FROM dbo.LOG AS L
INNER JOIN dbo.LOGLEVEL AS LL
    ON LL.IdLogLevel = L.IdLogLevel
ORDER BY
    L.DateLog DESC,
    L.TimeLog DESC,
    L.IdLog DESC;

GO

/* les procédures stockées ensuite */

/* permet de récupérer les statistiques globales de la plateforme */
CREATE OR ALTER PROCEDURE dbo.SP_StatistiquesPlateforme
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        (SELECT COUNT(*) FROM dbo.USER_)
            AS NombreUtilisateurs,
        (SELECT COUNT(*) FROM dbo.ROLE)
            AS NombreRoles,
        (SELECT COUNT(*) FROM dbo.LABORATOIRE)
            AS NombreLaboratoires,
        (SELECT COUNT(*) FROM dbo.EXPERIMENTATION)
            AS NombreExperimentations,
        (SELECT COUNT(*) FROM dbo.INSCRIPTION)
            AS NombreInscriptions,
        (SELECT COUNT(*) FROM dbo.RESSOURCE)
            AS NombreRessources,
        (SELECT COUNT(*) FROM dbo.DOCUMENT)
            AS NombreDocuments,
        (SELECT COUNT(*) FROM dbo.LOG)
            AS NombreLogs;
END;
GO

EXEC dbo.SP_StatistiquesPlateforme;

GO

/* permet de rechercher les logs par niveau de log */
CREATE OR ALTER PROCEDURE dbo.SP_RechercherLogs
    @IdLogLevel INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        L.IdLog,
        L.DateLog,
        L.TimeLog,
        LL.NameLogLevel,
        L.CorpsLog
    FROM dbo.LOG AS L
    INNER JOIN dbo.LOGLEVEL AS LL
        ON LL.IdLogLevel = L.IdLogLevel
    WHERE L.IdLogLevel = @IdLogLevel
    ORDER BY L.DateLog DESC, L.TimeLog DESC, L.IdLog DESC;
END;
GO

EXEC dbo.SP_RechercherLogs @IdLogLevel = 1;

GO

/* permet de récupérer le nombre d'utilisateurs par rôle */
CREATE OR ALTER PROCEDURE dbo.SP_UtilisateursParRole
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        R.IdRole,
        R.NomRole,
        COUNT(U.IdUser) AS NombreUtilisateurs
    FROM dbo.ROLE AS R
    LEFT JOIN dbo.USER_ AS U
        ON U.IdRole = R.IdRole
    GROUP BY R.IdRole, R.NomRole
    ORDER BY NombreUtilisateurs DESC;
END;
GO

EXEC dbo.SP_UtilisateursParRole;

GO
