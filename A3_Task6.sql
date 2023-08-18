/* Purpose: Database MovinOn_T6
	View for Warehouse Manager Report Labels
Script Date: August 18, 2023
Developed by: Team 6
				Benjamin Pye
				Claudiu Terenche
				Karina De Vargas Pereira
*/

-- switch to the current database
use movinon_t6;
go

----6. view 'warehousemanagerReportLabels' contains,warehouseID, WarehouseManager, Mailing address, phone
Create view dbo.WarehouseMangerReportLabels
as select
	W.WarehouseID as 'Warehouse ID',
	concat_ws(', ', E.EmpLast, E.EmpFirst) as 'Warehouse Manager',
	concat_ws(', ', W.address, W.city, W.state, W.zip) as 'Address',
	W.Phone as 'Phone Number'
	from production.Warehouses as W
	Inner join humanResources.employees as E
	on W.WarehouseID = E.WarehouseID
	group by E.PositionID, W.WarehouseID, E.EmpLast, E.EmpFirst, W.Address, W.city, W.state, W.ZIP, W.phone
	having E.PositionID = 2
;
go

-- test
select *
from dbo.WarehouseMangerReportLabels
;
go