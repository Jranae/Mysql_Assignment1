-- AIRBASE Database
-- Part 1a: Create Tables

CREATE DATABASE IF NOT EXISTS airbase;
USE airbase;

DROP TABLE IF EXISTS BOOKED;
DROP TABLE IF EXISTS FLIGHT;
DROP TABLE IF EXISTS PLANE;
DROP TABLE IF EXISTS CUSTOMER;

CREATE TABLE CUSTOMER (
    CID INT PRIMARY KEY,
    CName VARCHAR(50) NOT NULL,
    SSN CHAR(9) UNIQUE NOT NULL,
    DOB DATE NOT NULL,
    StandingDesc VARCHAR(250) NOT NULL
);

CREATE TABLE PLANE (
    PlaneID INT PRIMARY KEY,
    Model CHAR(10) NOT NULL,
    DOM DATE NOT NULL,
    Notes VARCHAR(250) NOT NULL
);

CREATE TABLE FLIGHT (
    FlightID INT PRIMARY KEY,
    PlaneID INT NOT NULL,
    DepTime DATETIME NOT NULL,
    ArrTime DATETIME NOT NULL,
    FlightStatus CHAR(1) NOT NULL,
    FOREIGN KEY (PlaneID) REFERENCES PLANE(PlaneID)
);

CREATE TABLE BOOKED (
    CID INT NOT NULL,
    FlightID INT NOT NULL,
    Cost DECIMAL(10,2) NOT NULL,
    DOP DATE NOT NULL,
    PRIMARY KEY (CID, FlightID),
    FOREIGN KEY (CID) REFERENCES CUSTOMER(CID),
    FOREIGN KEY (FlightID) REFERENCES FLIGHT(FlightID)
);

-- Part 1b: Queries

-- i. All planes
SELECT * FROM PLANE;

-- ii. Customers not born in 1980
SELECT CID, CName
FROM CUSTOMER
WHERE YEAR(DOB) <> 1980;

-- iii. Flights booked by Beth Adams
SELECT F.FlightID, F.PlaneID
FROM CUSTOMER C
JOIN BOOKED B ON C.CID = B.CID
JOIN FLIGHT F ON B.FlightID = F.FlightID
WHERE C.CName = 'Beth Adams';

-- iv. Customers who booked Airbus A350
SELECT DISTINCT C.CName
FROM CUSTOMER C
JOIN BOOKED B ON C.CID = B.CID
JOIN FLIGHT F ON B.FlightID = F.FlightID
JOIN PLANE P ON F.PlaneID = P.PlaneID
WHERE P.Model = 'AIRBUSA350';

-- v. Plane flights in October 2023 (include planes with none)
SELECT P.PlaneID, P.Model, F.FlightID
FROM PLANE P
LEFT JOIN FLIGHT F
  ON P.PlaneID = F.PlaneID
  AND F.DepTime BETWEEN '2023-10-01' AND '2023-10-31';


-- Lahmansbaseballdb
-- Part 2: Queries

USE lahmansbaseballdb;

-- i. Players born in Colombia
SELECT *
FROM people
WHERE birthCountry = 'Colombia';

-- ii. Salaries for pujolal01, 2010+
SELECT yearID, salary
FROM salaries
WHERE playerID = 'pujolal01'
  AND yearID >= 2010;

-- iii. Awards won by Hank Aaron
SELECT DISTINCT awardID
FROM awardsplayers
WHERE playerID = (
    SELECT playerID
    FROM people
    WHERE nameFirst = 'Hank' AND nameLast = 'Aaron'
);

-- iv. Players in 2015 with RBI
SELECT p.nameFirst, p.nameLast, b.RBI
FROM batting b
JOIN people p ON b.playerID = p.playerID
WHERE b.yearID = 2015
ORDER BY b.RBI DESC;

-- v. Hall of Fame inductees 2010+
SELECT p.nameFirst, p.nameLast, h.yearID
FROM halloffame h
JOIN people p ON h.playerID = p.playerID
WHERE h.inducted = 'Y'
  AND h.yearID >= 2010;
