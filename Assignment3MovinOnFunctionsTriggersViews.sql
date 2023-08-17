/* Purpose: Database MovinOn_T6
Script Date: August 18, 2023
Developed by: Team 6
				Benjamin Pye
				Claudiu Terenche
				Karina De Vargas Pereira
*/

-- switch to the current database
use movinon_t6;
go

--1. function for years of service -- finished
--2. View Isvested, Years Service -- finished
--3. trigger to verfiy phone # -- finished
--4. view of Emp salary's --finished
--5. funtion for age + view 1 & 7 -- finished
--6. view 'warehousemanagerReportLabels' contains,warehouseID, WarehouseManager, Mailing address, phone --
--7.view JobRevenueReport --finished
--8. view StorageRevenueReport 
--9. function rent length, add to num 8
--10. addition questions, functions in one view? FAQ





--1. function to calculate years of service
if OBJECT_ID('dbo.getEmployeeYearsServedFn', 'Fn') is not null
	drop function dbo.getEmployeeYearsServedFn
;
go

create function dbo.getEmployeeYearsServedFn
(
	-- define parameter list
	-- @parameter_name as data_type =[expression]
	@StartDate as datetime,
	@EndDate as datetime
)
-- returns data_type
returns int
as
	begin
		-- declare the return value
		-- declare @variable_name as data_type =[expression]
		declare @YearsServed as int

		-- compute the return value
		select @YearsServed = abs( 
		CASE
        when @EndDate IS NULL and @StartDate IS NOT NULL then DATEDIFF(YEAR, @StartDate, GETDATE()) 
        when @EndDate IS NOT NULL then DATEDIFF(YEAR, @StartDate, @EndDate)
		else NULL
		END)
			   		
		-- return the result to the function caller
		return @YearsServed
	end
;
go

select * from HumanResources.Employees;
go

--test
select EmpFirst, EmpLast, dbo.getEmployeeYearsServedFn(StartDate, EndDate) as 'Years Of Service'
from HumanResources.Employees
;
go


-- 2.
if OBJECT_ID('dbo.EmployeesStatusVestedView', 'V') is not null
	drop view dbo.EmployeesStatusVestedView
;
go

create view dbo.EmployeesStatusVestedView 
as select
	EmpID as 'Employee ID',
	CONCAT_WS(' ' , EmpFirst, EmpLast) as 'Employee Full Name', 
	IIF(EndDate IS NULL, 'Active', 'Inactive') as 'Employee Status',
	dbo.getEmployeeYearsServedFn(StartDate, EndDate) as 'Years Served',
	CASE
        when EndDate IS NULL AND StartDate IS NOT NULL AND (DATEDIFF(YEAR, StartDate, GETDATE()) >= 5) then 'Fully Vested'
        else 'Not Vested'
    END as 'Vesting Status'
from HumanResources.Employees
;
go

select *
from dbo.EmployeesStatusVestedView
order by 'Years Served' asc
;
go




--3. trigger to verfiy phone #
if OBJECT_ID('HumanResources.VerifyPhone', 'T') is not null
	drop trigger HumanResources.VerifyPhone
;
go

create trigger HumanResources.VerifyPhone
on HumanResources.Employees
for insert, update
as
	begin
		declare @phone as nvarChar, @cell as nvarchar, @state as char(2)
		select @phone = phone, @cell = cell, @state = state
		from inserted
		if (@state = 'OR')
			begin
				if LEFT(@Phone, 3) NOT IN ('541', '503', '971')
					begin
						print '***** phone area codes should be 541, 503, or 971 *****'
					end
			end
		if (@state = 'WA')
			begin
				if LEFT(@Phone, 3) NOT IN ('425', '360', '206', '509', '253')
					begin
						print '***** phone area codes should be 425, 360, 206, 509, or 253 *****'
					end
			end
		if (@state = 'WY')
			begin
				if LEFT(@Phone, 3) != '307'
					begin
						print '***** phone area codes should be 307 *****'
					end
			end
	end
;
go

--test
select 
	EmpID as 'Employee ID',
	CONCAT_WS(' ' , EmpFirst, EmpLast) as 'Employee Full Name', 
	Phone as 'Phone number',
	substring([Phone], 1, 3) as 'Area Code',
	Cell as 'Cell number',
	substring(Cell, 1, 3) as 'Area Code',
	state as 'State'
from HumanResources.Employees
;
go

update HumanResources.Employees
set phone = '111333999'		-- 5035742742
where phone = '5035742742'		-- 111333999
;
go

--4. view of Emp salary's
if OBJECT_ID('dbo.EmployeeSalariesV', 'V') is not null
	drop view dbo.EmployeeSalariesV
;
go

Create view dbo.EmployeeSalariesV
as select
    EmpID as 'Employee ID',
    CONCAT_WS(', ', EmpLast, EmpFirst) as 'Full Name',
    CASE
        WHEN salary is null THEN cast(HourlyRate * 2080 as decimal(14, 2))
        WHEN HourlyRate is null THEN cast(Salary as decimal(14,2))
    END AS 'Earnings'
FROM HumanResources.Employees
;
go

--test
select *
from dbo.EmployeeSalariesV
;
go


--5. function for age
if OBJECT_ID('dbo.EmployeesAge', 'Fn') is not null
	drop function dbo.EmployeesAge
;
go

create function dbo.EmployeesAge
(	
	@EmpID as int
)
returns int
as
	begin
		return
			(select  Datediff(year, DOB, getdate())
			from HumanResources.Employees
			where EmpID = @empID)
	end
;
go


select dbo.EmployeesAge(empID), DOB
from HumanResources.employees
;
go





-- view for age and years of service
Create view dbo.EmployeeAgeYoS
as
select concat_ws(', ', EmpLast, EmpFirst) as 'Name', dbo.EmployeesAge(EmpID) as 'Age', dbo.EmployeesYearService(EmpID) as 'Years Of Service'
from employees
;
go

-- test
select *
from dbo.EmployeeAgeYoS
;
go

----6. view 'warehousemanagerReportLabels' contains,warehouseID, WarehouseManager, Mailing address, phone
create view dbo.WarehouseMangerReportLabels
as select
	W.WarehouseID as 'Warehouse ID',
	concat_ws(', ', E.EmpLast, E.EmpFirst) as 'Warehouse Manager',
	concat_ws(', ', W.address, W.city, W.state, W.zip) as 'Address',
	W.Phone as 'Phone Number'
	from Warehouses as W
	Inner join employees as E
	on W.WarehouseID = E.WarehouseID
	group by E.PositionID, W.WarehouseID, E.EmpLast, E.EmpFirst, W.Address, W.city, W.state, W.ZIP, W.phone
	having E.PositionID = 2
;
go

-- test
select *
from dbo.WarehouseMangerReportLabels
;
go


--7.view JobvenueReport
create view dbo.JobRevenueReportV
as
SELECT
    JD.JobID as 'Job ID',
    JO.MoveDate as 'Date',
    CONCAT(DR.DriverFirst, ' ', DR.DriverLast) as 'Driver Name',
	DR.mileageRate as 'Driver Rate',
    JD.MileageActual as 'Mileage',
    JD.WeightActual as 'Weight',
    cast((JD.MileageActual * 0.7 + JD.WeightActual * 0.2)as decimal(14,2)) AS 'Income',
    cast((JD.MileageActual * 0.7 + JD.WeightActual * 0.2 - (50 + JD.MileageActual * DR.MileageRate)) as decimal(14,2)) AS 'NetIncome',
	cast((50 + (JD.MileageActual * DR.MileageRate))as decimal (14,2)) as 'Driver Pay'
FROM JobDetails JD
	INNER JOIN Drivers DR
	ON JD.DriverID = DR.DriverID
	INNER JOIN JobOrders as JO
	ON JD.JobID = JO.JobID

;
go

select *
from dbo.JobRevenueReportV
;
go

--8. view StorageRevenueReport
create function dbo.rentByWarehouse(@warehouseID as Char(5))
returns decimal (14,2)
as
	begin
	return
	(select sum(U.rent)
	from storageunits as U
	inner join unitrentals as UR
	on U.UnitID = UR.UnitID
	group by UR.WarehouseID
	having UR.WarehouseID = @warehouseID)
	end
;
go

create function dbo.TotalRentalIncome()
returns decimal (14,2)
as
	begin
	return
	(select sum(U.rent)
	from storageunits as U
	inner join unitrentals as UR
	on U.UnitID = UR.UnitID)
	end
;
go

create view dbo.StorageRevenueReportV
as select
	concat_ws(', ', C.ContactLast, C.ContactFirst) as 'Customer Name',
	R.rent as 'Monthly Rent',
	UR.UnitID as 'Unit',
	dbo.rentByWarehouse(UR.warehouseID) as 'Total rent for Warehouse',
	dbo.TotalRentalIncome() as 'Income from all Warehouses'
	from unitrentals as UR
	inner join customers as C
	On UR.CustID = C.CustID
	Inner join storageunits as R
	On UR.UnitID = R.UnitID
;
go

select * from dbo.StorageRevenueReportV;
go



--9. function rent length, add to num 8
alter function dbo.lengthOfRental(@UnitID as int)
returns int
as
	begin
	declare @month as int
		select @month =	dateDiff(month, DateIn, GetDate())
		from unitrentals
		where UnitID = @UnitID
		return @month
	end
;
go

select dbo.lengthOfRental(10);
go

alter view dbo.StorageRevenueReportV
as select
	concat_ws(', ', C.ContactLast, C.ContactFirst) as 'Customer Name',
	R.rent as 'Monthly Rent',
	UR.UnitID as 'Unit',
	dbo.lengthOfRental(UR.UnitID) as 'Months Rented',
	dbo.rentByWarehouse(UR.warehouseID) as 'Total rent for Warehouse',
	dbo.TotalRentalIncome() as 'Income from all Warehouses'
	from unitrentals as UR
	inner join customers as C
	On UR.CustID = C.CustID
	Inner join storageunits as R
	On UR.UnitID = R.UnitID
;
go

select * from dbo.StorageRevenueReportV;
go

--10. addition questions, functions in one view? FAQ
--10.1 How many storage units did the company do last year?
if OBJECT_ID('dbo.CountStorageUnitFN', 'Fn') is not null
	drop function dbo.CountStorageUnitFN
;
go

-- create a function that calculates how many storage units did the company rent in a given year 
create function dbo.CountStorageUnitFN (@Year int)
returns int
as
begin
    declare @StartDate date, @Count int;

    set @StartDate = DATEFROMPARTS(@Year, 1, 1);
   
    select @Count = COUNT(*)
    from Production.UnitRentals
    where YEAR(DateIn) = @Year;

    return @Count;
end
;
go

select dbo.CountStorageUnitFN(2016) as 'Number of Storage Units Rented in Given Year'
;
go


--10.2 What percentage of the customers rented at least one unit?
if OBJECT_ID('dbo.CalculateCustomerPercentageFn', 'Fn') is not null
	drop function dbo.CalculateCustomerPercentageFn
;
go

create function dbo.CalculateCustomerPercentageFn ()
returns decimal (5, 2)
as
BEGIN
    declare
	@TotalCustomers INT,
	@CustomersWithUnits INT, 
	@Percentage DECIMAL(5, 2);
    select @TotalCustomers = count(CustID)
	from Sales.Customers;
    select @CustomersWithUnits = COUNT(CustID)
    from Production.UnitRentals;
		select @Percentage = (@CustomersWithUnits * 100.0) / @TotalCustomers;
	return @Percentage;
end
;
go

select dbo.CalculateCustomerPercentageFn() as 'Percent Of Customers Renting'
;
go
-- 10.3 what was the greatest number of rents by any one indiviual?
select CustID, count(unitID) from unitrentals
group by CustID;
go

create function dbo.MostNumRented()
returns int
as
begin
declare @Highest as int
select @Highest = greatest(count(UnitID)) from unitrentals group by CustID
return @Highest
end
;
go

select dbo.MostNumRented() as 'Greatest Number of Rented Units by a customer'
;
go
-- 10.4 what is the average length of a rental period?

-- 10.5 what are the company peak months for rents?

--10.6 View of all FAQs

Create view FAQView
as
	Select
		dbo.CountStorageUnitFN() as 'How many storage units did the company do last year?',
		dbo.PercentOfCustomersRentingFN() as 'What percentage of the customers rented at least one unit?',
		dbo.MostNumRented() as 'What was the greatest number of rents by any one indiviual?'
;
go

--test
select *
from FAQView
;
go