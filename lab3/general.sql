ALTER TABLE Exits
ADD CONSTRAINT mileMarkerNonNegative 
 CHECK (mileMarker >= 0);

ALTER TABLE Interchanges
ADD CONSTRAINT interchangeHighways 
 CHECK (highwayNum1 < highwayNum2);

ALTER TABLE Owners
ADD CONSTRAINT startNullExpirationNull
 CHECK ((startDate IS NULL AND expirationDate IS NULL) OR startDate IS NOT NULL);
 
 --CHECK (startDate IS NULL AND expirationDate IS NULL);
