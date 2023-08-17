

use movinon_t6;
go
;

--1. function for years of service -- finished
--2. View Isvested, Years Service -- finished
--3. trigger to verfiy phone # -- finished
--4. view of Emp salary's --finished
--5. funtion for age + view 1 & 7 -- finished
--6. view 'warehousemanagerReportLabels' contains,warehouseID, WarehouseManager, Mailing address, phone
--7.view JobRevenueReport --finished
--8. view StorageRevenueReport 
--9. function rent length, add to num 8
--10. addition questions, functions in one view? FAQ





--1. function to calculate years of service

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

select * from dbo.employees;
go

--test
select EmpFirst, EmpLast, dbo.getEmployeeYearsServedFn(StartDate, EndDate) as 'Years Of Service'
from Employees
;
go


-- 2.
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
from Employees
;
go

select *
from dbo.EmployeesStatusVestedView
order by 'Years Served' asc
;
go




--3. trigger to verfiy phone #
create trigger dbo.VerifyPhone
on Dbo.Employees
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
select * from employees;
go

update dbo.employees
set phone = '111333999'
where phone = '5035742742'
;
go

--4. view of Emp salary's
Create view dbo.EmployeeSalariesV
as select
    EmpID as 'Employee ID',
    CONCAT_WS(', ', EmpLast, EmpFirst) as 'Full Name',
    CASE
        WHEN salary is null THEN cast(HourlyRate * 2080 as decimal(14, 2))
        WHEN HourlyRate is null THEN cast(Salary as decimal(14,2))
    END AS 'Earnings'
FROM Employees
;
go

--test
select *
from dbo.EmployeeSalariesV
;
go


--5. funtion for age
create function dbo.EmployeesAge
(	
	@EmpID as int
)
returns int
as
	begin
		return
			(select  Datediff(year, DOB, getdate())
			from Employees
			where EmpID = @empID)
	end
;
go


select dbo.EmployeesAge(empID), DOB
from employees
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
create dbo.StorageRevenueReportV
as select
;
go


--9. function rent length, add to num 8


--10. addition questions, functions in one view? FAQ

--10.1 How many storage units did the company do last year?

create function dbo.CountStorageUnitFN ()
returns int
as
	begin
	declare @UnitCount as int

	select @UnitCount = count(UnitID)
	from dbo.StorageUnits

	return @unitCount
	end
;
go

/* As a View

create view dbo.FAQ1View
as select
	Count(UnitID) as 'Number of Units'
	from dbo.Storageunits
;
go
*/

select dbo.CountStorageUnitFN() as 'Number of Storage Units';
go

--Invalid object name 'dbo.StorageUnits'

--10.2 What percentage of the customers rented at least one unit?

alter function dbo.NumberOfCust()
returns int
as begin
declare @Cust as decimal(7,2)
	select @Cust = cast(count(CustID) as decimal(7,2))
	from customers
	Return @cust
	end
;
go

alter function dbo.NumberOfRentingCust()
returns int
as begin
declare @cust as decimal(7,2)
	select @cust = cast(count(custID) as decimal(7,2))
	from unitrentals
	return @cust
	end
;
go

alter function dbo.PercentOfCustomersRentingFN ()
returns decimal(7,2)
as
	begin
	declare @precentage as decimal(7,2)

	select @precentage = dbo.NumberOfRentingCust() / dbo.NumberOfCust()
	return @precentage
	end
;
go
	
select dbo.PercentOfCustomersRentingFN()
;
go

select dbo.NumberOfRentingCust(), dbo.NumberOfCust(), dbo.PercentOfCustomersRentingFN()
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

select *
from FAQView
;
go