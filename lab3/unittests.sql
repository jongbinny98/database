--2.3 for each condition
INSERT INTO Vehicles
 VALUES('NY','3XYZ123','CA','N179784',2020,'RE');

INSERT INTO Photos
 VALUES(901,'NY','7XYZ177','2022-12-01 16:20:01');

INSERT INTO Photos
 VALUES(970, 'CA', '7UVW177', '2022-12-01 16:20:01');

--1. 
--unittest for general contraint
UPDATE Exits 
SET mileMarker = 11 
WHERE highwayNum = 17 AND exitNum = 1;

--violates the contraint
UPDATE Exits 
SET mileMarker = -1 
WHERE highwayNum = 8 AND exitNum = 34;

--2. 
--unittest for general contraint
UPDATE Interchanges 
SET highwayNum1 = 8, exitNum1 = 34, highwayNum2 = 280, exitNum2= 120 
WHERE highwayNum1 = 1 AND exitNum1 = 1
  AND highwayNum2 = 17 AND exitNum2 = 1;

--violates the contraint 
UPDATE Interchanges 
SET highwayNum1 = 55, exitNum1 = 77, highwayNum2 = 17, exitNum2 = 1 
WHERE highwayNum1 = 55 AND exitNum1 = 46
  AND highwayNum2 = 280 AND exitNum2 = 112;

--3.
--unittest for general contraint
UPDATE Owners 
SET expirationDate = NULL 
WHERE startDate IS NULL;

--violates the contraint 
UPDATE Owners 
SET expirationDate = '2023-02-28' 
WHERE startDate IS NULL;


