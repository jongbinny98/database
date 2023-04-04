-- CSE 180 Winter 2023 Lab1 Solution

-- The following two lines are not needed in your solution, but they're useful.
DROP SCHEMA Lab1 CASCADE;
CREATE SCHEMA Lab1;

-- The comments that appear below are not needed in your solution.


-- Specific spacing doesn't matter.

-- INT is equivalent to INTEGER.
-- DECIMAL is equivalent to NUMERIC.
-- CHAR is equivalent to CHARACTER.
-- BOOL is equivalent to BOOLEAN.

-- Primary Keys that have a single attribute can have PRIMARY KEY appearing next to that attribute,
-- instead of as a Schema Element.  Must use a Schema Element when Primary Key is multiple attributes.

-- Foreign Keys that have a single attribute can have REFERENCES next to that attribute, instead of
-- specifying the Foreign Key as a Schema Element.  Must use a Schema Element when Foreign Key is multiple
-- attributes.

-- When all attributes of Foreign Key are identical to all attributes of the referenced Primary Key, don't need
-- to specify attributes of the Primary Key (but you can).  For example, in Vehicles could write either:
--                  FOREIGN KEY (ownerState, ownerLicenseID) REFERENCES Owners,         or
--                  FOREIGN KEY (ownerState, ownerLicenseID) REFERENCES Owners (ownerState, ownerLicenseID),



CREATE TABLE Highways (
    highwayNum INT,
    length NUMERIC(4,1),
    speedLimit INT,
    PRIMARY KEY (highwayNum)
);

CREATE TABLE Exits (
    highwayNum INT REFERENCES Highways,
    exitNum INT,
    description VARCHAR(60),
    mileMarker NUMERIC(4,1),
    exitCity VARCHAR(20),
    exitState CHAR(2),
    isExitOpen BOOL,
    PRIMARY KEY (highwayNum, exitNum)
);

CREATE TABLE Interchanges (
    highwayNum1 INT,
    exitNum1 INT,
    highwayNum2 INT,
    exitNum2 INT,
    FOREIGN KEY (highwayNum1, exitNum1) REFERENCES Exits(highwayNum, exitNum),
    FOREIGN KEY (highwayNum2, exitNum2) REFERENCES Exits(highwayNum, exitNum),
    PRIMARY KEY (highwayNum1, exitNum1, highwayNum2, exitNum2)
);

CREATE TABLE Cameras (
    cameraID INT,
    highwayNum INT REFERENCES Highways(highwayNum),
    mileMarker NUMERIC(4,1),
    isCameraWorking BOOL,
    PRIMARY KEY (cameraID)
);

CREATE TABLE Owners (
    ownerState CHAR(2),
    ownerLicenseID CHAR(8),
    name VARCHAR(60),
    address VARCHAR(60),
    startDate DATE,
    expirationDate DATE,
    PRIMARY KEY (ownerState, ownerLicenseID)
);

CREATE TABLE Vehicles (
    vehicleState CHAR(2),
    vehicleLicensePlate CHAR(7),
    ownerState CHAR(2),
    ownerLicenseID CHAR(8),
    year INT,
    color CHAR(2),
    FOREIGN KEY (ownerState, ownerLicenseID) REFERENCES Owners,
    PRIMARY KEY (vehicleState, vehicleLicensePlate)
);

CREATE TABLE Photos (
    cameraID INT REFERENCES Cameras,
    vehicleState CHAR(2),
    vehicleLicensePlate Char(7),
    photoTimestamp TIMESTAMP,
    FOREIGN KEY (vehicleState, vehicleLicensePlate) REFERENCES Vehicles,
    PRIMARY KEY (cameraID, photoTimestamp)
);