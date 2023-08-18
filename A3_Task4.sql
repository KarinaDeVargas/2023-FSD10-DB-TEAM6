/* Purpose: Database MovinOn_T6
	View of Employee Salaries
Script Date: August 18, 2023
Developed by: Team 6
				Benjamin Pye
				Claudiu Terenche
				Karina De Vargas Pereira
*/

-- switch to the current database
use movinon_t6;
go

----4. view of Emp salary's
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