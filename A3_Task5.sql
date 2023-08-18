/* Purpose: Database MovinOn_T6
	Function to Calculate Employee Age,
	View of Employee Age, Years Served
Script Date: August 18, 2023
Developed by: Team 6
				Benjamin Pye
				Claudiu Terenche
				Karina De Vargas Pereira
*/

-- switch to the current database
use movinon_t6;
go

----5. function for age
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

--test
select dbo.EmployeesAge(empID), DOB
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
select concat_ws(', ', EmpLast, EmpFirst) as 'Name', dbo.EmployeesAge(EmpID) as 'Age', dbo.getEmployeeYearsServedFn(Startdate, EndDate) as 'Years Of Service'
from HumanResources.employees
;
go

-- test
select *
from dbo.EmployeeAgeYoS
;
go