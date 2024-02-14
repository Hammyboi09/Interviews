SELECT 
    c.contest_id AS con,
    c.hacker_id AS ha,
    c.name AS na,
    SUM(m.total_submissions),
    SUM(m.total_accepted_submissions),
    SUM(m.total_views),
    SUM(m.total_unique_views)
FROM 
    Contests c
JOIN 
    Colleges l ON c.contest_id = l.contest_id
JOIN 
    Challenges h ON h.college_id = l.college_id
JOIN 
    (
        SELECT 
            challenge_id, 
            total_submissions, 
            total_accepted_submissions,
            0 AS total_views, 
            0 AS total_unique_views 
        FROM 
            Submission_Stats 
        UNION ALL 
        SELECT 
            challenge_id, 
            0, 
            0, 
            total_views, 
            total_unique_views 
        FROM 
            View_Stats
    ) m ON h.challenge_id = m.challenge_id
GROUP BY 
    c.contest_id, 
    c.hacker_id, 
    c.name 
HAVING 
    SUM(m.total_submissions) != 0 
    AND SUM(m.total_accepted_submissions) != 0 
    AND SUM(m.total_views) != 0 
    AND SUM(m.total_unique_views) != 0 
ORDER BY 
    c.contest_id;
