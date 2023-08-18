/* Purpose: Create View Of Employees, Active/InActive, Years Served, Vested/NotVested in Database MovinOn_T6
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

-- 2.
if OBJECT_ID('dbo.EmployeesStatusVestedV', 'V') is not null
	drop view dbo.EmployeesStatusVestedV
;
go

create view dbo.EmployeesStatusVestedV 
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

--test
select *
from dbo.EmployeesStatusVestedV
order by 'Years Served' asc
;
go