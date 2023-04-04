--Script to populate the Highway Info schema for W23 CSE 180 Lab3

-- tgupta5=# \i load_lab3.sql 
-- COPY 6
-- COPY 26
-- COPY 6
-- COPY 14
-- COPY 11
-- COPY 12
-- COPY 11
-- COPY 9

-- Highways(highwayNum, length, speedLimit)
COPY Highways FROM stdin USING DELIMITERS '|';
17|102.6|55
1|150.3|40
280|200.9|70
55|150.0|45
13|45.5|35
8|90|43
\.

-- Exits(highwayNum, exitNum, description, mileMarker, exitCity, exitState, isExitOpen)
COPY Exits FROM stdin USING DELIMITERS '|';
17|1|Emerald City|78.5|Oz|CA|TRUE
8|34|Westchester County|67|Rochester|NY|FALSE
280|120|Jawa Camp|123.0|Dallas|TX|FALSE
17|34|Cater Lake|33|LA|CA|TRUE
8|43|Central Park Avenue|34|Yonkers|NY|TRUE
55|77|Jundland Wastes|124.3|Austin|TX|TRUE
13|1|Grenade|35|Santa Cruz|CA|FALSE
280|23|Hobbiton|0.0|Houston|TX|TRUE
13|17|Foster Rd|5.7|Medford|OR|FALSE
280|95|Merritt RD|91.5|Oklahoma|OK|TRUE
8|36|Mile Square Road|68|Albany|NY|FALSE
17|23|Hobbiton|98.6|The Shire|CA|TRUE
8|39|Sleepy Hollow|45|Philadelphia|PA|TRUE
280|112|Mos Eisley|88.7|Houston|TX|FALSE
17|35|Airport Way|4.5|Bend|OR|FALSE
280|125|Hext RD|37.3|Tulsa|OK|TRUE
13|2|Louis RD|45.5|San Diego|CA|TRUE
13|5|Cavot RD|41|Scottsdale|AZ|FALSE
1|1|Balley Hill Rd|44.6|LA|CA|TRUE
13|25|Central Weed|12|Santa Cruz|CA|TRUE
1|34|Henley hornbook|5.5|San Diego|CA|TRUE
13|14|Weigh Stn|22.2|Phoenix|AZ|TRUE
55|46|Oklahoma Welcome Center|123.0|Oklahoma|OK|FALSE
17|40|Sandy BLVD|1.0|Oregon City|OR|TRUE
13|22|Glisan St|8.5|Eugene|OR|TRUE
1|95|Glisan St|35|Portland|OR|TRUE
\.

-- Interchanges(highwayNum1, exitNum1, highwayNum2, exitNum2)
COPY Interchanges FROM stdin USING DELIMITERS '|';
1|1|17|1
55|46|280|112
13|17|17|23
13|25|55|77
17|40|280|120
1|95|8|43
\.

-- Cameras(cameraID, highwayNum, mileMarker, isCameraWorking)
COPY Cameras FROM stdin USING DELIMITERS '|';
901|1|0.0|TRUE
902|1|15.1|FALSE
903|1|150.3|TRUE
921|17|0.0|FALSE
927|17|98.6|FALSE
943|280|0.0|TRUE
945|280|88.7|TRUE
949|280|200.9|TRUE
951|55|50.5|FALSE
969|55|87.3|FALSE
856|13|10.0|FALSE
932|13|15.5|FALSE
960|13|25.0|FALSE
973|13|35.5|FALSE
\.


-- Owners(ownerState, ownerLicenseID, name, address, startDate, expirationDate)
COPY Owners FROM stdin USING DELIMITERS '|';
CA|N179244|\N|123 Main St|2018-01-09|2022-01-09
OR|N179244|Tom Johnson|333 Meder Dr|2011-03-21|\N
OR|P622557|Siobhan Roy|9931 El Camino|\N|\N
CA|T233186|Greg Hirsch|831 Santa Cruz Ave|2021-06-30|2024-03-15
CA|X482015|\N|123 Main St|2018-12-17|\N
OR|B385229|Gerri Kellman|222 Emmet Grade|2016-07-31|2023-06-02
WA|K569201|Stewart Rossellini|11 Private Dr|\N|\N
WA|B385226|Logan Schwartz|222 Emmet Grade|\N|\N
NJ|N179244|Gerri Kellman|101 W34 St|2020-11-11|2023-12-12
NC|B385226|Siobhan Roy|200 Melody Drive|2014-07-31|2022-04-12
NJ|P423554|Gerri Kellman|050 Silver Canoe Way|2017-01-31|\N
\.

-- Vehicles(vehicleState, vehicleLicensePlate, ownerState, ownerLicenseID, year, color) 
COPY Vehicles FROM stdin USING DELIMITERS '|';
CA|3XYZ123|CA|N179244|2020|RE
CA|7UVW177|OR|N179244|2019|GR
CA|3YHT835|OR|B385229|2014|BL
OR|3XYZ123|CA|T233186|2019|BK
CA|RELATIO|CA|X482015|2001|WH
CA|6KDD482|WA|B385226|2003|RE
OR|5PQR564|CA|X482015|2012|BK
OR|7UVW177|OR|B385229|2022|RE
NJ|3XYZ123|NJ|P423554|2023|BK
CA|1WES905|WA|B385226|2007|RE
CA|5PQR564|NJ|N179244|2023|RE
CA|5TMM623|WA|K569201|2006|RE
\.

-- Photos(cameraID, vehicleState, vehicleLicensePlate, photoTimestamp)
COPY Photos FROM stdin USING DELIMITERS '|';
901|CA|7UVW177|2022-12-01 16:20:01
902|CA|3YHT835|2022-12-01 17:42:35
903|CA|7UVW177|2022-12-01 07:00:30
927|CA|1WES905|2022-12-01 11:24:11
949|OR|7UVW177|2022-12-01 09:35:45
945|OR|7UVW177|2022-12-01 07:00:30
949|CA|RELATIO|2022-12-02 05:23:23
973|OR|3XYZ123|2022-12-02 07:00:30
856|NJ|3XYZ123|2022-12-02 10:42:21
856|CA|5PQR564|2021-08-21 15:19:00
951|CA|5PQR564|2023-01-02 13:46:33
\.

-- PhotoChanges(cameraID, vehicleLicensePlate, photoTimestamp) 
COPY PhotoChanges FROM stdin USING DELIMITERS '|';
901|7UVW456|2022-12-01 16:20:01
949|7OMN177|2022-12-01 09:35:45
949|BC18351|2022-12-02 05:23:23
856|RELATIO|2022-12-02 10:42:21
856|3BNQ123|2021-08-21 15:19:00
951|4ABC345|2023-01-02 13:46:33
856|3YHT835|2023-12-13 11:22:31
856|ATE3415|2020-04-18 23:00:01
951|5YDR805|2023-03-21 13:00:23
\.
