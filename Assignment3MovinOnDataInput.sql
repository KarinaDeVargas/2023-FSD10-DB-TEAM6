use movinOn_T6
;
go

bulk insert dbo.vehicles
from 'h:princess/documents/1-johnabbot/movinon_data_source/vehicles.csv'
with 
(
	firstrow = 1,
	fieldterminator = ',',
	rowterminator = '\n'
)
;
go

bulk insert dbo.Customers
from 'h:princess/documents/1-johnabbot/movinon_data_source/Customers.csv'
with 
(
	firstrow = 2,
	fieldterminator = ',',
	rowterminator = '\n'
)
;
go

alter table dbo.drivers
	alter column EndDate datetime null
;
go

bulk insert dbo.Drivers
from 'h:princess/documents/1-johnabbot/movinon_data_source/Drivers.csv'
with 
(
	firstrow = 2,
	fieldterminator = ',',
	rowterminator = '\n'
)
;
go

bulk insert dbo.Employees
from 'h:princess/documents/1-johnabbot/movinon_data_source/Employees.csv'
with 
(
	firstrow = 2,
	fieldterminator = ',',
	rowterminator = '\n'
)
;
go

bulk insert dbo.JobDetails
from 'h:princess/documents/1-johnabbot/movinon_data_source/JobDetails1.csv'
with 
(
	firstrow = 1,
	fieldterminator = ',',
	rowterminator = '\n'
)
;
go

bulk insert dbo.JobOrders
from 'h:princess/documents/1-johnabbot/movinon_data_source/JobOrders.csv'
with 
(
	firstrow = 2,
	fieldterminator = ',',
	rowterminator = '\n'
)
;
go

bulk insert dbo.Storageunits
from 'h:princess/documents/1-johnabbot/movinon_data_source/StorageUnits.csv'
with 
(
	firstrow = 2,
	fieldterminator = ',',
	rowterminator = '\n'
)
;
go

bulk insert dbo.UnitRentals
from 'h:princess/documents/1-johnabbot/movinon_data_source/UnitRentals.csv'
with 
(
	firstrow = 2,
	fieldterminator = ',',
	rowterminator = '\n'
)
;
go

insert dbo.positions
Values(1, 'CEO'),
(2, 'Warehouse Manager'),
(3, 'Administrative Assistant'),
(4, 'Warehouse Clerk'),
(5, 'Forklift Operator'),
(6, 'Labourer'),
(7, 'Information Systems Specialist')
;
go

insert dbo.warehouses
values('OR-01', '123 Street Place', 'Oregon City', 'OR', '45321','(321) 123-9876', 1, 1),
('WA-01', '432 Place Street', 'Seattle', 'WA', '86742', '(321) 123-9999', 0, 1),
('WY-01', '66 Street Avenue', 'Bottstrap', 'WY', '54631', '(333) 325-5555', 1, 1)
;
go