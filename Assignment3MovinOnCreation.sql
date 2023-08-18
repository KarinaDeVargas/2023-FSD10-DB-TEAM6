/* Purpose: Creating database MovinOn_T6 in SQL Server, creating Tables and FK in database MovinOn_T6

Script Date: August 18, 2023
Developed by: Team 6
				Benjamin Pye
				Claudiu Terenche
				Karina De Vargas Pereira
*/

-- if MovingOn_T6 database exists, then delet it
drop database MovinOn_T6
;
go

-- create MovingOn_T6 database
create database MovinOn_T6
-- data file
on primary
(
	-- 1) rows data logical filename
	name = 'MovingOn_T6',
	-- 2) rows data initial file size 
	size = 12MB,
	-- 3) rows data auto growth size
	filegrowth = 8MB,
	-- 4) rows data maximum size
	maxsize = unlimited, -- 250MB
	-- 5) rows data path and file name
	filename = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\MovingOn_T6.mdf'
)
-- log file
log on
(
	-- 1) log logical filename
	name = 'MovingOn_T6_log',
	-- 2) log initial file size (1/4 the rows data file size)
	size = 3MB,
	-- 3) log auto growth size
	filegrowth = 10%,
	-- 4) log maximum size
	maxsize = 25MB,
	-- 5) log path and file name
	filename = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\MovingOn_T6_log.ldf'
)
;
go

-- switch to the current database 
use movinon_T6
;
go


/****** 1 - Customers table ******/
if OBJECT_ID('Customers', 'U') is not null
	drop table Sales.Customers
;
go

create table customers
(
	CustID int not null,
    CompanyName varchar(50) null,
    ContactFirst varchar(30) not null,
    ContactLast varchar(30) not null,
    Address varchar(40) not null,
    City varchar(30) not null,
    State char(2) not null,
    ZIP varchar(10) not null,
    Phone varchar(15),
    Balance decimal(19,4),
    constraint pk_customers primary key clustered (CustID asc)
)
;
go

/****** 2 - Employees table ******/
create table employees
(
	EmpID int not null,
    EmpFirst varchar(30) not null,
    EmpLast varchar(30) not null,
    WareHouseID char(5) not null,
    SSN char(9) not null,
    DOB datetime not null,
    StartDate datetime not null,
    EndDate datetime null,
    Address varchar(40) not null,
    city varchar(30) not null,
    state char(2) not null,
    ZIP varchar(10) not null,
    PositionID int not null,
    memo nvarchar(max) null,
    phone varchar(15) not null,
    cell varchar(15) not null,
    Salary decimal(19,4) null,
    hourlyRate decimal (19,4) null,
    review datetime null,
    constraint pk_employees primary key clustered (EmpID asc)
)	
;
go

/****** 3 - Position table ******/
create table positions
(
	positionID int not null,
    title varchar(30) not null,
    constraint pk_position primary key clustered (positionID asc)
)
;
go

/****** 4 - Drivers table ******/
create table drivers
(
	DriverID int not null,
    DriverFirst varchar(30) not null,
    DriverLast varchar(30) not null,
    SSN char(9) not null,
    DOB datetime not null,
    StartDate datetime not null,
    EndDate datetime not null,
    Address varchar(40) not null,
    city varchar(30) not null,
    state char(2) not null,
    ZIP varchar(10) not null,
	phone varchar(15) not null,
    cell varchar(15) not null,
    mileageRate decimal(19,4) not null,
    review datetime null,
    DrivingRecord char(1) not null,
    constraint pk_drivers primary key clustered (DriverID asc)
)
;
go

/****** 5 - Vehicle table ******/
Create table vehicles
(
	vehicleID char(7) not null,
    licensePlateNum varchar(7) not null,
    axle tinyint not null,
    color varchar(10),
    constraint Pk_vehicles primary key clustered (vehicleID asc)
)
;
go
  
/****** 6 - Warehouses table ******/
create table warehouses
(
	WarehouseID char(5) not null,
	Address varchar(40) not null,
    city varchar(30) not null,
    state char(2) not null,
    ZIP varchar(10) not null,
    phone varchar(15) not null,
    climateControl tinyint null,
    SecurityGate tinyint null,
    constraint pk_warehouse primary key clustered (warehouseID asc)
)
;
go

/****** 7 - StorageUnits table ******/
create table storageunits
(
	UnitID INT not null,
    warehouseID char(5) not null,
    unitsize varchar(10),
    rent decimal(19,4),
    constraint pk_storageunits primary key clustered (UnitID asc)
)
;
go

/****** 8 - UnitRentals table ******/
Create table unitrentals
(
	CustID int not null,
    WarehouseID char(5) not null,
    UnitID INT not null,
    DateIn Datetime not null,
    dateout datetime null,
    constraint pk_unitrentals primary key clustered
    (
		CustID asc,
        WarehouseID asc,
        UnitID asc
	)
)
;
go

/****** 9 - JobOrders table ******/
create table joborders
(
	JobID int not null,
    CustID int not null,
    MoveDate datetime not null,
    FromAddress varchar(40) not null,
    Fromcity varchar(30) not null,
    Fromstate char(2) not null,
    ToAddress varchar(40) not null,
    Tocity varchar(30) not null,
    Tostate char(2) not null,
    DistanceEst int null,
    WeightEst int null,
    packing tinyint null,
    heavy tinyint null,
    storage tinyint null,
    constraint pk_JobOrders primary key clustered (JobID asc)
)
;
go

/****** 10 - JobDetails table ******/
create table jobdetails
(
	JobID int not null,
    vehicleID char(7) not null,
    DriverID int not null,
    MileageActual int not null,
    WeightActual int not null,
    constraint pk_JobDetails primary key clustered (JobID asc)
)
;
go

/**** Apply Data Integrity ****/
-- Foreign key constraints UnitRentals Table
alter table unitrentals
	add constraint fk_UnitRentals_UnitID foreign key (UnitID) references StorageUnits (UnitID)
;
go

alter table unitrentals
	add constraint fk_UnitRentals_WarehouseID foreign key (WarehouseID) references warehouses (WarehouseID)
;
go

alter table unitrentals
	add constraint fk_UnitRentals_CustID foreign key (CustID) references Customers (CustID)
;
go

-- Foreign key constraints StorageUnits Table
alter table storageUnits
	add constraint fk_StorageUnits_warehouses foreign key (WarehouseID) references warehouses (warehouseID)
;
go

-- Foreign key constraints Employees Table
alter table employees
	add constraint fk_Employees_Warehouses foreign key (WarehouseID) references warehouses (warehouseID)
;
go	   	   	  

alter table employees
    add constraint fk_Employees_Positions foreign key (positionID) references positions (positionID)
;
go


-- Foreign key constraints JobOrders Table
alter table joborders
	add constraint fk_jobOrders_Customers foreign key (CustID) references customers (CustID)
;
go


-- Foreign key constraints Employees Table
alter table jobdetails
	add constraint fk_JobDetails_JobOrders foreign key (JobID) references JobOrders (JobID)
;
go

alter table jobdetails
    add constraint fk_JobDetails_Vehicles foreign key (vehicleID) references vehicles (vehicleID)
;
go

alter table jobdetails
    add constraint fk_JobDetails_Driver foreign key (DriverId) references Drivers (driverID)
;
go

