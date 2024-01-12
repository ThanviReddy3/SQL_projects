USE team;

CREATE VIEW scores AS
(SELECT m.Team, m.total, w.won, m.total - w.won  AS Lost
FROM
    (SELECT Team, COUNT(Team) AS total FROM
        (SELECT team1 AS Team FROM tournament
        UNION ALL
        SELECT team2 AS Team FROM tournament) AS Teamstotal
        GROUP BY Team) AS m
JOIN
(SELECT winner, COUNT(winner) AS won
FROM tournament
where winner is not null
GROUP BY winner) AS w ON m.Team = w.winner);

select * from scores;



CREATE VIEW Tied as
(SELECT Team, SUM(draw) AS Draws
FROM (
    SELECT team1 AS Team, SUM(CASE WHEN winner IS NULL THEN 1 ELSE 0 END) AS draw
    FROM tournament
    GROUP BY team1
    UNION ALL
    SELECT team2 AS Team, SUM(CASE WHEN winner IS NULL THEN 1 ELSE 0 END) AS draw
    FROM tournament
    GROUP BY team2
) AS CombinedDraws
GROUP BY Team);

CREATE VIEW team_score AS
(select p.Team, p.total as Matches, p.Won, (p.Lost-t.Draws) As Lost, t.Draws
from scores as p
JOIN tied as t
ON (p.team=t.team));

CREATE TABLE score_table AS
(SELECT *, ((pt.Won*2)+pt.Draws) AS Points FROM team_score as pt);

select * from score_table;