CREATE VIEW MisdirectedExitView AS
SELECT e1.highwayNum, e1.exitNum, e1.mileMarker, COUNT(*) AS misdirectedProverCount
FROM Exits e1, Exits e2
WHERE e1.highwayNum = e2.highwayNum 
  AND e1.exitNum < e2.exitNum 
  AND e1.mileMarker > e2.mileMarker 
GROUP BY e1.highwayNum, e1.exitNum, e1.mileMarker
HAVING COUNT(*) >= 2;
