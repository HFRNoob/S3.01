/* pour enseignant chercheur */

/* les requetes classiques dabord */

SELECT E.IdExpe, E.NomExpe, L.NomLabo, E.DateDebExpe, E.DateFinExpe, E.Statut 
FROM dbo.EXPERIMENTATION AS E INNER JOIN dbo.LABORATOIRE AS L ON L.IdLabo = E.IdLab 
ORDER BY L.NomLabo, E.DateDebExpe;


DECLARE @IdExpe INT = 1;
SELECT
    C.NomCreneau,
    C.DateCreneau,
    C.DebCreneau,
    C.FinCreneau
FROM dbo.CRENEAU AS C
WHERE C.IdExpe = @IdExpe
ORDER BY C.DateCreneau, C.DebCreneau;


DECLARE @IdExpe INT = 1;
SELECT
    R.NomRess,
    TR.NomTypeRess
FROM dbo.RESSOURCE AS R
INNER JOIN dbo.TYPERESSOURCE AS TR
    ON TR.IdTypeRess = R.IdTypeRess
WHERE R.IdExpe = @IdExpe
ORDER BY TR.NomTypeRess, R.NomRess;

/* les procedures stockees ensuite */

/* permet de lister les participants d'une expérimentation avec leur statut d'inscription */
CREATE OR ALTER PROCEDURE dbo.StatutPart_ListeParticipantsExpe
    @IdExpe INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        U.IdUser,
        U.NomUser,
        U.PrenomUser,
        U.MailUser,
        SI.NomStatutInscript
    FROM dbo.PARTICIPER AS P
    INNER JOIN dbo.USER_ AS U
        ON U.IdUser = P.IdUser
    INNER JOIN dbo.INSCRIPTION AS I
        ON I.IdInscription = P.IdInscription
    INNER JOIN dbo.STATUTINSCRIPTION AS SI
        ON SI.IdStatutInscript = I.IdStatutInscript
    WHERE P.IdExpe = @IdExpe
    ORDER BY U.NomUser, U.PrenomUser;
END;
GO

EXEC dbo.StatutPart_ListeParticipantsExpe @IdExpe = 1;

/* permet de rajouter une expérimentation à un laboratoire existant */
CREATE OR ALTER PROCEDURE dbo.SP_CreerExperimentation
    @IdExpe INT,
    @NomExpe VARCHAR(50),
    @DescExpe VARCHAR(MAX),
    @DateDebExpe DATE,
    @DateFinExpe DATE,
    @Statut VARCHAR(50),
    @IdLabo INT
AS
BEGIN
    SET NOCOUNT ON;

    IF @DateFinExpe < @DateDebExpe
        THROW 50001, 'La date de fin doit être posterieure ou egale a la date de debut.', 1;

    IF NOT EXISTS (
        SELECT 1
        FROM dbo.LABORATOIRE
        WHERE IdLabo = @IdLabo
    )
        THROW 50002, 'Le laboratoire indique n existe pas.', 1;

    INSERT INTO dbo.EXPERIMENTATION (
        IdExpe, NomExpe, DescExpe,
        DateDebExpe, DateFinExpe, Statut, IdLabo
    )
    VALUES (
        @IdExpe, @NomExpe, @DescExpe,
        @DateDebExpe, @DateFinExpe, @Statut, @IdLabo
    );

    SELECT *
    FROM dbo.EXPERIMENTATION
    WHERE IdExpe = @IdExpe;
END;
GO

EXEC dbo.SP_CreerExperimentation
    @IdExpe = 11,
    @NomExpe = 'Etude environnementale',
    @DescExpe = 'Analyse de la qualite de l eau',
    @DateDebExpe = '2027-01-10',
    @DateFinExpe = '2027-02-10',
    @Statut = 'Planifiee',
    @IdLabo = 1;


/* permet de modifier le statut d'une expérimentation */
CREATE OR ALTER PROCEDURE dbo.SP_ModifierStatutExpe
    @IdExpe INT,
    @NouveauStatut VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.EXPERIMENTATION
    SET Statut = @NouveauStatut
    WHERE IdExpe = @IdExpe;

    IF @@ROWCOUNT = 0
        THROW 50003, 'Experimentation introuvable.', 1;

    SELECT IdExpe, NomExpe, Statut
    FROM dbo.EXPERIMENTATION
    WHERE IdExpe = @IdExpe;
END;
GO


EXEC dbo.SP_ModifierStatutExpe
    @IdExpe = 1,
    @NouveauStatut = 'Terminee';


/* pour le participant */

/* requêtes classiques dabord */

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


DECLARE @IdExpe INT = 1;
SELECT
    D.NomDoc,
    D.UrlDoc
FROM dbo.DOCUMENT AS D
WHERE D.IdExpe = @IdExpe
ORDER BY D.NomDoc;


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

EXEC dbo.SP_MesExperimentations @IdUser = 1;


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

EXEC dbo.SP_MonPlanning @IdUser = 1;

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

EXEC dbo.SP_MesDocuments @IdUser = 1;

/* pour l'administrateur */ 

/* requêtes classiques dabord */

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


SELECT
    TR.IdTypeRess,
    TR.NomTypeRess,
    COUNT(R.IdRess) AS NombreRessources
FROM dbo.TYPERESSOURCE AS TR
LEFT JOIN dbo.RESSOURCE AS R
    ON R.IdTypeRess = TR.IdTypeRess
GROUP BY TR.IdTypeRess, TR.NomTypeRess
ORDER BY NombreRessources DESC;


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
