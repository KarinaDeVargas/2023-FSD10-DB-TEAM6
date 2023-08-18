/* Purpose: Database MovinOn_T6
	View Of Unit Rental Revenue
Script Date: August 18, 2023
Developed by: Team 6
				Benjamin Pye
				Claudiu Terenche
				Karina De Vargas Pereira
*/

-- switch to the current database
use movinon_t6;
go


----8. view StorageRevenueReport
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

--test
select * from dbo.StorageRevenueReportV;
go