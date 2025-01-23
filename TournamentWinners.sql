WITH PlayerScores AS (
    SELECT 
        first_player AS player_id,
        SUM(first_score) AS total_score
    FROM Matches
    GROUP BY first_player

    UNION ALL

    SELECT 
        second_player AS player_id,
        SUM(second_score) AS total_score
    FROM Matches
    GROUP BY second_player
),
TotalScores AS (
    SELECT 
        p.group_id,
        ps.player_id,
        SUM(ps.total_score) AS group_score
    FROM PlayerScores ps
    JOIN Players p
    ON ps.player_id = p.player_id
    GROUP BY p.group_id, ps.player_id
),
MaxScores AS (
    SELECT 
        group_id,
        MAX(group_score) AS max_score
    FROM TotalScores
    GROUP BY group_id
)
SELECT 
    ts.group_id,
    ts.player_id
FROM TotalScores ts
JOIN MaxScores ms
ON ts.group_id = ms.group_id AND ts.group_score = ms.max_score
WHERE ts.player_id = (
    SELECT MIN(player_id)
    FROM TotalScores ts2
    WHERE ts2.group_id = ts.group_id AND ts2.group_score = ts.group_score
)
ORDER BY ts.group_id;
