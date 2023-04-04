-- CSE 180 Winter 2023 Lab3 create which you should not modify

-- The following two lines are not needed, but they're useful.
DROP SCHEMA Lab3 CASCADE;
CREATE SCHEMA Lab3;


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
    PRIMARY KEY (vehicleState, vehicleLicensePlate)
);

CREATE TABLE Photos (
    cameraID INT,
    vehicleState CHAR(2),
    vehicleLicensePlate Char(7),
    photoTimestamp TIMESTAMP,
    PRIMARY KEY (cameraID, photoTimestamp)
);


CREATE TABLE PhotoChanges (
    cameraID INT,
    vehicleLicensePlate Char(7),
    photoTimestamp TIMESTAMP,
    PRIMARY KEY (cameraID, photoTimestamp)
);