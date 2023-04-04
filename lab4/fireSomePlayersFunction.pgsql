CREATE OR REPLACE FUNCTION determineSpeedingViolationsAndFinesFunction(maxFineTotal INTEGER)
RETURNS INTEGER AS $$
DECLARE
    totalFines INTEGER := 0;
    ownerId RECORD;
    numSpeedingViolations INTEGER;
    calculatedFine INTEGER;
BEGIN
    IF maxFineTotal <= 0 THEN
        RETURN -1;
    END IF;

    FOR ownerId IN (SELECT ownerState, ownerLicenseID FROM Owners ORDER BY speedingViolations DESC, fine DESC)
    LOOP
        SELECT COUNT(*)
        INTO numSpeedingViolations
        FROM DistancesAndIntervalsForPhotos AS D, Highways AS H, Vehicles AS V
        WHERE D.highwayNum = H.highwayNum
          AND D.vehicleState = V.vehicleState
          AND D.vehicleLicensePlate = V.vehicleLicensePlate
          AND V.ownerState = ownerId.ownerState
          AND V.ownerLicenseID = ownerId.ownerLicenseID
          AND D.distBetweenCameraMileMarkers / D.photoIntervalInHours > H.speedLimit;

        IF numSpeedingViolations >= 3 THEN
            calculatedFine := numSpeedingViolations * 50;
        ELSIF numSpeedingViolations = 2 THEN
            calculatedFine := 40;
        ELSIF numSpeedingViolations = 1 THEN
            calculatedFine := 10;
        ELSE
            calculatedFine := 0;
        END IF;

        IF totalFines + calculatedFine <= maxFineTotal THEN
            totalFines := totalFines + calculatedFine;
            UPDATE Owners
            SET fine = calculatedFine
            WHERE ownerState = ownerId.ownerState
              AND ownerLicenseID = ownerId.ownerLicenseID;
        END IF;
    END LOOP;

    RETURN totalFines;
END;
$$ LANGUAGE plpgsql;
