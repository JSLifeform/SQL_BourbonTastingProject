IF NOT EXISTS 
   (
     SELECT name FROM master.dbo.sysdatabases 
     WHERE name = N'BourbonTasting'
    )
CREATE DATABASE [BourbonTasting]
GO

DROP TABLE IF EXISTS BourbonTasting.dbo.EventsToEmployees, BourbonTasting.dbo.Events, BourbonTasting.dbo.Employees, BourbonTasting.dbo.Companies

CREATE TABLE BourbonTasting.dbo.Employees (
	EmployeeID int IDENTITY(1,1) PRIMARY KEY,
	LastName varchar(30),
	FirstName varchar(30)
)

CREATE TABLE BourbonTasting.dbo.Companies (
	CompanyID int IDENTITY(1,1) PRIMARY KEY,
	CompanyName varchar(50),
	Phone varchar(25),
	Email varchar(50),
	PrimaryContact varchar(100)
)

CREATE TABLE BourbonTasting.dbo.Events (
	EventID INT IDENTITY(1,1) PRIMARY KEY,
	EventName varchar(100),
	CompanyID int FOREIGN KEY REFERENCES Companies(CompanyID),
	EventTime datetime,
	InquiryDate date
)

CREATE TABLE BourbonTasting.dbo.EventstoEmployees(
	EventID int FOREIGN KEY REFERENCES Events(EventID),
	EmployeeID int FOREIGN KEY REFERENCES Employees(EmployeeID)
	CONSTRAINT EventEmployeesID PRIMARY KEY (EventID, EmployeeID)
)
