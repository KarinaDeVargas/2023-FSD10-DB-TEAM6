/* Purpose: Create View Of Unit Rental Revenue in Database MovinOn_T6	
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


----8. view StorageRevenueReport
if OBJECT_ID('dbo.rentByWarehouseFN', 'Fn') is not null
	drop function dbo.rentByWarehouseFN
;
go

create function dbo.rentByWarehouseFN(@warehouseID as Char(5))
returns decimal (14,2)
as
	begin
	return
	(
	select sum(U.rent)
		from Production.storageunits as U
			inner join Production.unitrentals as UR
				on U.UnitID = UR.UnitID
	group by UR.WarehouseID
	having UR.WarehouseID = @warehouseID
	)
	end
;
go

--test
select * 
from dbo.rentByWarehouseFN()
;
go

--Total Rental Income
if OBJECT_ID('dbo.TotalRentalIncomeFN', 'Fn') is not null
	drop function dbo.TotalRentalIncomeFN
;
go

create function dbo.TotalRentalIncomeFN()
returns decimal (14,2)
as
	begin
	return
	(
	select sum(U.rent)
	from Production.storageunits as U
		inner join Production.unitrentals as UR
	on U.UnitID = UR.UnitID
	)
	end
;
go


-- Storage Revenue Report
if OBJECT_ID('dbo.StorageRevenueReportV', 'V') is not null
	drop view dbo.StorageRevenueReportV
;
go

create view dbo.StorageRevenueReportV
as 
select
	concat_ws(', ', C.ContactLast, C.ContactFirst) as 'Customer Name',
	R.rent as 'Monthly Rent',
	UR.UnitID as 'Unit',
	dbo.rentByWarehouseFN(UR.warehouseID) as 'Total rent for Warehouse',
	dbo.TotalRentalIncomeFN() as 'Income from all Warehouses'
	from Production.unitrentals as UR
		inner join Sales.customers as C
			On UR.CustID = C.CustID
		Inner join Production.storageunits as R
			On UR.UnitID = R.UnitID
;
go

--test
select * 
from dbo.StorageRevenueReportV
;
go