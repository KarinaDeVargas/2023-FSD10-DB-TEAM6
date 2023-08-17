/* Purpose: Creating schema objects in the database MovinOn_T6
Script Date: August 18, 2023
Developed by: Team 6
				Benjamin Pye
				Claudiu Terenche
				Karina De Vargas Pereira
*/

-- switch to the current database 
use MovinOn_T6
;
go

/* create schema objects and set the owner to each of them
1. Sales
2. Production
3. HumanResources
4. Person
5. Purchasing
*/
   
-- syntax: create schema schema_name authorization onwer_name

-- 1. Sales schema
create schema Sales authorization dbo
;
go

-- 2. HumanResources schema
create schema HumanResources authorization dbo
;
go

-- 3. Production schema
create schema Production authorization dbo
;
go


/***** Table No. 1 - Sales.Customers ****/
alter schema Sales transfer dbo.Customers
;
go


/***** Table No. 2 - HumanResources.Employees ****/ 
alter schema HumanResources transfer dbo.Employees
;
go

/***** Table No. 3 - HumanResources.Positions ****/ 
alter schema HumanResources transfer dbo.Positions
;
go

/***** Table No. 4 - HumanResources.Drivers****/
alter schema HumanResources transfer dbo.Drivers
;
go

/***** Table No. 5 - Production.Vehicles ****/
alter schema Production transfer dbo.Vehicles
;
go

/***** Table No. 6 - Production.Warehouses ****/
alter schema Production transfer dbo.Warehouses
;
go

/***** Table No. 7 - Production.StorageUnits ****/ 
alter schema Production transfer dbo.StorageUnits
;
go

/***** Table No. 8 - Production.UnitRentals ****/ 
alter schema Production transfer dbo.UnitRentals
;
go

/***** Table No. 9 - Sales.JobOrders ****/
alter schema Sales transfer dbo.JobOrders
;
go

/***** Table No. 10 - Sales.JobDetails ****/
alter schema Sales transfer dbo.JobDetails
;
go


/* display used-defined and system tables */
-- in schema 1. Sales 
execute sp_tables
@table_qualifier = 'MovinOn_T6',
@table_owner = 'Sales'
;
go

-- in schema 2. HumanResources
execute sp_tables
@table_qualifier = 'MovinOn_T6',
@table_owner = 'HumanResources'
;
go

-- in schema 3. Production
execute sp_tables
@table_qualifier = 'MovinOn_T6',
@table_owner = 'Production'
;
go

