/* Purpose: Database MovinOn_T6
	Add to Task 8, Length of time Rented
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


----9. function rent length, add to num 8 
if OBJECT_ID('dbo.lengthOfRentalFN', 'Fn') is not null
	drop function dbo.lengthOfRentalFN
;
go

Create function dbo.lengthOfRentalFN(@UnitID as int)
returns int
as
	begin
	declare @month as int
		select @month =	dateDiff(month, DateIn, GetDate())
		from Production.unitrentals
		where UnitID = @UnitID
		return @month
	end
;
go

select 
dbo.lengthOfRentalFN(10)
;
go


create view dbo.StorageRevenueReport02V
as select
	concat_ws(', ', C.ContactLast, C.ContactFirst) as 'Customer Name',
	R.rent as 'Monthly Rent',
	UR.UnitID as 'Unit',
	dbo.lengthOfRentalFN(UR.UnitID) as 'Months Rented',
	dbo.rentByWarehouseFN(UR.warehouseID) as 'Total rent for Warehouse',
	dbo.TotalRentalIncomeFN() as 'Income from all Warehouses'
	from production.unitrentals as UR
	inner join sales.customers as C
	On UR.CustID = C.CustID
	Inner join production.storageunits as R
	On UR.UnitID = R.UnitID
;
go

--test
select * from dbo.StorageRevenueReport02V
;
go