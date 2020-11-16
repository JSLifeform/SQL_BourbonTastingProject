DROP TABLE IF EXISTS EventsToEmployees, Events, Employees, Companies, Holidays

CREATE TABLE Holidays (
	HolidayName varchar(30),
	HolidayDate Date PRIMARY KEY
)

CREATE TABLE Employees (
	EmployeeID int IDENTITY(1,1) PRIMARY KEY,
	LastName varchar(30),
	FirstName varchar(30)
)

CREATE TABLE Companies (
	CompanyID int IDENTITY(1,1) PRIMARY KEY,
	CompanyName varchar(50),
	Phone varchar(25),
	Email varchar(50),
	PrimaryContact varchar(100)
)

CREATE TABLE Events (
	EventID INT IDENTITY(1,1) PRIMARY KEY,
	EventName varchar(100),
	CompanyID int FOREIGN KEY REFERENCES Companies(CompanyID),
	EventTime datetime,
	InquiryDate date
)

CREATE TABLE EventstoEmployees(
	EventID int FOREIGN KEY REFERENCES Events(EventID),
	EmployeeID int FOREIGN KEY REFERENCES Employees(EmployeeID)
	CONSTRAINT EventEmployeesID PRIMARY KEY (EventID, EmployeeID)
)
