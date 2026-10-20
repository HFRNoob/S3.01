USE SAE301;
/*SCRIPT INSERTION*/
/*TABLE ROLE*/
INSERT INTO ROLE VALUES(1, 'Enseignant-chercheur', 'Il conçoit, pilote et valide ses expérimentations de recherche.');
INSERT INTO ROLE VALUES(2, 'Gestionnaire de laboratoire', 'Il assure le soutien technique et organisationnel des expérimentations de recherche.');
INSERT INTO ROLE VALUES(3, 'Particiant', 'Il participe aux expérimentations.');
INSERT INTO ROLE VALUES(4, 'Responsable equipe de recherche', 'Il supervise les expérimentations et projets de recherche de l’équipe.');
INSERT INTO ROLE VALUES(5, 'Directeur de laboratoire', 'Il supervise les expérimentations et projets du laboratoire.');
INSERT INTO ROLE VALUES(6, 'Administrateur', 'Il est responsable du bon fonctionnement technique et organisationnel de l’application.');

/*TABLE USER_*/
INSERT INTO USER_ VALUES(1, 'Gelion', 'Evan', '2001-12-24', 'Homme', 'evan.gelion@gmail.com', 6);
INSERT INTO USER_ VALUES(2, 'Use', 'Jack', '1998-01-02', 'Homme', 'use.jack@outlook.fr', 5);
INSERT INTO USER_ VALUES(3, 'Smission', 'Gontran', '1986-03-31', 'Homme', 'smission-gontran@gmail.com', 1);
INSERT INTO USER_ VALUES(4, 'Isol', 'Cort', '2000-01-01', 'Homme', 'cortisol@gmail.com', 2);
INSERT INTO USER_ VALUES(5, 'Patro', 'Nathan', '1990-02-06', 'Autre', 'patro.nathan@yahoo.fr', 4);
INSERT INTO USER_ VALUES(6, 'Voisee', 'Apery', '2007-10-17', 'Femme', 'apreydu35@gmail.com', 3);
INSERT INTO USER_ VALUES(7, 'Naissance', 'Eva', '1970-07-25', 'Femme', 'eva.pro@gmail.com', 1);
INSERT INTO USER_ VALUES(8, 'Darque', 'Jeanne', '1993-04-13', 'Autre', 'jeannedarque@gmail.com', 1);
INSERT INTO USER_ VALUES(9, 'Delval', 'Thimeo', '2010-02-14', 'Homme', 'ththththth@gmail.com', 3);
INSERT INTO USER_ VALUES(10, 'Hebert', 'Ezekiel', '2007-01-31', 'Homme', 'swey@gmail.com', 3);

/*TABLE LABORATOIRE*/
INSERT INTO LABORATOIRE VALUES(1, 'Laboratoire de Biologie');
INSERT INTO LABORATOIRE VALUES(2, 'Laboratoire de Chimie');
INSERT INTO LABORATOIRE VALUES(3, 'Laboratoire de Physique');
INSERT INTO LABORATOIRE VALUES(4, 'Laboratoire de Mathématiques');
INSERT INTO LABORATOIRE VALUES(5, 'Laboratoire d''Informatique');
INSERT INTO LABORATOIRE VALUES(6, 'Laboratoire de Génie Civil');
INSERT INTO LABORATOIRE VALUES(7, 'Laboratoire de Mécanique');
INSERT INTO LABORATOIRE VALUES(8, 'Laboratoire d''Électronique');
INSERT INTO LABORATOIRE VALUES(9, 'Laboratoire de Sciences de la Terre');
INSERT INTO LABORATOIRE VALUES(10, 'Laboratoire de Sciences Sociales');

/*TABLE EXPERIMENTATION*/
INSERT INTO EXPERIMENTATION VALUES(1, 'Expérience 1', 'Description de l''Expérience 1', '2024-01-01', '2024-01-10', 'En cours', 1);
INSERT INTO EXPERIMENTATION VALUES(2, 'Expérience 2', 'Description de l''Expérience 2', '2024-02-01', '2024-02-10', 'En cours', 2);
INSERT INTO EXPERIMENTATION VALUES(3, 'Expérience 3', 'Description de l''Expérience 3', '2024-03-01', '2024-03-10', 'En cours', 3);
INSERT INTO EXPERIMENTATION VALUES(4, 'Expérience 4', 'Description de l''Expérience 4', '2024-04-01', '2024-04-10', 'En cours', 4);
INSERT INTO EXPERIMENTATION VALUES(5, 'Expérience 5', 'Description de l''Expérience 5', '2024-05-01', '2024-05-10', 'En cours', 5);
INSERT INTO EXPERIMENTATION VALUES(6, 'Expérience 6', 'Description de l''Expérience 6', '2024-06-01', '2024-06-10', 'En cours', 6);
INSERT INTO EXPERIMENTATION VALUES(7, 'Expérience 7', 'Description de l''Expérience 7', '2024-07-01', '2024-07-10', 'En cours', 7);
INSERT INTO EXPERIMENTATION VALUES(8, 'Expérience 8', 'Description de l''Expérience 8', '2024-08-01', '2024-08-10', 'En cours', 8);
INSERT INTO EXPERIMENTATION VALUES(9, 'Expérience 9', 'Description de l''Expérience 9', '2024-09-01', '2024-09-10', 'En cours', 9);
INSERT INTO EXPERIMENTATION VALUES(10, 'Expérience 10', 'Description de l''Expérience 10', '2024-10-01', '2024-10-10', 'En cours', 10);

/*TABLE STATUTINSCRIPTION*/
INSERT INTO STATUTINSCRIPTION VALUES(1, 'En cours de validation');
INSERT INTO STATUTINSCRIPTION VALUES(2, 'Refuse');
INSERT INTO STATUTINSCRIPTION VALUES(3, 'Accepte');

/*TABLE INSCRIPTION*/
INSERT INTO INSCRIPTION VALUES(1, 1, 3);
INSERT INTO INSCRIPTION VALUES(2, 1, 3);
INSERT INTO INSCRIPTION VALUES(3, 1, 1);
INSERT INTO INSCRIPTION VALUES(4, 1, 3);
INSERT INTO INSCRIPTION VALUES(5, 1, 3);
INSERT INTO INSCRIPTION VALUES(6, 1, 1);
INSERT INTO INSCRIPTION VALUES(7, 0, 2);
INSERT INTO INSCRIPTION VALUES(8, 0, 1);

INSERT INTO PARTICIPER VALUES(6, 1, 1);
INSERT INTO PARTICIPER VALUES(6, 2, 2);  
INSERT INTO PARTICIPER VALUES(6, 5, 3); 
INSERT INTO PARTICIPER VALUES(10, 1, 4);
INSERT INTO PARTICIPER VALUES(10, 3, 5);
INSERT INTO PARTICIPER VALUES(10, 9, 6);
INSERT INTO PARTICIPER VALUES(9, 3, 7);
INSERT INTO PARTICIPER VALUES(9, 10, 8);

/*TABLE TYPERESSOURCE*/
INSERT INTO TYPERESSOURCE VALUES(1, 'Equipement de laboratoire');
INSERT INTO TYPERESSOURCE VALUES(2, 'Salle de cours');

/*TABLE RESSOURCE*/
INSERT INTO RESSOURCE VALUES(1, 'Microscope', 1, 1);
INSERT INTO RESSOURCE VALUES(2, 'Centrifugeuse', 1, 2);
INSERT INTO RESSOURCE VALUES(3, 'Spectrophotometre', 1, 3);
INSERT INTO RESSOURCE VALUES(4, 'Balance analytique', 1, 4);
INSERT INTO RESSOURCE VALUES(5, 'Pipette automatique', 1, 5);
INSERT INTO RESSOURCE VALUES(6, 'Agitateur magnetique', 1, 6);
INSERT INTO RESSOURCE VALUES(7, 'B202', 2, 7);
INSERT INTO RESSOURCE VALUES(8, 'Amphitheatre', 2, 8);
INSERT INTO RESSOURCE VALUES(9, 'Salle Informatique', 2, 9);
INSERT INTO RESSOURCE VALUES(10, 'Casque VR', 1, 10);

/*TABLE CRENEAU*/
INSERT INTO CRENEAU VALUES(1, 'Creneau 1', '2024-01-01', '08:00:00', '10:00:00', 1);
INSERT INTO CRENEAU VALUES(2, 'Creneau 2', '2024-01-02', '10:00:00', '12:00:00', 2);
INSERT INTO CRENEAU VALUES(3, 'Creneau 3', '2024-01-03', '14:00:00', '16:00:00', 3);
INSERT INTO CRENEAU VALUES(4, 'Creneau 4', '2024-01-04', '16:00:00', '18:00:00', 4);
INSERT INTO CRENEAU VALUES(5, 'Creneau 5', '2024-01-05', '08:00:00', '10:00:00', 5);
INSERT INTO CRENEAU VALUES(6, 'Creneau 6', '2024-01-06', '10:00:00', '12:00:00', 6);
INSERT INTO CRENEAU VALUES(7, 'Creneau 7', '2024-01-07', '14:00:00', '16:00:00', 7);
INSERT INTO CRENEAU VALUES(8, 'Creneau 8', '2024-01-08', '16:00:00', '18:00:00', 8);
INSERT INTO CRENEAU VALUES(9, 'Creneau 9', '2024-01-09', '08:00:00', '10:00:00', 9);
INSERT INTO CRENEAU VALUES(10, 'Creneau 10', '2024-01-10', '10:00:00', '12:00:00', 10);

/*TABLE DOCUMENT*/
INSERT INTO DOCUMENT VALUES(1, 'http://example.com/doc1.pdf', 'Document 1', 1);
INSERT INTO DOCUMENT VALUES(2, 'http://example.com/doc2.pdf', 'Document 2', 2);
INSERT INTO DOCUMENT VALUES(3, 'http://example.com/doc3.pdf', 'Document 3', 3);
INSERT INTO DOCUMENT VALUES(4, 'http://example.com/doc4.pdf', 'Document 4', 4);
INSERT INTO DOCUMENT VALUES(5, 'http://example.com/doc5.pdf', 'Document 5', 5);
INSERT INTO DOCUMENT VALUES(6, 'http://example.com/doc6.pdf', 'Document 6', 6);
INSERT INTO DOCUMENT VALUES(7, 'http://example.com/doc7.pdf', 'Document 7', 7);
INSERT INTO DOCUMENT VALUES(8, 'http://example.com/doc8.pdf', 'Document 8', 8);
INSERT INTO DOCUMENT VALUES(9, 'http://example.com/doc9.pdf', 'Document 9', 9);
INSERT INTO DOCUMENT VALUES(10, 'http://example.com/doc10.pdf', 'Document 10', 10);

/*TABLE TEAM*/
INSERT INTO TEAM VALUES(1, 'Team A', 1);
INSERT INTO TEAM VALUES(2, 'Team B', 2);
INSERT INTO TEAM VALUES(3, 'Team C', 3);
INSERT INTO TEAM VALUES(4, 'Team D', 4);
INSERT INTO TEAM VALUES(5, 'Team E', 5);
INSERT INTO TEAM VALUES(6, 'Team F', 6);
INSERT INTO TEAM VALUES(7, 'Team G', 7);
INSERT INTO TEAM VALUES(8, 'Team H', 8);
INSERT INTO TEAM VALUES(9, 'Team I', 9);
INSERT INTO TEAM VALUES(10, 'Team J', 10);

/*TABLE CONTRAINTE*/
INSERT INTO CONTRAINTE VALUES(1, 'Lunettes', 'Le participant porte des lunettes');
INSERT INTO CONTRAINTE VALUES(2, 'Surdité', 'Le participant est malentendant');
INSERT INTO CONTRAINTE VALUES(3, 'Dyspraxie', 'Le participant a des difficultee motrices');
INSERT INTO CONTRAINTE VALUES(4, 'Daltonisme', 'Le participant a une perception alteree des couleures');
INSERT INTO CONTRAINTE VALUES(5, 'Dyscalculie', 'Le participant à des difficultees calculatoires');
INSERT INTO CONTRAINTE VALUES(6, 'Allergie', 'Le participant possede une ou plusieurs allergies');
INSERT INTO CONTRAINTE VALUES(7, 'Majorite', 'Le participant est majeur');
INSERT INTO CONTRAINTE VALUES(8, 'Dyslexie', 'Le participant a des difficulte pour lire du texte');
INSERT INTO CONTRAINTE VALUES(9, 'Handicap moteur', 'Le participant possede un ou plusieurs handicaps mettant a mal ses capacites motrices');
INSERT INTO CONTRAINTE VALUES(10, 'Grossesse', 'La participante est enceinte');

/*TABLE MESSAGERIE*/
INSERT INTO MESSAGERIE VALUES(1,  'Yo!', '2026-01-16 12:32:22', 1);
INSERT INTO MESSAGERIE VALUES(2,  'Message', '2026-01-17 11:32:56', 3);
INSERT INTO MESSAGERIE VALUES(3,  'Repond au document', '2026-02-11 18:45:59', 3);
INSERT INTO MESSAGERIE VALUES(4,  'Bonsoir, peut-on changer l''heure de debut du creneau xy', '2026-01-18 17:45:34', 6);
INSERT INTO MESSAGERIE VALUES(5,  'J''ai remit le document sur l''experimentation', '2026-01-18 19:26:43', 7);
INSERT INTO MESSAGERIE VALUES(6,  'J''aimerai avoir un retour sur les resultat de l''expe XY', '2026-01-18 16:50:27', 8);
INSERT INTO MESSAGERIE VALUES(7,  'Les delai d''envoi du quetionnaire ont ete modifies pour le jour d''apres', '2026-02-20 15:26:21', 7);
INSERT INTO MESSAGERIE VALUES(8,  'Je n''arrive pas a renvoyer le document, j''ai besoin d''aide', '2026-03-20 14:24:24', 9);
INSERT INTO MESSAGERIE VALUES(9,  'Bonjour, je n''ai pas encore recu mes rétribution comment est ce que cela va se passer ?', '2026-03-20 15:16:32', 10);
INSERT INTO MESSAGERIE VALUES(10, 'Bonsoir, j''ai perdu le document...', '2026-03-20 14:06:42', 6);

/*TABLE LIMITER*/
INSERT INTO LIMITER VALUES(6, 1);
INSERT INTO LIMITER VALUES(6, 6);
INSERT INTO LIMITER VALUES(6, 7);
INSERT INTO LIMITER VALUES(9, 8);
INSERT INTO LIMITER VALUES(9, 4);
INSERT INTO LIMITER VALUES(10, 2);
INSERT INTO LIMITER VALUES(10, 7);
INSERT INTO LIMITER VALUES(10, 5);

/*TABLE RECEVOIR*/
INSERT INTO RECEVOIR VALUES(4, 1);    -- Evan -> Cort
INSERT INTO RECEVOIR VALUES(8, 2);    -- Gontran -> Jeanne
INSERT INTO RECEVOIR VALUES(6, 3);    -- Gontran -> Apery
INSERT INTO RECEVOIR VALUES(4, 4);    -- Apery -> Cort 
INSERT INTO RECEVOIR VALUES(5, 5);    -- Eva -> Nathan 
INSERT INTO RECEVOIR VALUES(5, 6);    -- Jeanne -> Nathan
INSERT INTO RECEVOIR VALUES(9, 7);    -- Eva -> Thimeo
INSERT INTO RECEVOIR VALUES(10, 7);   -- Eva -> Ezekiel
INSERT INTO RECEVOIR VALUES(1, 8);    -- Thimeo -> Evan
INSERT INTO RECEVOIR VALUES(2, 9);    -- Ezekiel -> Jack
INSERT INTO RECEVOIR VALUES(4, 10);   -- Apery -> Cort

/*TABLE LOGLEVEL*/
INSERT INTO LOGLEVEL VALUES(1, 'DEBUG');
INSERT INTO LOGLEVEL VALUES(2, 'INFO');
INSERT INTO LOGLEVEL VALUES(3, 'WARNING');
INSERT INTO LOGLEVEL VALUES(4, 'ERROR');
INSERT INTO LOGLEVEL VALUES(5, 'CRITICAL');

/*TABLE LOG (IdLog, DateLog, TimeLog, CorpsLog, IdLogLevel)*/
INSERT INTO LOG VALUES(1, '2026-01-16', '08:00:12', 'Demarrage de l''application', 2);
INSERT INTO LOG VALUES(2, '2026-01-16', '12:32:22', 'Message 1 envoye par l''utilisateur 1', 2);
INSERT INTO LOG VALUES(3, '2026-01-17', '09:14:03', 'Connexion de l''utilisateur 3 (Enseignant-chercheur)', 2);
INSERT INTO LOG VALUES(4, '2026-01-18', '17:45:34', 'Demande de modification du creneau xy par l''utilisateur 6', 1);
INSERT INTO LOG VALUES(5, '2026-02-11', '18:44:10', 'Temps de reponse eleve lors de l''ouverture du document', 3);
INSERT INTO LOG VALUES(6, '2026-02-20', '15:26:21', 'Message 7 envoye a 2 destinataires', 2);
INSERT INTO LOG VALUES(7, '2026-03-02', '10:05:47', 'Inscription 7 refusee : consentement manquant pour l''utilisateur 9', 3);
INSERT INTO LOG VALUES(8, '2026-03-20', '14:20:58', 'Echec de l''envoi du document par l''utilisateur 9', 4);
INSERT INTO LOG VALUES(9, '2026-03-20', '14:30:15', 'Tentative de connexion echouee pour le compte evan.gelion@gmail.com', 3);
INSERT INTO LOG VALUES(10, '2026-03-21', '03:12:09', 'Perte de connexion a la base de donnees', 5);
