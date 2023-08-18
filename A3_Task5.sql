/* Purpose: Create Function to Calculate Employee Age,
			Create View of Employee Age, Years Served in Database MovinOn_T6
Script Date: August 18, 2023
Developed by: Team 6
				Benjamin Pye
				Claudiu Terenche
				Karina De Vargas Pereira
*/

-- switch to the current database
use movinon_t6
;
go

----5. function for age
if OBJECT_ID('dbo.EmployeesAgeFN', 'Fn') is not null
	drop function dbo.EmployeesAgeFN
;
go

create function dbo.EmployeesAgeFN
(	
	@EmpID as int
)
returns int
as
	begin
		return
			(
			select
			Datediff(year, DOB, getdate()) as 'Age'
			from HumanResources.Employees
			where EmpID = @EmpID
			)
	end
;
go

--test
select concat_ws(', ', EmpLast, EmpFirst) as 'Name', dbo.EmployeesAgeFN(empID) as 'Age' , DOB
from HumanResources.employees
;
go


---- view for age and years of service
if OBJECT_ID('dbo.EmployeeAgeYoS', 'V') is not null
	drop view dbo.EmployeeAgeYoS
;
go

Create view dbo.EmployeeAgeYoS
as
select 
	concat_ws(', ', EmpLast, EmpFirst) as 'Name', 
	dbo.EmployeesAgeFN(EmpID) as 'Age',
	dbo.getEmployeeYearsServedFN(Startdate, EndDate) as 'Years Of Service'
from HumanResources.employees
;
go

-- test
select *
from dbo.EmployeeAgeYoS
;
go