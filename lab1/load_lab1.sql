--Script to populate the Highway Info schema for W23 CSE 180 Lab1

-- Highways(highwayNum, length, speedLimit)
COPY Highways FROM stdin USING DELIMITERS '|';
17|98.6|55
1|150.3|40
280|200.9|65
\.

-- Exits(highwayNum, exitNum, description, mileMarker, exitCity, exitState, isExitOpen)
COPY Exits FROM stdin USING DELIMITERS '|';
17|1|Emerald Cit|0.0|Oz|CA|TRUE
17|23|Hobbiton|98.6|The Shire|CA|TRUE
1|1|Emerald City|0.0|Oz|CA|TRUE
1|98|Omatikaya|150.3|Pandora|CA|TRUE
280|1|Hobbiton|0.0|The Shire|CA|TRUE
280|25|Elrond's Home|88.7|Rivendell|CA|TRUE
280|34|Mos Eisley|100.5|Tattooine|OR|TRUE
280|46|Jawa Camp|123.0|Tattooine|OR|FALSE
280|95|Jundland Wastes|200.9|Tattooine|OR|TRUE
\.

-- Interchanges(highwayNum1, exitNum1, highwayNum2, exitNum2)
COPY Interchanges FROM stdin USING DELIMITERS '|';
1|1|17|1
17|23|280|1
\.

-- Cameras(cameraID, highwayNum, mileMarker, isCameraWorking)
COPY Cameras FROM stdin USING DELIMITERS '|';
901|1|0.0|TRUE
902|1|15.1|FALSE
903|1|150.3|TRUE
921|17|0.0|TRUE
927|17|98.6|FALSE
943|280|0.0|TRUE
945|280|88.7|TRUE
949|280|200.9|TRUE
\.


-- Owners(ownerState, ownerLicenseID, name, address, startDate, expirationDate)
COPY Owners FROM stdin USING DELIMITERS '|';
CA|N179244|Kendall Lee|123 Main St|2018-01-09|2022-01-09
OR|N179244|Tom Johnson|333 Meder Dr|2011-03-21|2023-04-21
OR|P622557|Siobhan Roy|9931 El Camino|2020-02-12|2022-12-16
CA|T233186|Greg Hirsch|831 Santa Cruz Ave|2021-06-30|2024-03-15
CA|X482015|Roman Chan|123 Main St|2018-12-17|2023-12-017
OR|B385229|Gerri Kellman|222 Emmet Grade|2016-07-31|2023-06-02
WA|K569201|Stewart Rossellini|11 Private Dr|2022-01-04|2022-12-28
WA|B385226|Logan Schwartz|101 W34 St|2018-05-16|2024-05-16
\.

-- Vehicles(vehicleState, vehicleLicensePlate, ownerState, ownerLicenseID, year, color) 
COPY Vehicles FROM stdin USING DELIMITERS '|';
CA|3XYZ123|OR|N179244|2020|RE
CA|7UVW177|OR|N179244|2021|BL
CA|3YHT835|OR|N179244|2014|GR
OR|3XYZ123|CA|T233186|2019|BK
CA|RELATIO|CA|X482015|2001|WH
CA|6KDD482|WA|B385226|2003|RE
\.

 
-- Photos(cameraID, vehicleState, vehicleLicensePlate, photoTimestamp)
COPY Photos FROM stdin USING DELIMITERS '|';
901|CA|7UVW177|2022-12-01 16:20:01
902|CA|7UVW177|2022-12-01 17:42:35
903|CA|7UVW177|2022-12-01 19:03:26
927|OR|3XYZ123|2022-12-02 08:00:53
927|CA|3XYZ123|2022-12-02 10:42:21
\.
