INSERT INTO dbo.LABORATOIRE (IdLabo, NomLabo) VALUES 
(1, 'Laboratoire de Biologie'),
(2, 'Laboratoire de Chimie'),
(3, 'Laboratoire de Physique'),
(4, 'Laboratoire de Mathématiques'),
(5, 'Laboratoire dInformatique'),
(6, 'Laboratoire de Génie Civil'),
(7, 'Laboratoire de Mécanique'),
(8, 'Laboratoire dÉlectronique'),
(9, 'Laboratoire de Sciences de la Terre'),
(10, 'Laboratoire de Sciences Sociales');

GO

INSERT INTO dbo.TYPERESSOURCE (IdTypeRess, NomTypeRess) VALUES 
(1, 'Équipement de laboratoire'),
(2, 'Salle de cours');

GO

INSERT INTO dbo.EXPERIMENTATION (IdExpe, NomExpe, DescExpe, DateDebExpe, DateFinExpe, Statut, IdLabo) VALUES 
(1, 'Expérience 1', 'Description de lExpérience 1', '2024-01-01', '2024-01-10', 'En cours', 1),
(2, 'Expérience 2', 'Description de lExpérience 2', '2024-02-01', '2024-02-10', 'En cours', 2),
(3, 'Expérience 3', 'Description de lExpérience 3', '2024-03-01', '2024-03-10', 'En cours', 3),
(4, 'Expérience 4', 'Description de lExpérience 4', '2024-04-01', '2024-04-10', 'En cours', 4),
(5, 'Expérience 5', 'Description de lExpérience 5', '2024-05-01', '2024-05-10', 'En cours', 5),
(6, 'Expérience 6', 'Description de lExpérience 6', '2024-06-01', '2024-06-10', 'En cours', 6),
(7, 'Expérience 7', 'Description de lExpérience 7', '2024-07-01', '2024-07-10', 'En cours', 7),
(8, 'Expérience 8', 'Description de lExpérience 8', '2024-08-01', '2024-08-10', 'En cours', 8),
(9, 'Expérience 9', 'Description de lExpérience 9', '2024-09-01', '2024-09-10', 'En cours', 9),
(10, 'Expérience 10', 'Description de lExpérience 10', '2024-10-01', '2024-10-10', 'En cours', 10);

GO

INSERT INTO dbo.RESSOURCE (IdRess, NomRess, IdTypeRess, IdExpe) VALUES 
(1, 'Microscope', 1, 1),
(2, 'Centrifugeuse', 1, 2),
(3, 'Spectrophotomètre', 1, 3),
(4, 'Balance analytique', 1, 4),
(5, 'Pipette automatique', 1, 5),
(6, 'Agitateur magnétique', 1, 6),
(7, 'B202', 2, 7),
(8, 'Amphithéâtre', 2, 8),
(9, 'Salle Informatique', 2, 9),
(10, 'Casque VR', 1, 10);

GO



INSERT INTO dbo.CRENEAU (IdCreneau, NomCreneau, DateCreneau, DebCreneau, FinCreneau, IdExpe) VALUES 
(1, 'Creneau 1', '2024-01-01', '08:00:00', '10:00:00', 1),
(2, 'Creneau 2', '2024-01-02', '10:00:00', '12:00:00', 2),
(3, 'Creneau 3', '2024-01-03', '14:00:00', '16:00:00', 3),
(4, 'Creneau 4', '2024-01-04', '16:00:00', '18:00:00', 4),
(5, 'Creneau 5', '2024-01-05', '08:00:00', '10:00:00', 5),
(6, 'Creneau 6', '2024-01-06', '10:00:00', '12:00:00', 6),
(7, 'Creneau 7', '2024-01-07', '14:00:00', '16:00:00', 7),
(8, 'Creneau 8', '2024-01-08', '16:00:00', '18:00:00', 8),
(9, 'Creneau 9', '2024-01-09', '08:00:00', '10:00:00', 9),
(10, 'Creneau 10', '2024-01-10', '10:00:00', '12:00:00', 10);

GO

INSERT INTO dbo.DOCUMENT (IdDoc, UrlDoc, NomDoc, IdExpe) VALUES 
(1, 'http://example.com/doc1.pdf', 'Document 1', 1),
(2, 'http://example.com/doc2.pdf', 'Document 2', 2),
(3, 'http://example.com/doc3.pdf', 'Document 3', 3),
(4, 'http://example.com/doc4.pdf', 'Document 4', 4),
(5, 'http://example.com/doc5.pdf', 'Document 5', 5),
(6, 'http://example.com/doc6.pdf', 'Document 6', 6),
(7, 'http://example.com/doc7.pdf', 'Document 7', 7),
(8, 'http://example.com/doc8.pdf', 'Document 8', 8),
(9, 'http://example.com/doc9.pdf', 'Document 9', 9),
(10, 'http://example.com/doc10.pdf', 'Document 10', 10);

GO

INSERT INTO dbo.TEAM (IdTeam, NameTeam, IdExpe) VALUES 
(1, 'Team A', 1),
(2, 'Team B', 2),
(3, 'Team C', 3),
(4, 'Team D', 4),
(5, 'Team E', 5),
(6, 'Team F', 6),
(7, 'Team G', 7),
(8, 'Team H', 8),
(9, 'Team I', 9),
(10, 'Team J', 10);

GO
