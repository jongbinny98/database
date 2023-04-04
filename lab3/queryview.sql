-- find the number of open exits for each highway whose highwayNum appears in at leastone exit in MisdirectedExitView where isExitOpen is TRUE
SELECT h.highwayNum, h.length, COUNT(*) AS openMisdirectedExitCount
FROM Exits e, Highways h, MisdirectedExitView m
WHERE e.highwayNum = m.highwayNum 
  AND e.highwayNum = h.highwayNum 
  AND e.isExitOpen = TRUE
GROUP BY h.highwayNum, h.length;

-- a comment with the output of the query on the load data before the deletions
-- highwaynum | length | openmisdirectedexitcount
-- -----------+--------+--------------------------
--          1 |  150.3 |                        3
--          8 |   90.0 |                        4
--         13 |   45.5 |                       16
--         17 |  102.6 |                       12
--        280 |  200.9 |                        3
-- (5 rows)

-- the sql statements that delete Exits tuples whose Primary Key is
-- (17, 34), (280, 95) 
DELETE FROM Exits 
WHERE highwayNum = 17 
  AND exitNum = 34;

DELETE FROM Exits 
WHERE highwayNum = 280 
  AND exitNum = 95;

-- a second comment with the second output of the same query after the deletions
-- highwaynum | length | openmisdirectedexitcount
-- -----------+--------+--------------------------
--          1 |  150.3 |                        3
--          8 |   90.0 |                        4
--         13 |   45.5 |                       16
--         17 |  102.6 |                        6
--(4 rows)
