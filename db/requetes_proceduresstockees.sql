/* gurvan met la partie enseignant chercheur ici */

prout



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

EXEC dbo.SP_MesExperimentations @IdUser = 1;

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

EXEC dbo.SP_MonPlanning @IdUser = 1;

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

EXEC dbo.SP_MesDocuments @IdUser = 1;

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
