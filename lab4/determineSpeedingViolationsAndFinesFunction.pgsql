CREATE FUNCTION determineSpeedingViolationsAndFinesFunction(maxFineTotal INTEGER)
RETURNS INTEGER AS $$


    DECLARE
        ownerName             RECORD;
        numSpeedingViolations INTEGER;
        calculatedFine        INTEGER;
        totalFines INTEGER := 0;

    -- declare to iterate through owners
    DECLARE ownerCursor CURSOR FOR
        SELECT ownerState, ownerLicenseID
        FROM Owners
        ORDER BY speedingViolations DESC, fine DESC;

    BEGIN
        -- to check if input value is invalid
        IF maxFineTotal <= 0 THEN
            RETURN -1;
        END IF;

        -- open the cursor to fetch data from query
        OPEN ownerCursor;

        LOOP
            -- retrieves the next owner record from the ownerCursor and stores it in the ownerName variable, which is of type RECORD.
            FETCH ownerCursor INTO ownerName;

            -- when no more record to fetch
            EXIT WHEN NOT FOUND;

            SELECT COUNT(*) INTO numSpeedingViolations
            FROM Highways AS H, Vehicles AS V, DistancesAndIntervalsForPhotos AS D
            WHERE D.highwayNum = H.highwayNum
              AND D.vehicleState = V.vehicleState
              AND D.vehicleLicensePlate = V.vehicleLicensePlate
              AND D.distBetweenCameraMileMarkers / D.photoIntervalInHours > H.speedLimit
              AND V.ownerState = ownerName.ownerState
              AND V.ownerLicenseID = ownerName.ownerLicenseID;

            -- calculate fine based on the number of speeding violation 
            IF numSpeedingViolations >= 3 THEN
                calculatedFine := 50 * numSpeedingViolations;
            ELSIF numSpeedingViolations = 2 THEN
                calculatedFine := 40;
            ELSIF numSpeedingViolations = 1 THEN
                calculatedFine := 10;
            ELSE
                calculatedFine := 0;
            END IF;
            
            -- calculate the fine within the max fine total
            IF totalFines + calculatedFine <= maxFineTotal THEN
                totalFines := totalFines + calculatedFine;
                UPDATE Owners
                SET fine = calculatedFine
                WHERE ownerState = ownerName.ownerState
                  AND ownerLicenseID = ownerName.ownerLicenseID;
            END IF;
        END LOOP;

        CLOSE ownerCursor;

    RETURN totalFines;
END;

$$ LANGUAGE plpgsql;
