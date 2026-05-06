
-- CONSULTAS DE BASE DE DATOS MUNDIAL2026
use Mundial2026;
---------------------------------------------------
--5 CONSULTAS SQL (lo que la BD debe responder)
---------------------------------------------------

-- 1. Obtener el nombre de los jugadores de manera ascendente por nombre

SELECT Jugadores.idJugador, Jugadores.nombre_jugador, Jugadores.apellido_jugador, 
Jugadores.posicion_categoria, Jugadores.numero
FROM Jugadores
ORDER BY nombre_jugador ASC;

-- 2. Obtener la lista de jugadores con su seleccion correspondiente

SELECT nombre_jugador, apellido_jugador, posicion_categoria,
nombre_equipo
FROM Jugadores
INNER JOIN Equipos
	ON Jugadores.idEquipo = Equipos.idEquipo;

-- 3. Obtener que el nombre de estadio, fecha que se llevo a cabo el partido
-- nombre de las seleccion que jugaron

SELECT Estadios.nombre_estadio, Partidos.fecha, EL.nombre_equipo as Equipo_local,
EV.nombre_equipo as Equipo_Visitante
FROM Partidos
	INNER JOIN Estadios
		ON Partidos.idEstadio = Estadios.idEstadio
	INNER JOIN Equipos as EL
		ON Partidos.idEquipoLocal = EL.idEquipo
	INNER JOIN Equipos as EV
		ON Partidos.idEquipoVisitante = EV.idEquipo
	ORDER BY Partidos.fecha ASC;

-- 4. Obtener el listado de Arbitros con sus nombre, rol, id de partidos y la fecha
-- que se llevo a cabo cada partido

SELECT Arbitros.nombre_arbitro, PARTIDO_ARBITRO.rol, Partidos.idPartido,
Partidos.fecha
FROM PARTIDO_ARBITRO
	INNER JOIN Arbitros
		ON PARTIDO_ARBITRO.idArbitro = Arbitros.idArbitro
	INNER JOIN Partidos
		ON PARTIDO_ARBITRO.idPartido = Partidos.idPartido
	ORDER BY nombre_arbitro;

-- 5. Listar que jugador anoto y en que partido

SELECT Jugadores.idJugador, Jugadores.nombre_jugador, Jugadores.apellido_jugador,
Partidos.idPartido, Eventos.tipo_evento
FROM Eventos
INNER JOIN Jugadores
	ON Eventos.idJugador = Jugadores.idJugador
INNER JOIN Partidos
	ON Eventos.idPartido = Partidos.idPartido
WHERE Eventos.tipo_evento = 'Gol';


--------------------------------------------------
-- 5 REPORTES QUE LA BASE DE DATOS DEBE ENTREGAR
--------------------------------------------------

-- 1. Ranking de equipos con mayor cantidad de goles anotados
--de mayor a menor 

SELECT Equipos.nombre_equipo, 
	SUM(ESTADISTICA_EQUIPO.goles_favor) AS Total_Goles
FROM ESTADISTICA_EQUIPO
INNER JOIN Equipos
	ON ESTADISTICA_EQUIPO.idEquipo = Equipos.idEquipo
GROUP BY Equipos.nombre_equipo
ORDER BY Total_Goles DESC;

-- 2. Reporte de Goles por Jugador

SELECT Jugadores.nombre_jugador, Jugadores.apellido_jugador,
Equipos.nombre_equipo,
COUNT(*) AS Total_Goles_Jugador
FROM Eventos
INNER JOIN Jugadores
	ON Eventos.idJugador = Jugadores.idJugador
INNER JOIN Equipos
	ON Jugadores.idEquipo = Equipos.idEquipo
WHERE Eventos.tipo_evento ='Gol'
GROUP BY Jugadores.nombre_jugador, Jugadores.apellido_jugador,
		Equipos.nombre_equipo
ORDER BY Total_Goles_Jugador DESC;
	
-- 3. Reporte de partidos por fase, utilizando procedimiento
--alamacenado 
DROP PROCEDURE IF EXISTS Sp_PartidosPorFase;
GO

CREATE PROCEDURE Sp_PartidosPorFase
	@idFase TINYINT
AS
BEGIN
	SELECT Partidos.idPartido, Partidos.fecha,
		   EL.nombre_equipo AS Equipo_Local,
		   EV.nombre_equipo AS Equipo_Visitante,
		   Estadios.nombre_estadio, Fases.orden
	FROM Partidos
	INNER JOIN Fases
		ON Partidos.idFase = Fases.idFase
	INNER JOIN Equipos EL
		ON Partidos.idEquipoLocal = EL.idEquipo
	INNER JOIN Equipos EV
		ON Partidos.idEquipoVisitante = EV.idEquipo
	INNER JOIN Estadios
		ON Partidos.idEstadio = Estadios.idEstadio
	WHERE Partidos.idFase = @idFase
	ORDER BY Partidos.fecha;
END;
GO

EXEC Sp_PartidosPorFase 7;

select * from fases;

-- 4. Reporte que permite conocer que seleccion acumularon
-- mas tarjetas 

SELECT Equipos.nombre_equipo,
       SUM(ESTADISTICA_EQUIPO.tarjetas_amarillas) AS Total_Amarillas,
       SUM(ESTADISTICA_EQUIPO.tarjetas_rojas) AS Total_Rojas
FROM ESTADISTICA_EQUIPO 
INNER JOIN Equipos 
    ON ESTADISTICA_EQUIPO.idEquipo = Equipos.idEquipo
GROUP BY Equipos.nombre_equipo
ORDER BY Total_Rojas DESC, Total_Amarillas DESC;

-- 5. Reporte de tabla de posicion en general
--calcula punto, diferencia de goles y rendimiento

-- Calcula Puntos, Diferencia de Goles y rendimiento.

SELECT 
    Grupos.letra AS Grupo,
    Equipos.nombre_equipo AS Selección,
    ESTADISTICA_EQUIPO.goles_favor AS Goles_Favor,
    ESTADISTICA_EQUIPO.goles_contra AS Goles_Contra,
    (CAST(ESTADISTICA_EQUIPO.goles_favor AS INT) - CAST(ESTADISTICA_EQUIPO.goles_contra AS INT)) AS Diferencia_Goles,
    ESTADISTICA_EQUIPO.tarjetas_amarillas AS Tarjeta_Amarilla,
    ESTADISTICA_EQUIPO.tarjetas_rojas AS Tarjeta_Roja,
    Fases.nombre_fase AS Etapa
FROM ESTADISTICA_EQUIPO 
INNER JOIN Equipos 
	ON ESTADISTICA_EQUIPO.idEquipo = Equipos.idEquipo
INNER JOIN Grupos  
	ON Equipos.idGrupo = Grupos.idGrupo
INNER JOIN Fases 
	ON ESTADISTICA_EQUIPO.idFase = Fases.idFase
WHERE Fases.idFase = 7 
ORDER BY Grupos.letra ASC, Diferencia_Goles DESC, ESTADISTICA_EQUIPO.goles_favor DESC;