-- CREACION DE LA BASE DE DATOS

CREATE DATABASE Mundial2026
GO

USE Mundial2026;

-- CREACION DE LAS TABLAS

CREATE TABLE Pais(
idPais smallint CONSTRAINT Pk_Pais PRIMARY KEY,
nombre_pais varchar(50) not null CONSTRAINT UQ_pais UNIQUE,
confederacion varchar(30) not null
);

CREATE TABLE Grupos(
idGrupo smallint CONSTRAINT Pk_Grupo PRIMARY KEY,
letra char(1) not null CONSTRAINT UQ_letra UNIQUE,
nombre_grupo varchar(20) not null
);

CREATE TABLE Equipos(
idEquipo smallint CONSTRAINT Pk_Equipo PRIMARY KEY,
nombre_equipo varchar(60) not null CONSTRAINT UQ_equipo UNIQUE,
idPais smallint not null CONSTRAINT Fk_Equipos_Pais
	FOREIGN KEY REFERENCES Pais,
idGrupo smallint not null CONSTRAINT Fk_Equipos_Grupos
	FOREIGN KEY REFERENCES Grupos
);

CREATE TABLE Estadios(
idEstadio tinyint IDENTITY CONSTRAINT Pk_Estadio PRIMARY KEY,
nombre_estadio nvarchar(30) not null CONSTRAINT UQ_estadio UNIQUE,
ciudad varchar(30) not null,
capacidad integer null
	CONSTRAINT Ck_capacidadEstadio
		CHECK(capacidad>=0)
);

CREATE TABLE Arbitros(
idArbitro smallint IDENTITY CONSTRAINT Pk_Arbitro PRIMARY KEY,
nombre_arbitro nvarchar(50) not null,
nacionalidad varchar(50) not null
);

CREATE TABLE Jugadores(
idJugador integer IDENTITY CONSTRAINT Pk_Jugador PRIMARY KEY,
nombre_jugador nvarchar(50) not null,
apellido_jugador nvarchar(50) not null,
fecha_nacimiento date,
posicion_categoria varchar(20) not null
	CONSTRAINT CK_categoria
		CHECK (posicion_categoria IN ('Portero','Defensa','Mediocampista','Delantero')),
numero tinyint not null
	CONSTRAINT Ck_numero
		CHECK(numero BETWEEN 1 AND 99),
idEquipo smallint CONSTRAINT Fk_Jugadores_Equipos
	FOREIGN KEY REFERENCES Equipos
);

CREATE TABLE Fases(
idFase tinyint CONSTRAINT Pk_fase PRIMARY KEY,
nombre_fase varchar(30) not null CONSTRAINT UQ_tipo UNIQUE,
tipo varchar(20) 
	CONSTRAINT	Ck_tipofase
		CHECK(tipo IN ('Grupos','Eliminacion')),
orden tinyint not null
);

CREATE TABLE Partidos(
idPartido integer CONSTRAINT Pk_Partido PRIMARY KEY,
goles_local tinyint not null 
	CONSTRAINT Df_golesL DEFAULT 0,
goles_visitante tinyint not null
	CONSTRAINT Df_golesV DEFAULT 0,
fecha date not null,
idFase tinyint not null CONSTRAINT Fk_Partidos_Fases
	FOREIGN KEY REFERENCES Fases,
idEstadio tinyint not null CONSTRAINT Fk_Partidos_Estadio
	FOREIGN KEY REFERENCES Estadios,
idEquipoLocal smallint not null CONSTRAINT Fk_Partidos_Equipos_Local
	FOREIGN KEY REFERENCES Equipos,
idEquipoVisitante smallint not null CONSTRAINT Fk_Partidos_Equipos_Visitante
	FOREIGN KEY REFERENCES Equipos,
CONSTRAINT Ck_Equipos_Distintos 
	CHECK (idEquipoLocal <> idEquipoVisitante),
CONSTRAINT Ck_golesLV 
	CHECK(goles_local >=0 AND goles_visitante >=0)
);

CREATE TABLE Eventos(
idEvento integer CONSTRAINT Pk_Evento PRIMARY KEY,
tipo_evento varchar(40) not null 
	CONSTRAINT Ck_tipoevento
		CHECK(tipo_evento IN('Gol','Autogol','Tarjeta Amarilla','Tarjeta Roja','Cambio','Penal')),
idJugador integer not null CONSTRAINT Fk_Eventos_Jugadores
	FOREIGN KEY REFERENCES Jugadores,
idPartido integer not null CONSTRAINT Fk_Eventos_Partidos
	FOREIGN KEY REFERENCES Partidos
);

CREATE TABLE ESTADISTICA_JUGADOR(
asistencias tinyint not null CONSTRAINT Df_asistencias DEFAULT 0,
tarjetas_amarillas tinyint not null CONSTRAINT Df_tarjetasA DEFAULT 0,
tarjetas_rojas tinyint not null CONSTRAINT Df_tarjetasR DEFAULT 0,
idJugador integer not null CONSTRAINT Fk_EstadisticaJugador_Jugadores
	FOREIGN KEY REFERENCES Jugadores,
idFase tinyint not null CONSTRAINT Fk_EstadisticaJugaodr_Fases
	FOREIGN KEY REFERENCES Fases,
  CONSTRAINT Pk_EstadisticaJugador PRIMARY KEY(idJugador, idFase)
);

CREATE TABLE ESTADISTICA_EQUIPO(
goles_favor tinyint not null CONSTRAINT Df_golesF DEFAULT 0,
goles_contra tinyint not null CONSTRAINT Df_golesC DEFAULT 0,
tarjetas_amarillas tinyint not null CONSTRAINT Df_tarjetasA_estadisticaE DEFAULT 0,
tarjetas_rojas tinyint not null CONSTRAINT Df_tarjetasR_estadisticaE DEFAULT 0,
idEquipo smallint not null CONSTRAINT Fk_Estadisticaequipo_Equipo
	FOREIGN KEY REFERENCES Equipos,
idFase tinyint not null CONSTRAINT Fk_Estadisticaequipo_Fase
	FOREIGN KEY REFERENCES Fases,
CONSTRAINT Pk_EstadisticaEquipo PRIMARY KEY(idequipo, idfase),
CONSTRAINT Ck_goles CHECK(goles_favor >=0 AND goles_contra >=0)
);

CREATE TABLE PARTIDO_ARBITRO(
rol varchar(30) not null CONSTRAINT Ck_rol CHECK(rol IN('Principal','Asistente 1','Asistente 2','Cuarto Arbitro','VAR')),
idPartido integer not null CONSTRAINT Fk_Partidoarbitro_Partido
	FOREIGN KEY REFERENCES Partidos,
idArbitro smallint not null CONSTRAINT Fk_Partidoarbitro_Arbitro
	FOREIGN KEY REFERENCES Arbitros,
CONSTRAINT Pk_PartidoArbitro PRIMARY KEY(idPartido, idArbitro)
);

--INSERTAR REGISTROS EN LAS TABLAS

-- 1. TABLA PAIS
SELECT * FROM Pais;

INSERT INTO Pais
VALUES(1,'Mexico','CONCACAF'),(2,'Sudafrica','CAF'),
(3,'Corea del Sur','AFC'), (4,'Republica Checa','UEFA'), 
(5,'Canada','CONCACAF'),(6,'Bosnia y H.','UEFA'),
(7,'Qatar','AFC'),(8,'Suiza','UEFA'),
(9,'Brasil','CONMEBOL'),(10,'Marruecos','CAF'),
(11,'Haiti','CONCACAF'),(12,'Escocia','UEFA'),
(13,'Estados Unidos','CONCACAF'),(14,'Paraguay','CONMEBOL'),
(15,'Australia','AFC'),(16,'Turquia','UEFA'),
(17,'Alemania','UEFA'),(18,'Curazao','CONCACAF'),
(19,'Costa de Marfil','CAF'),(20,'Ecuador','CONMEBOL'),
(21,'Paises Bajos','UEFA'),(22,'Japon','AFC'),
(23,'Suecia','UEFA'),(24,'Tunez','CAF'),
(25,'Belgica','UEFA'),(26,'Egipto','CAF'),
(27,'Iran','AFC'),(28,'Nueva Zelanda','OFC'),
(29,'España','UEFA'),(30,'Cabo Verde','CAF'),
(31,'Arabia Saudita','AFC'),(32,'Uruguay','CONMEBOL'),
(33,'Francia','UEFA'),(34,'Senegal','CAF'),
(35,'Irak','AFC'),(36,'Noruega','UEFA'),
(37,'Argentina','CONMEBOL'),(38,'Argelia','CAF'),
(39,'Austria','UEFA'),(40,'Jordania','AFC'),
(41,'Portugal','UEFA'),(42,'RD del Congo','CAF'),
(43,'Uzbekistan','AFC'),(44,'Colombia','CONMEBOL'),
(45,'Inglaterra','UEFA'),(46,'Croacia','UEFA'),
(47,'Ghana','CAF'),(48,'Panama','CONCACAF');


-- 2. TABLA GRUPOS
SELECT * FROM Grupos;

INSERT INTO Grupos
VALUES(1,'A','Grupo A'),(2,'B','Grupo B'),
(3,'C','Grupo C'),(4,'D','Grupo D'),
(5,'E','Grupo E'),(6,'F','Grupo F'),
(7,'G','Grupo G'),(8,'H','Grupo H'),
(9,'I','Grupo I'),(10,'J','Grupo J'),
(11,'K','Grupo K'),(12,'L','Grupo L');

-- 3. TABLA EQUIPOS
SELECT * FROM Equipos;

INSERT INTO Equipos
VALUES(1,'Seleccion de Mexico',1,1), (2,'Seleccion de Sudafrica',2,1),
(3,'Seleccion de Corea del Sur',3,1), (4,'Seleccion de Republica Checa',4,1),
(5,'Seleccion de Canada',5,2), (6,'Seleccion de Bosnia y H.',6,2),
(7,'Seleccion de Qatar',7,2), (8,'Seleccion de Suiza',8,2),
(9,'Seleccion de Brasil',9,3), (10,'Seleccion de Marruecos',10,3),
(11,'Seleccion de Haiti',11,3), (12,'Seleccion de Escocia',12,3),
(13,'Seleccion de Estados Unidos',13,4), (14,'Seleccion de Paraguay',14,4),
(15,'Seleccion de Australia',15,4), (16,'Seleccion de Turquia',16,4),
(17,'Seleccion de Alemania',17,5), (18,'Seleccion de Curazao',18,5),
(19,'Seleccion de Costa de Marfil',19,5), (20,'Seleccion de Ecuador',20,5),
(21,'Seleccion de Paises Bajos',21,6), (22,'Seleccion de Japon',22,6),
(23,'Seleccion de Suecia',23,6), (24,'Seleccion de Tunez',24,6),
(25,'Seleccion de Belgica',25,7), (26,'Seleccion de Egipto',26,7),
(27,'Seleccion de Iran',27,7), (28,'Seleccion de Nueva Zelanda',28,7),
(29,'Seleccion de España',29,8), (30,'Seleccion de Cabo Verde',30,8),
(31,'Seleccion de Arabia Saudita',31,8), (32,'Seleccion de Uruguay',32,8),
(33,'Seleccion de Francia',33,9), (34,'Seleccion de Senegal',34,9),
(35,'Seleccion de Irak',35,9), (36,'Seleccion de Noruega',36,9),
(37,'Seleccion de Argentina',37,10), (38,'Seleccion de Argelia',38,10),
(39,'Seleccion de Austria',39,10), (40,'Seleccion de Jordania',40,10),
(41,'Seleccion de Portugal',41,11), (42,'Seleccion de RD del Congo',42,11),
(43,'Seleccion de Uzbekistan',43,11), (44,'Seleccion de Colombia',44,11),
(45,'Seleccion de Inglaterra',45,12), (46,'Seleccion de Croacia',46,12),
(47,'Seleccion de Ghana',47,12), (48,'Seleccion de Panama',48,12);

-- 4. TABLA ESTADIOS
SELECT * FROM Estadios;

INSERT INTO Estadios 
VALUES('Estadio Azteca','Ciudad de MExico',87523),
('MetLife Stadium','Nueva York',82500),
('AT&T Stadium','Dallas',80000),
('Arrowhead Stadium','Kansas City',76416),
('NRG Stadium','Houston',72220),
('Mercedes-Benz Stadium','Atlanta',71000),
('SoFi Stadium','Los Angeles',70240),
('Lincoln Financial Field','Filadelfia',69796),
('Lumen Field','Seattle',69000),
('Levis Stadium','San Francisco',68500),
('Gillette Stadium','Boston',65878),
('Hard Rock Stadium','Miami',64767),
('BC Place','Vancouver',54500),
('Estadio BBVA','Monterrey',53500),
('Estadio Akron','Guadalajara',48071),
('BMO Field','Toronto',45000);

-- 5. TABLA ARBITROS

SELECT * FROM Arbitros;

INSERT INTO Arbitros (nombre_arbitro, nacionalidad) VALUES 
('Piero Maza', 'Chile'),
('Wilmar Roldan', 'Colombia'),
('Jesus Valenzuela', 'Venezuela'),
('Cesar Ramos', 'Mexico'),
('Ivan Barton', 'El Salvador'),
('Ismail Elfath', 'Estados Unidos'),
('Danny Makkelie', 'Paises Bajos'),
('Szymon Marciniak', 'Polonia'),
('Clement Turpin', 'Francia'),
('Michael Oliver', 'Inglaterra'),
('Slavko Vincic', 'Eslovenia'),
('Mustapha Ghorbal', 'Argelia'),
('Bamlak Tessema', 'Etiopia'),
('Yoshimi Yamashita', 'Japon'),
('Ma Ning', 'China'),
('Alireza Faghani', 'Iran');


-- 6. TABLA JUGADORES

SELECT * FROM Jugadores;

INSERT INTO Jugadores (nombre_jugador, apellido_jugador, fecha_nacimiento, posicion_categoria, numero, idEquipo)
VALUES ('Guillermo', 'Ochoa', '1985/07/13', 'Portero', 1, 1),
('Héctor', 'Herrera', '1990/04/19', 'Mediocampista', 16, 1),
('Ronwen', 'Williams', '1992/01/21', 'Portero', 1, 2),
('Thapelo', 'Mokoena', '1997/01/24', 'Mediocampista', 4, 2),
('Son', 'Heung-min', '1992/07/08', 'Delantero', 7, 3),
('Kim', 'Min-jae', '1996/11/15', 'Defensa', 4, 3),
('Tomáš', 'Souček', '1995/02/27', 'Mediocampista', 7, 4),
('Patrik', 'Schick', '1996/01/24', 'Delantero', 10, 4),
('Alphonso', 'Davies', '2000/11/02', 'Defensa', 19, 5),
('Jonathan', 'David', '2000/01/14', 'Delantero', 20, 5),
('Edin', 'Džeko', '1986/03/17', 'Delantero', 11, 6),
('Sead', 'Kolašinac', '1993/06/20', 'Defensa', 5, 6),
('Akram', 'Afif', '1996/11/18', 'Delantero', 11, 7),
('Saad', 'Al Sheeb', '1990/02/19', 'Portero', 1, 7),
('Granit', 'Xhaka', '1992/09/27', 'Mediocampista', 10, 8),
('Yann', 'Sommer', '1988/12/17', 'Portero', 1, 8),
('Neymar', 'Júnior', '1992/02/05', 'Delantero', 10, 9),
('Alisson', 'Becker', '1992/10/02', 'Portero', 1, 9),
('Achraf', 'Hakimi', '1998/11/04', 'Defensa', 2, 10),
('Yassine', 'Bounou', '1991/04/05', 'Portero', 1, 10),
('Duckens', 'Nazon', '1994/04/07', 'Delantero', 9, 11),
('Johny', 'Placide', '1988/10/29', 'Portero', 1, 11),
('Andrew', 'Robertson', '1994/03/11', 'Defensa', 3, 12),
('Scott', 'McTominay', '1996/12/08', 'Mediocampista', 4, 12),
('Christian', 'Pulisic', '1998/09/18', 'Delantero', 10, 13),
('Matt', 'Turner', '1994/06/24', 'Portero', 1, 13),
('Miguel', 'Almirón', '1994/02/10', 'Mediocampista', 10, 14),
('Gustavo', 'Gómez', '1993/05/06', 'Defensa', 15, 14),
('Mathew', 'Ryan', '1992/04/08', 'Portero', 1, 15),
('Ajdin', 'Hrustić', '1996/07/05', 'Mediocampista', 10, 15),
('Hakan', 'Çalhanoğlu', '1994/02/08', 'Mediocampista', 10, 16),
('Merih', 'Demiral', '1998/03/05', 'Defensa', 3, 16),
('Joshua', 'Kimmich', '1995/02/08', 'Mediocampista', 6, 17),
('Jamal', 'Musiala', '2003/02/26', 'Delantero', 10, 17),
('Leandro', 'Bacuna', '1991/08/21', 'Mediocampista', 7, 18),
('Eloy', 'Room', '1989/02/06', 'Portero', 1, 18),
('Sébastien', 'Haller', '1994/06/22', 'Delantero', 22, 19),
('Franck', 'Kessié', '1996/12/19', 'Mediocampista', 8, 19),
('Moisés', 'Caicedo', '2001/11/02', 'Mediocampista', 23, 20),
('Enner', 'Valencia', '1989/11/04', 'Delantero', 13, 20),
('Virgil', 'van Dijk', '1991/07/08', 'Defensa', 4, 21),
('Frenkie', 'de Jong', '1997/05/12', 'Mediocampista', 21, 21),
('Takefusa', 'Kubo', '2001/06/04', 'Delantero', 20, 22),
('Wataru', 'Endo', '1993/02/09', 'Mediocampista', 6, 22),
('Alexander', 'Isak', '1999/09/21', 'Delantero', 9, 23),
('Viktor', 'Gyökeres', '1998/06/04', 'Delantero', 17, 23),
('Youssef', 'Msakni', '1990/10/28', 'Delantero', 7, 24),
('Aissa', 'Laidouni', '1996/12/13', 'Mediocampista', 14, 24),
('Kevin', 'De Bruyne', '1991/06/28', 'Mediocampista', 7, 25),
('Romelu', 'Lukaku', '1993/05/13', 'Delantero', 10, 25),
('Mohamed', 'Salah', '1992/06/15', 'Delantero', 10, 26),
('Mohamed', 'Elneny', '1992/07/11', 'Mediocampista', 17, 26),
('Mehdi', 'Taremi', '1992/07/18', 'Delantero', 9, 27),
('Alireza', 'Beiranvand', '1992/09/21', 'Portero', 1, 27),
('Chris', 'Wood', '1991/12/07', 'Delantero', 9, 28),
('Matt', 'Garbett', '2002/04/13', 'Mediocampista', 7, 28),
('Pedri', 'González', '2002/11/25', 'Mediocampista', 8, 29),
('Álvaro', 'Morata', '1992/10/23', 'Delantero', 7, 29),
('Ryan', 'Mendes', '1990/01/08', 'Delantero', 7, 30),
('Vozinha', 'Fernandes', '1986/06/03', 'Portero', 1, 30),
('Salem', 'Al-Dawsari', '1991/08/19', 'Delantero', 10, 31),
('Mohammed', 'Al-Owais', '1991/10/10', 'Portero', 1, 31),
('Federico', 'Valverde', '1998/07/22', 'Mediocampista', 15, 32),
('Darwin', 'Núñez', '1999/06/24', 'Delantero', 9, 32),
('Kylian', 'Mbappé', '1998/12/20', 'Delantero', 10, 33),
('Aurélien', 'Tchouaméni', '2000/01/27', 'Mediocampista', 8, 33),
('Sadio', 'Mané', '1992/04/10', 'Delantero', 10, 34),
('Kalidou', 'Koulibaly', '1991/06/20', 'Defensa', 3, 34),
('Aymen', 'Hussein', '1996/03/22', 'Delantero', 18, 35),
('Jalal', 'Hachim', '1996/02/10', 'Portero', 1, 35),
('Erling', 'Haaland', '2000/07/21', 'Delantero', 9, 36),
('Martin', 'Ødegaard', '1998/12/17', 'Mediocampista', 10, 36),
('Lionel', 'Messi', '1987/06/24', 'Delantero', 10, 37),
('Julián', 'Álvarez', '2000/01/31', 'Delantero', 9, 37),
('Riyad', 'Mahrez', '1991/02/21', 'Delantero', 7, 38),
('Ismaël', 'Bennacer', '1997/12/01', 'Mediocampista', 22, 38),
('David', 'Alaba', '1992/06/24', 'Defensa', 8, 39),
('Marcel', 'Sabitzer', '1994/03/17', 'Mediocampista', 9, 39),
('Mousa', 'Al-Tamari', '1997/06/10', 'Delantero', 10, 40),
('Yazeed', 'Abulaila', '1992/01/03', 'Portero', 1, 40),
('Cristiano', 'Ronaldo', '1985/02/05', 'Delantero', 7, 41),
('Bruno', 'Fernandes', '1994/09/08', 'Mediocampista', 8, 41),
('Chancel', 'Mbemba', '1994/08/08', 'Defensa', 5, 42),
('Cédric', 'Bakambu', '1991/04/11', 'Delantero', 17, 42),
('Eldor', 'Shomurodov', '1995/06/29', 'Delantero', 14, 43),
('Utkir', 'Yusupov', '1991/01/04', 'Portero', 1, 43),
('Luis', 'Díaz', '1997/01/13', 'Delantero', 7, 44),
('James', 'Rodríguez', '1991/07/12', 'Mediocampista', 10, 44),
('Harry', 'Kane', '1993/07/28', 'Delantero', 9, 45),
('Jude', 'Bellingham', '2003/06/29', 'Mediocampista', 10, 45),
('Luka', 'Modrić', '1985/09/09', 'Mediocampista', 10, 46),
('Joško', 'Gvardiol', '2002/01/23', 'Defensa', 4, 46),
('Mohammed', 'Kudus', '2000/08/02', 'Mediocampista', 10, 47),
('Thomas', 'Partey', '1993/06/13', 'Mediocampista', 5, 47),
('Adalberto', 'Carrasquilla', '1998/11/28', 'Mediocampista', 10, 48),
('José', 'Fajardo', '1993/08/18', 'Delantero', 17, 48);


-- 7. TABLA FASES

SELECT * FROM Fases;
--idFase identifica de manera unica cada fase, clave primaria
--idOrden indican la secuencia en que se juega cada fase

INSERT INTO Fases (idFase, nombre_fase, tipo, orden)
VALUES (1, 'Fase de Grupos', 'Grupos', 1),
       (2, 'Dieciseisavos de Final', 'Eliminacion', 2),
       (3, 'Octavos de Final', 'Eliminacion', 3),
       (4, 'Cuartos de Final', 'Eliminacion', 4),
       (5, 'Semifinal', 'Eliminacion', 5),
       (6, 'Tercer Puesto', 'Eliminacion', 6),
       (7, 'Final', 'Eliminacion', 7);


-- 8. TABLA PARTIDOS

SELECT * FROM Partidos;

INSERT INTO Partidos
(idPartido, goles_local, goles_visitante, fecha, idFase, idEstadio, idEquipoLocal, idEquipoVisitante)
VALUES(1, 2, 1, '2026-06-11', 1, 1, 1, 2), (2, 1, 1, '2026-06-11', 1, 2, 3, 4),
(3, 3, 0, '2026-06-12', 1, 3, 5, 6), (4, 2, 2, '2026-06-12', 1, 4, 7, 8),
(5, 1, 0, '2026-06-13', 1, 4, 9, 10), (6, 0, 2, '2026-06-13', 1, 5, 11, 12),
(7, 3, 1, '2026-06-14', 1, 6, 13, 14), (8, 2, 1, '2026-06-14', 1, 7, 15, 16),
(9, 1, 2, '2026-06-15', 1, 8, 17, 18), (10, 0, 0, '2026-06-15', 1, 9, 19, 20),
(11, 2, 3, '2026-06-16', 1, 10, 21, 22), (12, 1, 1, '2026-06-16', 1, 11, 23, 24),
-- DIECISEISAVOS
(13, 2, 1, '2026-06-20', 2, 12, 1, 5), (14, 1, 0, '2026-06-20', 2, 13, 9, 13),
(15, 3, 2, '2026-06-21', 2, 14, 17, 21), (16, 0, 1, '2026-06-21', 2, 15, 25, 29),
-- OCTAVOS
(17, 2, 0, '2026-06-25', 3, 1, 1, 9), (18, 1, 2, '2026-06-25', 3, 2, 17, 25),
(19, 3, 1, '2026-06-26', 3, 3, 5, 13), (20, 0, 2, '2026-06-26', 3, 4, 21, 29),
-- CUARTOS
(21, 2, 1, '2026-06-30', 4, 5, 1, 17), (22, 1, 0, '2026-06-30', 4, 6, 5, 29),
-- SEMIFINAL
(23, 2, 2, '2026-07-04', 5, 7, 1, 5), (24, 1, 0, '2026-07-04', 5, 8, 17, 29),
-- TERCER PUESTO
(25, 3, 2, '2026-07-08', 6, 9, 5, 29),
-- FINAL
(26, 2, 1, '2026-07-10', 7, 10, 1, 17);


-- 9. TABLA EVENTOS
SELECT * FROM EVENTOS;

INSERT INTO Eventos
(idEvento, tipo_evento, idJugador, idPartido)
VALUES(1, 'Gol', 1, 1), (2, 'Gol', 5, 1),
(3, 'Gol', 2, 1), (4, 'Gol', 9, 3),
(5, 'Gol', 10, 3), (6, 'Gol', 11, 3),
(7, 'Gol', 13, 4), (8, 'Gol', 17, 4),
(9, 'Gol', 14, 4), (10, 'Gol', 18, 4),
(11, 'Gol', 21, 5), (12, 'Tarjeta Amarilla', 22, 5),
(13, 'Gol', 23, 6), (14, 'Gol', 24, 6),
(15, 'Tarjeta Roja', 11, 6), (16, 'Gol', 25, 7),
(17, 'Gol', 26, 7), (18, 'Gol', 27, 7),
(19, 'Gol', 28, 7), (20, 'Gol', 29, 8),
(21, 'Gol', 30, 8), (22, 'Gol', 31, 8),
(23, 'Gol', 32, 9), (24, 'Gol', 33, 9),
(25, 'Gol', 34, 9), (26, 'Tarjeta Amarilla', 35, 10),
(27, 'Tarjeta Amarilla', 36, 10), (28, 'Gol', 1, 26),
(29, 'Gol', 17, 26), (30, 'Gol', 2, 26);


-- 10. TABLA ESTADISTICA JUGADOR

SELECT * FROM ESTADISTICA_JUGADOR;

INSERT INTO ESTADISTICA_JUGADOR
(asistencias, tarjetas_amarillas, tarjetas_rojas, idJugador, idFase)
VALUES
-- FASE 1 (todos participan)
(2, 0, 0, 1, 1), (3, 1, 0, 2, 1),
(1, 0, 0, 5, 1), (2, 0, 0, 9, 1),
(1, 1, 0, 17, 1), (2, 0, 0, 25, 1),
(1, 0, 0, 33, 1), (2, 0, 0, 37, 1),
-- DIECISEISAVOS (menos jugadores)
(1, 0, 0, 1, 2), (2, 0, 0, 9, 2),
(1, 0, 0, 17, 2), (1, 0, 0, 25, 2),
-- OCTAVOS
(1, 0, 0, 1, 3), (2, 0, 0, 9, 3),
(1, 0, 0, 17, 3),
-- CUARTOS
(1, 0, 0, 1, 4), (2, 0, 0, 9, 4),
-- SEMIFINAL
(1, 0, 0, 1, 5), (0, 0, 0, 9, 5),
-- TERCER PUESTO
(1, 0, 0, 9, 6),
-- FINAL
(2, 0, 0, 1, 7), (1, 0, 0, 9, 7);



-- 11. TABLA ESTADISTICA_EQUIPO

SELECT * FROM ESTADISTICA_EQUIPO;

INSERT INTO ESTADISTICA_EQUIPO
(goles_favor, goles_contra, tarjetas_amarillas, tarjetas_rojas, idEquipo, idFase)
VALUES (6, 3, 2, 0, 1, 1), (4, 5, 3, 0, 2, 1),
(5, 4, 1, 0, 3, 1), (3, 6, 2, 1, 4, 1),
(7, 2, 1, 0, 5, 1), (2, 6, 3, 0, 6, 1),
(6, 4, 2, 0, 7, 1), (5, 5, 2, 0, 8, 1),
(8, 3, 1, 0, 9, 1), (4, 4, 2, 0, 10, 1),
-- DIECISEISAVOS
(3, 1, 1, 0, 1, 2), (2, 1, 1, 0, 9, 2),
(4, 2, 0, 0, 17, 2), (1, 3, 1, 0, 25, 2),
-- OCTAVOS
(2, 1, 1, 0, 1, 3), (3, 2, 1, 0, 9, 3),
(1, 2, 0, 0, 17, 3),
-- CUARTOS
(2, 1, 0, 0, 1, 4), (1, 2, 1, 0, 9, 4),
-- SEMIFINAL
(1, 1, 0, 0, 1, 5), (1, 2, 1, 0, 9, 5),
-- TERCER PUESTO
(1, 1, 0, 0, 9, 6),
-- FINAL
(3, 2, 1, 0, 1, 7), (2, 3, 1, 0, 9, 7);




-- 12. TABLA PARTIDO_ARBITRO

SELECT * FROM PARTIDO_ARBITRO;

INSERT INTO PARTIDO_ARBITRO
(rol, idPartido, idArbitro)
VALUES('Principal', 1, 1), ('Asistente 1', 1, 2),
('Asistente 2', 1, 3), ('VAR', 1, 4), ('Principal', 2, 5),
('Asistente 1', 2, 6), ('Asistente 2', 2, 7),
('VAR', 2, 8), ('Principal', 3, 9),
('Asistente 1', 3, 10), ('Asistente 2', 3, 11),
('VAR', 3, 12), ('Principal', 4, 13),
('Asistente 1', 4, 14), ('Asistente 2', 4, 15),
('VAR', 4, 16), ('Principal', 5, 2),
('Asistente 1', 5, 3), ('Asistente 2', 5, 4),
('VAR', 5, 1), ('Principal', 6, 6),
('Asistente 1', 6, 7), ('Asistente 2', 6, 8),
('VAR', 6, 5), ('Principal', 7, 10),
('Asistente 1', 7, 11), ('Asistente 2', 7, 12),
('VAR', 7, 9), ('Principal', 8, 14),
('Asistente 1', 8, 15), ('Asistente 2', 8, 16),
('VAR', 8, 13);

SELECT * FROM PAIS;
SELECT * FROM GRUPOS;
SELECT * FROM EQUIPOS;
SELECT * FROM Estadios;
SELECT * FROM Jugadores;

SELECT * FROM Arbitros;
SELECT * FROM ESTADISTICA_EQUIPO;
SElECT * FROM PARTIDO_ARBITRO;
SELECT * FROM ESTADISTICA_JUGADOR;

SELECT * FROM Eventos;
SELECT * FROM Fases;
SELECT * FROM Partidos;




