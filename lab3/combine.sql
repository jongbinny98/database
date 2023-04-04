BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

INSERT INTO Photos (cameraID, vehicleState, vehicleLicensePlate, photoTimestamp)
SELECT P.cameraID, NULL, P.vehicleLicensePlate, P.photoTimestamp
FROM PhotoChanges P
WHERE NOT EXISTS (
        SELECT *
        FROM Photos p1
        WHERE p1.cameraID = P.cameraID 
	  AND p1.photoTimestamp = P.photoTimestamp
);
    
UPDATE Photos
SET vehicleLicensePlate = P.vehicleLicensePlate, vehicleState = 'CA'
FROM PhotoChanges P
WHERE Photos.cameraID = P.cameraID 
  AND Photos.photoTimestamp = P.photoTimestamp;
    
COMMIT TRANSACTION;

