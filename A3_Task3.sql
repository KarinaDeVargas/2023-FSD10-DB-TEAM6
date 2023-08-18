/* Purpose: Database MovinOn_T6
	Warning trigger for Phone Numbers
Script Date: August 18, 2023
Developed by: Team 6
				Benjamin Pye
				Claudiu Terenche
				Karina De Vargas Pereira
*/

-- switch to the current database
use movinon_t6;
go

--3. Warning Trigger for phone #
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
set phone = '111333999' 
where phone = '5035742742'
;
go