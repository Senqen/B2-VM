DROP TABLE IF EXISTS ligne_panier;
DROP TABLE IF EXISTS ligne_commande;
DROP TABLE IF EXISTS commande;
DROP TABLE IF EXISTS chaussure;
DROP TABLE IF EXISTS adresse;
DROP TABLE IF EXISTS etat;
DROP TABLE IF EXISTS utilisateur;
DROP TABLE IF EXISTS marque;
DROP TABLE IF EXISTS fournisseur;
DROP TABLE IF EXISTS type_chaussure;
DROP TABLE IF EXISTS pointure;


CREATE TABLE IF NOT EXISTS pointure(
   code_pointure INT NOT NULL AUTO_INCREMENT,
   libelle_pointure VARCHAR(50),
   PRIMARY KEY(code_pointure)
);

CREATE TABLE IF NOT EXISTS type_chaussure(
   id_type_chaussure INT NOT NULL AUTO_INCREMENT,
   libelle_type_chaussure VARCHAR(50),
   PRIMARY KEY(id_type_chaussure)
);

CREATE TABLE IF NOT EXISTS fournisseur(
   id_fournisseur INT NOT NULL AUTO_INCREMENT,
   nom_fournisseur VARCHAR(50),
   num_tel_fournisseur VARCHAR(50),
   PRIMARY KEY(id_fournisseur)
);

CREATE TABLE IF NOT EXISTS marque(
   id_marque INT NOT NULL AUTO_INCREMENT,
   libelle_marque VARCHAR(50),
   PRIMARY KEY(id_marque)
);

CREATE TABLE IF NOT EXISTS utilisateur(
   id_utilisateur INT NOT NULL AUTO_INCREMENT,
   login VARCHAR(255),
   email VARCHAR(255),
   password VARCHAR(255),
   role VARCHAR(255),
   nom VARCHAR(255),
   est_actif INT,
   PRIMARY KEY(id_utilisateur)
);

CREATE TABLE IF NOT EXISTS etat(
   id_etat INT NOT NULL AUTO_INCREMENT,
   libelle_etat VARCHAR(50),
   PRIMARY KEY(id_etat)
);

CREATE TABLE IF NOT EXISTS adresse(
   id_adresse INT NOT NULL AUTO_INCREMENT,
   nom VARCHAR(50),
   rue VARCHAR(50),
   code_postal INT,
   ville VARCHAR(50),
   date_utilisation DATE,
   utilisateur_id INT NOT NULL,
   valide INT,
   PRIMARY KEY(id_adresse),
   FOREIGN KEY(utilisateur_id) REFERENCES utilisateur(id_utilisateur)
);


CREATE TABLE IF NOT EXISTS chaussure(
   num_chaussure INT NOT NULL AUTO_INCREMENT,
   nom_chaussure VARCHAR(50),
   description_chaussure VARCHAR(500),
   prix_chaussure decimal(15,2),
   stock_chaussure INT(10),
   image_chaussure VARCHAR(50),
   idtype_chaussure INT(11),
   codepointure INT(11),
   idmarque INT(11),
   idfournisseur INT(11),
   PRIMARY KEY(num_chaussure),
   CONSTRAINT fk_chaussure_type_chaussure FOREIGN KEY(idtype_chaussure) REFERENCES type_chaussure(id_type_chaussure),
   CONSTRAINT fk_chaussure_pointure FOREIGN KEY(codepointure) REFERENCES pointure(code_pointure),
   CONSTRAINT fk_chaussure_marque FOREIGN KEY(idmarque) REFERENCES marque(id_marque),
   CONSTRAINT fk_chaussure_fournisseur FOREIGN KEY(idfournisseur) REFERENCES fournisseur(id_fournisseur)
);

CREATE TABLE IF NOT EXISTS commande(
   id_commande INT NOT NULL AUTO_INCREMENT,
   date_achat date,
   idetat INT,
   idutilisateur INT,
   id_adresse_fact INT,
   id_adresse_livr INT,
   PRIMARY KEY(id_commande),
   FOREIGN KEY(idetat) REFERENCES etat(id_etat),
   FOREIGN KEY(idutilisateur) REFERENCES utilisateur(id_utilisateur),
   CONSTRAINT fk_commande_adresse FOREIGN KEY(id_adresse_fact) REFERENCES adresse(id_adresse),
   CONSTRAINT fk_commande_adresse1 FOREIGN KEY(id_adresse_livr) REFERENCES adresse(id_adresse)
);

CREATE TABLE IF NOT EXISTS ligne_commande(
   numchaussure INT(11),
   idcommande INT(11),
   prix decimal(15,2),
   quantite INT(11),
   PRIMARY KEY(numchaussure, idcommande),
   CONSTRAINT fk_lignecommande_chaussure FOREIGN KEY(numchaussure) REFERENCES chaussure(num_chaussure),
   CONSTRAINT fk_lignecommande_commande FOREIGN KEY(idcommande) REFERENCES commande(id_commande)
);

CREATE TABLE IF NOT EXISTS ligne_panier(
   numchaussure INT(11),
   idutilisateur INT(11),
   quantite INT(11),
   date_ajout date,
   PRIMARY KEY(numchaussure, idutilisateur),
   CONSTRAINT fk_lignepanier_chaussure FOREIGN KEY(numchaussure) REFERENCES chaussure(num_chaussure),
   CONSTRAINT fk_lignepanier_utilisateur FOREIGN KEY(idutilisateur) REFERENCES utilisateur(id_utilisateur)
);

INSERT INTO etat(libelle_etat) VALUES ('en cours de traitement'),('expédié'),('validé');

INSERT INTO pointure(code_pointure, libelle_pointure) VALUES
(NULL, '36'),
(NULL, '37'),
(NULL, '38'),
(NULL, '39'),
(NULL, '40'),
(NULL, '41'),
(NULL, '42'),
(NULL, '43'),
(NULL, '44'),
(NULL, '45'),
(NULL, '46'),
(NULL, '47'),
(NULL, '48'),
(NULL, '49'),
(NULL, '50');

INSERT INTO fournisseur(id_fournisseur, nom_fournisseur, num_tel_fournisseur) VALUES
(NULL, 'choes & co', '0682459653'),
(NULL, 'chaussexpress', '0682459654' ),
(NULL, 'chausséco', '0682459655'),
(NULL, 'chausselegant', '0682459656'),
(NULL, 'chausséomoane', '0682459657'),
(NULL, 'happyfeet', '0682459658');

INSERT INTO type_chaussure(id_type_chaussure, libelle_type_chaussure) VALUES
(NULL, 'baskets'),
(NULL, 'bottes'),
(NULL, 'bottines'),
(NULL, 'mocassins'),
(NULL, 'derbies'),
(NULL, 'espadrilles'),
(NULL, 'sandales'),
(NULL, 'tongs'),
(NULL, 'babouches');

INSERT INTO marque(id_marque, libelle_marque) VALUES
(NULL, 'flexifeet'),
(NULL, 'neukeuh'),
(NULL, 'ervon'),
(NULL, 'ecomocs'),
(NULL, 'silverqueek'),
(NULL, 'mapu'),
(NULL, 'rasrivie'),
(NULL, 'stachmou'),
(NULL, 'ristama'),
(NULL, 'schoubba');

INSERT INTO chaussure(num_chaussure, nom_chaussure, description_chaussure, prix_chaussure, stock_chaussure, image_chaussure, idtype_chaussure, codepointure, idmarque, idfournisseur) VALUES
(NULL, 'Baskets basse en cuir', 'des baskets basses en cuir agréable à porter.', 100.00, 10, 'basket_basse.jpg', 1, 3, 2, 2),
(NULL, 'Converses', 'des chaussures montantes agréable à porter.', 120.00, 10, 'converses.jpeg', 1, 3, 3, 6),
(NULL, 'Mocassins en cuir', 'des mocassins en cuir de veau.', 300.00, 10, 'mocassins_cuir.jpg', 4, 10, 4, 4),
(NULL, 'Claquettes', 'des sandales en caoutchouc parfait pour aller à la plage', 80.00, 10, 'claquettes.jpeg', 7, 3, 6, 5),
(NULL, 'Mules étroites', 'des sandales qui adaptant vos pieds, parfait pour la plage en été', 75.00, 10, 'mules.jpeg', 7, 5, 1, 3),
(NULL, 'Tongs industriel', 'des tongs style chantier parfait pour avoir du flow.', 120.00, 10, 'tongs_industriel.jpg', 8, 5, 2, 2),
(NULL, 'Crocs cars', 'vous voulez être rapide ? ces sandales en partenriat avec le film cars de disney sont parfaites pour vous.', 67.00, 10, 'crocs_cars.jpeg', 7, 1, 5, 3),
(NULL, 'Espadrilles en tissus', 'des chaussons pas chaussons en tissus et pour aller dans votre jardin ', 50.00, 10, 'espadrilles_tissus.jpeg', 6, 5, 7, 5),
(NULL, 'Espadrilles en cuir', 'espadrilles confortable en peau de vache', 80.00, 10, 'espadrilles_cuir.jpeg', 6, 4, 7, 3),
(NULL, 'Bottines léopard', 'ayez un flow et un charisme incroyable avec ces chaussures', 170.00, 10, 'bottines_leopard.jpeg', 3, 7, 8, 4),
(NULL, 'Bottines schellsie ', 'des bottines en cuir classique agréable pour vos pieds.', 400.00, 10, 'bottines_Schellsie.jpeg', 3, 9, 8, 1),
(NULL, 'Bottes de pluie', 'des bottes en caoutchouc à hauteur mollet. vos pieds seront invincible contre la pluie. ', 160.00, 10, 'bottes_pluie.jpg', 2, 6, 9, 1),
(NULL, 'Bottes rex', 'bottes asiatique en cuir de chien. du grand luxe !.', 180.00, 10, 'bottes_Rex.jpg', 2, 3, 3, 4),
(NULL, 'Mocassins mariage', 'des mocassins style chêne à porter pour vos mariages', 60.00, 10, 'mocassins_mariage.jpeg', 4, 3, 10, 5),
(NULL, 'Derbies crunky', 'des chaussures en cuir à grosses semelles.', 200.00, 10, 'derbies_crunky.jpg', 5, 7, 8, 1),
(NULL, 'Derbies en cuir', 'ces derbies en cuir seront jolies à vos pieds.', 880.00, 10,  'derbies_cuir.jpg', 5, 5, 7, 4),
(NULL, 'Babouches laineuses', 'ces babouches tiendrons vos pieds bien au chaud.', 50.00, 10, 'babouche_laine.jpeg', 9, 7, 10, 2),
(NULL, 'Babouches simples', 'ces babouches en cuir sont agréables à porter.', 80.00, 10, 'babouche_simple.jpeg', 9, 9, 10, 6);

INSERT INTO utilisateur(login,email,password,role,nom,est_actif) VALUES
('admin','admin@admin.fr',
    'sha256$dPL3oH9ug1wjJqva$2b341da75a4257607c841eb0dbbacb76e780f4015f0499bb1a164de2a893fdbf',
    'ROLE_admin','admin','1'),
('client','client@client.fr',
    'sha256$1GAmexw1DkXqlTKK$31d359e9adeea1154f24491edaa55000ee248f290b49b7420ced542c1bf4cf7d',
    'ROLE_client','client','1'),
('client2','client2@client2.fr',
    'sha256$MjhdGuDELhI82lKY$2161be4a68a9f236a27781a7f981a531d11fdc50e4112d912a7754de2dfa0422',
    'ROLE_client','client2','1');

INSERT INTO utilisateur (login, email, password, role, nom, est_actif)
VALUES
('user01', 'user01@example.com', 'password01', 'ROLE_client', 'Dupont', 1),
('user02', 'user02@example.com', 'password02', 'ROLE_client', 'Martin', 1),
('user03', 'user03@example.com', 'password03', 'ROLE_client', 'Durand', 1),
('user04', 'user04@example.com', 'password04', 'ROLE_client', 'Dubois', 1),
('user05', 'user05@example.com', 'password05', 'ROLE_client', 'Bernard', 1),
('user06', 'user06@example.com', 'password06', 'ROLE_client', 'Petit', 1),
('user07', 'user07@example.com', 'password07', 'ROLE_client', 'Lefebvre', 1),
('user08', 'user08@example.com', 'password08', 'ROLE_client', 'Roux', 1),
('user09', 'user09@example.com', 'password09', 'ROLE_client', 'Moreau', 1),
('user10', 'user10@example.com', 'password10', 'ROLE_client', 'Fournier', 1);

INSERT INTO adresse (nom, rue, code_postal, ville, date_utilisation, utilisateur_id, valide)
VALUES
('Dupont', 'Rue de la Paix', 85001, 'Paris', '2022-03-15', 4, 1),
('Martin', 'Avenue des Champs-Élysées', 78008, 'Paris', '2022-03-16', 4, 1),
('Durand', 'Rue Saint-Antoine', 69002, 'Lyon', '2022-03-17', 5, 1),
('Dubois', 'Rue de Rivoli', 75004, 'Paris', '2022-03-18', 5, 1),
('Bernard', 'Boulevard Haussmann', 45009, 'Paris', '2022-03-19', 6, 1),
('Petit', 'Rue du Faubourg Saint-Honoré', 74008, 'Paris', '2022-03-20', 6, 1),
('Lefebvre', 'Rue de la République', 13001, 'Marseille', '2022-03-21', 7, 1),
('Roux', 'Rue de la Pompe', 75116, 'Paris', '2022-03-22', 7, 1),
('Moreau', 'Place Vendôme', 75001, 'Paris', '2022-03-23', 8, 1),
('Fournier', 'Rue des Petits Champs', 74001, 'Paris', '2022-03-24', 8, 1);

INSERT INTO commande(date_achat,idetat,idutilisateur,id_adresse_fact,id_adresse_livr)
VALUES
('2022-03-16',1,4,2,2),
('2022-03-20',1,7,4,4),
('2023-03-26',1,6,3,3),
('2022-03-30',1,4,5,5),
('2021-03-10',2,5,1,1);

describe chaussure;
describe marque;
describe fournisseur;
describe type_chaussure;
describe pointure;
describe ligne_panier;
describe ligne_commande;
describe adresse;
describe commande;
describe etat;
describe utilisateur;