USE BourbonTasting

/*NCI with one key column*/
CREATE NONCLUSTERED INDEX IX_EventTime ON Events
(
	EventTime
)

/*NCI with 2 key columns*/
ALTER TABLE Events ADD Len_EventName as (len(EventName))
CREATE NONCLUSTERED INDEX IX_Event_Name_Length_Last_Name ON Events
(
	Len_EventName,
	EventName
)

/*NCI With one key column and one include column*/
CREATE NONCLUSTERED INDEX IX_Name_Sort ON Employees
(
	FirstName
)
INCLUDE
(
	LastName
)


/*Write a SELECT query that uses a WHERE clause*/
SELECT CompanyID
FROM Events
WHERE EventID = 1

/*Write a  SELECT query that uses an OR and an AND operator*/
SELECT FirstName, LastName
FROM Employees
WHERE FirstName = 'John' OR FirstName = 'Aften'

/*Write a  SELECT query that filters NULL rows using IS NOT NULL*/
SELECT *
FROM Employees
WHERE FirstName IS NOT NULL

/*Write a DML statement that UPDATEs a set of rows with a WHERE clause. The values used in the WHERE clause should be a variable*/
Declare @employeenumber int = 7
UPDATE Employees
SET FirstName = 'Shell', LastName = 'Rapier'
WHERE EmployeeID = @employeenumber

/*Write a DML statement that DELETEs a set of rows with a WHERE clause. The values used in the WHERE clause should be a variable*/
DECLARE @table_to_delete TABLE (
	eventnumber INT
)
INSERT INTO @table_to_delete
SELECT EventID
FROM EVENTS
WHERE CONVERT(Date, EventTime) < InquiryDate

DELETE
FROM EventsToEmployees
WHERE EventID IN (SELECT * FROM @table_to_delete)

DELETE
FROM Events
WHERE EventID IN (SELECT * FROM @table_to_delete)

/*Write a DML statement that DELETEs rows from a table that another table references. 
This script will have to also DELETE any records that reference these rows. 
Both of the DELETE statements need to be wrapped in a single TRANSACTION.*/
BEGIN TRANSACTION

DECLARE @table_to_delete2 TABLE (
	EventNumber INT
)

INSERT INTO @table_to_delete2
SELECT EventID
FROM EventsToEmployees
WHERE EmployeeID = 9

SELECT * FROM Employees WHERE EmployeeID = 9
SELECT * FROM @table_to_delete2

DELETE
FROM EventsToEmployees 
WHERE EventID IN (SELECT EventNumber FROM @table_to_delete2)

DELETE
FROM Events
WHERE EventID IN (SELECT EventNumber FROM @table_to_delete2)

DELETE 
FROM Employees 
WHERE EmployeeID = 9

COMMIT

/*Write a  SELECT query that utilizes a JOIN*/
SELECT TOP 50 CompanyName, EventName
FROM Events
JOIN Companies
ON Events.CompanyID = Companies.CompanyID


/*Write a  SELECT query that utilizes a JOIN with 3 or more tables*/
SELECT TOP 10 LastName, FirstName, EventName, CompanyName
FROM Events
JOIN Companies
ON Events.CompanyID = Companies.CompanyID
JOIN EventsToEmployees
ON Events.EventID = EventsToEmployees.EventID
JOIN Employees
ON EventstoEmployees.EmployeeID = Employees.EmployeeID
WHERE EventsToEmployees.EventID = 3 

/*Write a  SELECT query that utilizes a LEFT JOIN*/
SELECT MIN(CompanyName), COUNT(Events.CompanyID) as Quantity_Events
FROM Companies
LEFT JOIN Events
ON Companies.CompanyID = Events.CompanyID
GROUP BY Events.CompanyID

/*Write a  SELECT query that utilizes a variable in the WHERE clause*/
Declare @employee_events int = 1
SELECT EventName, EventTime
FROM Events
JOIN EventsToEmployees
ON Events.EventID = EventstoEmployees.EventID
JOIN Employees
ON EventstoEmployees.EmployeeID = Employees.EmployeeID
WHERE EventsToEmployees.EmployeeID = @employee_events

/*Write a  SELECT query that utilizes a ORDER BY clause*/
SELECT LastName, FirstName, EmployeeID
FROM Employees
ORDER BY LastName

/*Write a  SELECT query that utilizes a GROUP BY clause along with an aggregate function*/
SELECT MIN(LastName) AS LastName, MIN(FirstName) AS FirstName, COUNT(EventsToEmployees.EmployeeID) AS Num_Events
FROM Events
JOIN Companies
ON Events.CompanyID = Companies.CompanyID
JOIN EventsToEmployees
ON Events.EventID = EventsToEmployees.EventID
JOIN Employees
ON EventsToEmployees.EmployeeID = Employees.EmployeeID
GROUP BY EventsToEmployees.EmployeeID

/*Write a SELECT query that utilizes a CALCULATED FIELD*/
SELECT MIN(Employees.LastName) + ', ' + MIN(Employees.FirstName) AS EmployeeName, COUNT(EventsToEmployees.EmployeeID) as Num_Events
FROM Events
JOIN Companies
ON Events.CompanyID = Companies.CompanyID
JOIN EventsToEmployees
ON Events.EventID = EventsToEmployees.EventID
JOIN Employees
ON EventsToEmployees.EmployeeID = Employees.EmployeeID
GROUP BY EventsToEmployees.EmployeeID

/*Write a SELECT query that utilizes a SUBQUERY*/
SELECT (
	SELECT Employees.LastName + ', ' + Employees.FirstName) 
AS EmployeeList,
CONVERT(Date, Events.EventTime) AS Holiday_Date,
CompanyName
FROM Events
JOIN EventsToEmployees
ON Events.EventID = EventsToEmployees.EventID
JOIN Employees
ON EventsToEmployees.EmployeeID = Employees.EmployeeID
JOIN Companies 
ON Events.CompanyID = Companies.CompanyID
WHERE EventTime IN (
	SELECT EventTime 
	FROM Events 
	WHERE CONVERT(Date, EventTime) IN (
			'2019-12-25',
			'2019-07-01',
			'2019-01-01',
			'2020-11-28',
			'2020-12-15',
			'2020-07-01',
			'2020-01-01',
			'2020-11-26')
)


/*Write a SELECT query that utilizes a JOIN, at least 2 OPERATORS 
(AND, OR, =, IN, BETWEEN, ETC) AND A GROUP BY clause with an aggregate function*/
SELECT MIN(CompanyName), COUNT(EventID) 
FROM Companies
LEFT JOIN Events
ON Companies.CompanyID = Events.CompanyID
WHERE Companies.CompanyID NOT IN (SELECT CompanyID FROM Events)
OR CONVERT(Date, EventTime) < InquiryDate
GROUP BY EventID
ORDER BY COUNT(EventID) ASC

/*Write a SELECT query that utilizes a JOIN with 3 or more tables, at 2 OPERATORS (AND, OR, =, IN, BETWEEN, ETC), 
a GROUP BY clause with an aggregate function, and a HAVING clause, finished?*/
SELECT MIN(LastName) AS LastName, MIN(FirstName) AS FirstName, COUNT(EventsToEmployees.EmployeeID) AS Num_Events
FROM Events
JOIN EventsToEmployees
ON Events.EventID = EventsToEmployees.EventID
JOIN Employees
ON EventsToEmployees.EmployeeID = Employees.EmployeeID
JOIN Companies
ON Events.CompanyID = Companies.CompanyID
WHERE LEN(Companies.CompanyName) BETWEEN 5 AND 15
OR LEN(Events.EventName) < 5
GROUP BY EventsToEmployees.EmployeeID
HAVING MIN(LastName) = 'Locken'
OR MIN(FirstName) = 'Shell'
ORDER BY LastName


/*query which shows number of events for each company with > 1 event*/

SELECT Events.CompanyID, COUNT(Events.CompanyID) AS num_events, MIN(Companies.CompanyName) AS CompanyName   
FROM Events
JOIN Companies
ON Events.CompanyID = Companies.CompanyID
JOIN EventsToEmployees
ON Events.EventID = EventsToEmployees.EventID
JOIN Employees
ON EventsToEmployees.EmployeeID = Employees.EmployeeID
GROUP BY Events.CompanyID
HAVING COUNT(Events.CompanyID) > 1
ORDER BY num_events DESC


