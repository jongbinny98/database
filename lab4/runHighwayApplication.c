/**
 * runHighwayApplication skeleton, to be modified by students
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include "libpq-fe.h"

/* These constants would normally be in a header file */
/* Maximum length of string used to submit a connection */
#define MAXCONNECTIONSTRINGSIZE 501
/* Maximum length of string used to submit a SQL statement */
#define MAXSQLSTATEMENTSTRINGSIZE 2001
/* Maximum length of string version of integer; you don't have to use a value this big */
#define  MAXNUMBERSTRINGSIZE        20


/* Exit with success after closing connection to the server
 *  and freeing memory that was used by the PGconn object.
 */
static void good_exit(PGconn *conn)
{
    PQfinish(conn);
    exit(EXIT_SUCCESS);
}

/* Exit with failure after closing connection to the server
 *  and freeing memory that was used by the PGconn object.
 */
static void bad_exit(PGconn *conn)
{
    PQfinish(conn);
    exit(EXIT_FAILURE);
}

/* The three C functions that for Lab4 should appear below.
 * Write those functions, as described in Lab4 Section 4 (and Section 5,
 * which describes the Stored Function used by the third C function).
 *
 * Write the tests of those function in main, as described in Section 6
 * of Lab4.
 *
 * You may use "helper" functions to avoid having to duplicate calls and
 * printing, if you'd like, but if Lab4 says do things in a function, do them
 * in that function, and if Lab4 says do things in main, do them in main,
 * possibly using a helper function, if you'd like.
 */

/* Function: printCameraPhotoCount:
 * -------------------------------------
 * Parameters:  connection, and theCameraID, which should be the ID of a camera.
 * Prints the cameraID, the highwayNum and mileMarker of that camera, and the
 * number of number of photos for that camera, if camera exists for thecameraID.
 * Return 0 if normal execution, -1 if no such camera.
 * bad_exit if SQL statement execution fails.
 */

int printCameraPhotoCount(PGconn *conn, int theCameraID) {

    /* to check if the database connection is OK */
    if (PQstatus(conn) != CONNECTION_OK)
    {
        fprintf(stderr, "Connection to database failed: %s\n", PQerrorMessage(conn));
        bad_exit(conn);
    }

    char command[MAXSQLSTATEMENTSTRINGSIZE];
    PGresult *res;

    /* Start a single serializable transaction */
    sprintf(command, "BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;");
    res = PQexec(conn, command);
    if (PQresultStatus(res) != PGRES_COMMAND_OK) {
        fprintf(stderr, "BEGIN command failed: %s\n", PQerrorMessage(conn));
        PQclear(res);
        return -1;
    }
    PQclear(res);

    /* Check if camera with theCameraID exists */
    sprintf(command, "SELECT C.cameraID, C.highwayNum, C.mileMarker FROM Cameras AS C WHERE C.cameraID = %d;", theCameraID);
    res = PQexec(conn, command);
    if (PQresultStatus(res) != PGRES_TUPLES_OK || PQntuples(res) == 0) {
        /* No camera found */
        PQclear(res);
        PQexec(conn, "No camera found.\n");
        return -1;
    }

    /* Get camera information and photo count */
    char* cameraID = PQgetvalue(res, 0, 0);
    char* highwayNum = PQgetvalue(res, 0, 1);
    char* mileMarker = PQgetvalue(res, 0, 2);
    PQclear(res);

    sprintf(command, "SELECT COUNT(*) FROM Photos WHERE cameraID = %d;", theCameraID);
    res = PQexec(conn, command);
    if (PQresultStatus(res) != PGRES_TUPLES_OK || PQntuples(res) == 0) {
        /* Error when retrieving photo count */
        PQclear(res);
        PQexec(conn, "Error retrieving photo count.\n");
        return -1;
    }
    char* photoCount = PQgetvalue(res, 0, 0);
    PQclear(res);

    /* Print camera information and photo count */
    printf("Camera %s, on %s at %s has taken %s photos.\n", cameraID, highwayNum, mileMarker, photoCount);

    /* Commit transaction */
    sprintf(command, "COMMIT;");
    res = PQexec(conn, command);
    if (PQresultStatus(res) != PGRES_COMMAND_OK) {
        fprintf(stderr, "COMMIT command failed: %s\n", PQerrorMessage(conn));
        PQclear(res);
        return -1;
    }
    PQclear(res);

    return 0;
}

/* Function: openAllExits:
 * ----------------------------
 * Parameters:  connection, and theHighwayNum, the number of a highway.
 
 * Opens all the exit on that highway that weren't already open.
 * Returns the number of exits on the highway that weren't open,
 * or -1 if there is no highway whose highwayNum is theHighwayNum.
 */

int openAllExits(PGconn *conn, int theHighwayNum) {
    /* to check if the database connection is OK */
    if (PQstatus(conn) != CONNECTION_OK)
    {
        fprintf(stderr, "Connection to database failed: %s\n", PQerrorMessage(conn));
        bad_exit(conn);
    }
    char command[MAXSQLSTATEMENTSTRINGSIZE];
    PGresult *res;

    // /* Start a single serializable transaction */
    // sprintf(command, "BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;");
    // res = PQexec(conn, command);
    // if (PQresultStatus(res) != PGRES_COMMAND_OK) {
    //     fprintf(stderr, "BEGIN failed: %s\n", PQerrorMessage(conn));
    //     PQclear(res);
    //     return -1;
    // }
    // PQclear(res);

    /* to check if highway with theHighwayNum exists */
    sprintf(command, "SELECT H.highwayNum FROM Highways AS H WHERE H.highwayNum = %d;", theHighwayNum);
    res = PQexec(conn, command);
    if (PQresultStatus(res) != PGRES_TUPLES_OK || PQntuples(res) == 0) {
        /* No highway found */
        PQclear(res);
        PQexec(conn, "ROLLBACK;");
        return -1;
    }
    PQclear(res);

    /* Check if there are any exits on theHighwayNum */
    sprintf(command, "SELECT E.exitNum FROM Exits AS E WHERE E.highwayNum = %d;", theHighwayNum);
    res = PQexec(conn, command);
    if (PQresultStatus(res) != PGRES_TUPLES_OK) {
        /* Error when retrieving exits */
        PQclear(res);
        PQexec(conn, "ROLLBACK;");
        return -1;
    }
    int numExits = PQntuples(res);
    PQclear(res);

    if (numExits == 0) {
        /* openAllExits should return 0, since no isExitOpen values were updated.No exits found on highway */ 
        return 0;
    }

    /* Get the number of updated exits */
    sprintf(command, "SELECT COUNT(*) FROM Exits WHERE highwayNum = %d AND isExitOpen = False;", theHighwayNum);
    res = PQexec(conn, command);
    if (PQresultStatus(res) != PGRES_TUPLES_OK || PQntuples(res) == 0) {
        /* Error when retrieving updated exit count */
        PQclear(res);
        PQexec(conn, "ROLLBACK;");
        return -1;
    }
    // int updatedExitCount1 = atoi(PQgetvalue(res, 0, 0));
    int updatedExitCount = atoi(PQgetvalue(res, 0, 0));

    PQclear(res);

    /* Update exits on theHighwayNum that aren't open */
    sprintf(command, "UPDATE Exits SET isExitOpen = TRUE WHERE highwayNum = %d AND isExitOpen IS NOT TRUE;", theHighwayNum);
    res = PQexec(conn, command);
    if (PQresultStatus(res) != PGRES_COMMAND_OK) {
        fprintf(stderr, "UPDATE failed: %s\n", PQerrorMessage(conn));
        PQclear(res);
        PQexec(conn, "ROLLBACK;");
        return -1;
    }
    PQclear(res);

    // /* Commit transaction */
    // sprintf(command, "COMMIT;");
    // res = PQexec(conn, command);
    // if (PQresultStatus(res) != PGRES_COMMAND_OK) {
    //     fprintf(stderr, "COMMIT failed: %s \n", PQerrorMessage(conn));
    //     PQclear(res);
    //     return -1;
    // }
    // PQclear(res);

    return updatedExitCount;
}

/* Function: determineSpeedingViolationsAndFines:
 * -------------------------------
 * Parameters:  connection, and an integer maxFineTotal, the maximum total
 * of the fines that should be assessed to owners whose vehicles were speeding.
 *
 * It should count the number of speeding violations by vehicles that each owner
 * owns, and set the speedingViolations field of Owners accordingly.
 *
 * It should also assess fines to some owners based on the number of speeding
 * violations they have.
 *
 * Executes by invoking a Stored Function,
 * determineSpeedingViolationsAndFinesFunction, which does all of the work,
 * as described in Section 5 of Lab4.
 *
 * Returns a negative value if there is an error, and otherwise returns the total
 * fines that were assessed by the Stored Function.
 */

int determineSpeedingViolationsAndFines(PGconn *conn, int maxFineTotal)
{
    /* to check if the database connection is OK */
    if (PQstatus(conn) != CONNECTION_OK)
    {
        fprintf(stderr, "Connection to database failed: %s\n", PQerrorMessage(conn));
        bad_exit(conn);
    }
    
    char command[MAXSQLSTATEMENTSTRINGSIZE];
    PGresult *res;
    
    sprintf(command, "SELECT determineSpeedingViolationsAndFinesFunction(%d);", maxFineTotal);
    /* to execute the stored function called determineSpeedingViolationsAndFinesFunction.pqsql*/
    res = PQexec(conn, command); 

    // Check for errors
    if (PQresultStatus(res) != PGRES_TUPLES_OK) {
        fprintf(stderr, "Error executing determineSpeedingViolationsAndFinesFunction: %s", PQerrorMessage(conn));
        PQclear(res);
        return -1;
    }

    // Retrieve the result as an integer
    int totalFine = atoi(PQgetvalue(res, 0, 0));

    // Free the result and return the integer result
    PQclear(res);
    return totalFine;
}

int main(int argc, char **argv)
{
    PGconn *conn;
    int theResult;

    if (argc != 3)
    {
        fprintf(stderr, "Usage: ./runHighwayApplication <username> <password>\n");
        exit(EXIT_FAILURE);
    }

    char *userID = argv[1];
    char *pwd = argv[2];

    char conninfo[MAXCONNECTIONSTRINGSIZE] = "host=cse180-db.lt.ucsc.edu user=";
    strcat(conninfo, userID);
    strcat(conninfo, " password=");
    strcat(conninfo, pwd);

    /* Make a connection to the database */
    conn = PQconnectdb(conninfo);

    /* Check to see if the database connection was successfully made. */
    if (PQstatus(conn) != CONNECTION_OK)
    {
        fprintf(stderr, "Connection to database failed: %s\n",
                PQerrorMessage(conn));
        bad_exit(conn);
    }
   
    /* Perform the calls to printCameraPhotoCount listed in Section 6 of Lab4,
     * printing error message if there's an error.
     */
    int theCameraID;
    int result;

    theCameraID = 951;
    result = printCameraPhotoCount(conn, theCameraID);
    switch(result) {
        case 0:
            break;
        case -1:
            printf("No camera exists whose id is %d\n", theCameraID);
            break;
        default:
            printf("Unknown Error from the function printNumberOfThingsInRoom with theCameraID %d\n", theCameraID);
            bad_exit(conn);
            break;
    }

    theCameraID = 960;
    result = printCameraPhotoCount(conn, theCameraID);
    switch(result) {
        case 0:
            break;
        case -1:
            printf("No camera exists whose id is %d\n", theCameraID);
            break;
        default:
            printf("Unknown Error from the function printNumberOfThingsInRoom with theCameraID %d\n", theCameraID);
            bad_exit(conn);
            break;
    }

    theCameraID = 856;
    result = printCameraPhotoCount(conn, theCameraID);
    switch(result) {
        case 0:
            break;
        case -1:
            printf("No camera exists whose id is %d\n", theCameraID);
            break;
        default:
            printf("Unknown Error from the function printNumberOfThingsInRoom with theCameraID %d\n", theCameraID);
            bad_exit(conn);
            break;
    }

    theCameraID = 904;
    result = printCameraPhotoCount(conn, theCameraID);
    switch(result) {
        case 0:
            break;
        case -1:
            printf("No camera exists whose id is %d\n", theCameraID);
            break;
        default:
            printf("Unknown Error from the function printNumberOfThingsInRoom with theCameraID %d\n", theCameraID);
            bad_exit(conn);
            break;
    }

    /* Extra newline for readability */
    printf("\n");

    /* Perform the calls to openAllExits listed in Section 6 of Lab4,
     * and print messages as described.
    */
    int theHighwayNum = 101;
    int numExits = openAllExits(conn, theHighwayNum);
    if (numExits >= 0) {
        printf("%d exits were opened by openAllExits\n", numExits);
    } 
    else if (numExits == -1) {
        printf("There is no highway whose number is %d\n", theHighwayNum);
    } 
    else {
        printf("Error: unexpected value returned by openAllExits for highway %d: %d\n", theHighwayNum, numExits);
        bad_exit(conn);
    }

    theHighwayNum = 13;
    numExits = openAllExits(conn, theHighwayNum);
    if (numExits >= 0) {
        printf("%d exits were opened by openAllExits\n", numExits);
    } 
    else if (numExits == -1) {
        printf("There is no highway whose number is %d\n", theHighwayNum);
    } 
    else {
        printf("Error: unexpected value returned by openAllExits for highway %d: %d\n", theHighwayNum, numExits);
        bad_exit(conn);
    }

    theHighwayNum = 280;
    numExits = openAllExits(conn, theHighwayNum);
    if (numExits >= 0) {
        printf("%d exits were opened by openAllExits\n", numExits);
    } 
    else if (numExits == -1) {
        printf("There is no highway whose number is %d\n", theHighwayNum);
    } 
    else {
        printf("Error: unexpected value returned by openAllExits for highway %d: %d\n", theHighwayNum, numExits);
        bad_exit(conn);
    }

    theHighwayNum = 17;
    numExits = openAllExits(conn, theHighwayNum);
    if (numExits >= 0) {
        printf("%d exits were opened by openAllExits\n", numExits);
    } 
    else if (numExits == -1) {
        printf("There is no highway whose number is %d\n", theHighwayNum);
    } 
    else {
        printf("Error: unexpected value returned by openAllExits for highway %d: %d\n", theHighwayNum, numExits);
        bad_exit(conn);
    }

    /* Extra newline for readability */
    printf("\n");
    
    /* Perform the calls to determineSpeedingViolationsAndFines listed in Section
     * 6 of Lab4, and print messages as described.
     * You may use helper functions to do this, if you want.
    */

    int maxFineTotal = 300;
    int totalFine =  determineSpeedingViolationsAndFines(conn, maxFineTotal);
    if (totalFine >= 0) {
        printf("Total fines for maxFineTotal %d is %d\n", maxFineTotal, totalFine);
    } else {
        printf("Error: Invalid maxFineTotal value (%d)\n", maxFineTotal);
        bad_exit(conn);
    }

    maxFineTotal = 240;
    totalFine =  determineSpeedingViolationsAndFines(conn, maxFineTotal);
    if (totalFine >= 0) {
        printf("Total fines for maxFineTotal %d is %d\n", maxFineTotal, totalFine);
    } else {
        printf("Error: Invalid maxFineTotal value (%d)\n", maxFineTotal);
        bad_exit(conn);
    }

    maxFineTotal = 210;
    totalFine =  determineSpeedingViolationsAndFines(conn, maxFineTotal);
    if (totalFine >= 0) {
        printf("Total fines for maxFineTotal %d is %d\n", maxFineTotal, totalFine);
    } else {
        printf("Error: Invalid maxFineTotal value (%d)\n", maxFineTotal);
        bad_exit(conn);
    }

    maxFineTotal = 165;
    totalFine =  determineSpeedingViolationsAndFines(conn, maxFineTotal);
    if (totalFine >= 0) {
        printf("Total fines for maxFineTotal %d is %d\n", maxFineTotal, totalFine);
    } else {
        printf("Error: Invalid maxFineTotal value (%d)\n", maxFineTotal);
        bad_exit(conn);
    }

    good_exit(conn);
    return 0;
}
