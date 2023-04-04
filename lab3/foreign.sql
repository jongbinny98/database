ALTER TABLE Vehicles
ADD CONSTRAINT owner_constraint FOREIGN KEY (ownerState, ownerLicenseID)
REFERENCES Owners (ownerState, ownerLicenseID)
 ON DELETE RESTRICT
 ON UPDATE CASCADE;

ALTER TABLE Photos
ADD CONSTRAINT vehicles_constraint FOREIGN KEY (vehicleState, vehicleLicensePlate)
REFERENCES Vehicles(vehicleState, vehicleLicensePlate)
 ON DELETE CASCADE
 ON UPDATE SET NULL;

ALTER TABLE Photos
ADD CONSTRAINT camera_contraint FOREIGN KEY (cameraID)
REFERENCES Cameras (cameraID)
 ON DELETE CASCADE
 ON UPDATE RESTRICT;
