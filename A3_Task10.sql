/* Purpose: Database MovinOn_T6
	Answer Additional questions (FAQ)
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


----10. Additional questions that are frequently asked
----10.1 How many storage units did the company do last year?
if OBJECT_ID('dbo.CountStorageUnitFN', 'Fn') is not null
	drop function dbo.CountStorageUnitFN
;
go

-- create a function that calculates how many storage units did the company rent in a given year 
create function dbo.CountStorageUnitFN (@Year int)
returns int
as
begin
    declare @StartDate date, @Count int;

    set @StartDate = DATEFROMPARTS(@Year, 1, 1);
   
    select @Count = COUNT(*)
    from Production.UnitRentals
    where YEAR(DateIn) = @Year;

    return @Count;
end
;
go

--test
select dbo.CountStorageUnitFN(2016) as 'Number of Storage Units Rented in Given Year'
;
go


----10.2 What percentage of the customers rented at least one unit?
if OBJECT_ID('dbo.CalculateCustomerPercentageFn', 'Fn') is not null
	drop function dbo.CalculateCustomerPercentageFn
;
go

create function dbo.CalculateCustomerPercentageFn ()
returns decimal (5, 2)
as
BEGIN
    declare
	@TotalCustomers INT,
	@CustomersWithUnits INT, 
	@Percentage DECIMAL(5, 2);
		select @TotalCustomers = count(CustID)
	from Sales.Customers;
		select @CustomersWithUnits = COUNT(CustID)
    from Production.UnitRentals;
		select @Percentage = (@CustomersWithUnits * 100.0) / @TotalCustomers;
	return @Percentage;
end
;
go

--test
select dbo.CalculateCustomerPercentageFn() as 'Percent Of Customers Renting'
;
go

----10.3 what was the greatest number of rents by any one indiviual?
--create View used in function
create view SubView103
as
select count(unitID) as 'count' from production.unitrentals
group by CustID;
go

--test
select count
from SubView103;
go

-- function to find highest num of units rented by one customer
Create function dbo.MostNumRented()
returns int
as
begin
declare @highest as int
select @highest = max(count) from SubView103
return @Highest
end
;
go

--test
select dbo.MostNumRented() as 'Greatest Number of Rented Units by a customer'
;
go

-- 10.4 what is the average length of a rental period?

-- 10.5 what are the company peak months for rents?

if OBJECT_ID('dbo.PeakMonthsRentsV', 'V') is not null
	drop view dbo.PeakMonthsRentsV
;
go

create view	dbo.PeakMonthsRentsV
as
select
	DateName(month, DateIn) as 'Month',
	count(DateName(month, DateIn)) as 'Rent numbers'
	from production.unitrentals
	group by DateName(month, DateIn)
	;
go

select *
from dbo.PeakMonthsRentsV
;
go









--10.6 View of all FAQs

Create view FAQView
as
	Select
		dbo.CountStorageUnitFN(2016) as 'How many storage units did the company do last year?',
		dbo.PercentOfCustomersRentingFN() as 'What percentage of the customers rented at least one unit?',
		dbo.MostNumRented() as 'What was the greatest number of rents by any one indiviual?'
;
go

--test
select *
from FAQView
;
go