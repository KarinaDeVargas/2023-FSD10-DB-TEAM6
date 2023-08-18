/* Purpose: Database MovinOn_T6
	Function to Calculate years of Service
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

----1. function to calculate years of service
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

--test
select * from HumanResources.Employees;
go

select EmpFirst, EmpLast, dbo.getEmployeeYearsServedFn(StartDate, EndDate) as 'Years Of Service'
from HumanResources.Employees
;
go