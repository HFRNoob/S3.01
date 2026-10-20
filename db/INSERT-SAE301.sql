USE SAE301;
/*SCRIPT INSERTION*/
/*TABLE ROLE*/
INSERT INTO ROLE VALUES(1, 'Enseignant-chercheur', 'Il conçoit, pilote et valide ses expérimentations de recherche.');
INSERT INTO ROLE VALUES(2, 'Gestionnaire de laboratoire', 'Il assure le soutien technique et organisationnel des expérimentations de recherche.');
INSERT INTO ROLE VALUES(3, 'Particiant', 'Il participe aux expérimentations.');
INSERT INTO ROLE VALUES(4, 'Responsable equipe de recherche', 'Il supervise les expérimentations et projets de recherche de l’équipe.');
INSERT INTO ROLE VALUES(5, 'Directeur de laboratoire', 'Il supervise les expérimentations et projets du laboratoire.');
INSERT INTO ROLE VALUES(6, 'Administrateur', 'Il est responsable du bon fonctionnement technique et organisationnel de l’application.');

/*TABLE CONTRAINTE*/
INSERT INTO CONTRAINTE VALUES(1, 'Lunettes', 'Le participant porte des lunettes');
INSERT INTO CONTRAINTE VALUES(2, 'Surdité', 'Le participant est malentendant');
INSERT INTO CONTRAINTE VALUES(3, 'Dyspraxie', 'Le participant a des difficultee motrices');
INSERT INTO CONTRAINTE VALUES(4, 'Daltonisme', 'Le participant a une perception alteree des couleures');
INSERT INTO CONTRAINTE VALUES(5, 'Dyscalculie', 'Le participant à des difficultees calculatoires');
INSERT INTO CONTRAINTE VALUES(6, 'Allergie', 'Le participant possede une ou plusieurs allergies');
INSERT INTO CONTRAINTE VALUES(7, 'Majorité', 'Le participant est majeur');
INSERT INTO CONTRAINTE VALUES(8, 'Dyslexie', 'Le participant a des difficulte pour lire du texte');
INSERT INTO CONTRAINTE VALUES(9, 'Handicap moteur', 'Le participant possede un ou plusieurs handicaps mettant a mal ses capacites motrices');
INSERT INTO CONTRAINTE VALUES(10, 'Grossesse', 'La participante est enceinte');

/*TABLE MESSAGERIE*/
INSERT INTO MESSAGERIE VALUES(1 , 'Yo!', '2026-01-16 12:32:22');
INSERT INTO MESSAGERIE VALUES(2 , 'Message', '2026-01-17 11:32:56');
INSERT INTO MESSAGERIE VALUES(3 , 'Repond au document', '2026-02-11 18:45:59');
INSERT INTO MESSAGERIE VALUES(4 , 'Bonsoir, peut-on changer l''heure de debut du creneau xy', '2026-01-18 17:45:34');
INSERT INTO MESSAGERIE VALUES(5 , 'J''ai remit le document sur l''experimentation', '2026-01-18 19:26:43');
INSERT INTO MESSAGERIE VALUES(6 , 'J''aimerai avoir un retour sur les resultat de l''expe XY', '2026-01-18 16:50:27');
INSERT INTO MESSAGERIE VALUES(7 , 'Les delai d''envoi du quetionnaire ont ete modifies pour le jour d''apres', '');
INSERT INTO MESSAGERIE VALUES(8 , 'Je n''arrive pas a renvoyer le document, j''ai besoin d''aide', '');
INSERT INTO MESSAGERIE VALUES(9 , 'Bonjour, je n''ai pas encore recu mes rétribution comment est ce que cela va se passer ?', '');
INSERT INTO MESSAGERIE VALUES(10 , 'Bonsoir, j''ai perdu le document...', '');

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