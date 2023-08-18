/* Purpose: Database MovinOn_T6
	View Of Moving Job Revenue
Script Date: August 18, 2023
Developed by: Team 6
				Benjamin Pye
				Claudiu Terenche
				Karina De Vargas Pereira
*/

-- switch to the current database
use movinon_t6;
go

----7.view JobvenueReport
create view dbo.JobRevenueReportV
as
SELECT
    JD.JobID as 'Job ID',
    JO.MoveDate as 'Date',
    CONCAT(DR.DriverFirst, ' ', DR.DriverLast) as 'Driver Name',
	DR.mileageRate as 'Driver Rate',
    JD.MileageActual as 'Mileage',
    JD.WeightActual as 'Weight',
    cast((JD.MileageActual * 0.7 + JD.WeightActual * 0.2)as decimal(14,2)) AS 'Income',
    cast((JD.MileageActual * 0.7 + JD.WeightActual * 0.2 - (50 + JD.MileageActual * DR.MileageRate)) as decimal(14,2)) AS 'NetIncome',
	cast((50 + (JD.MileageActual * DR.MileageRate))as decimal (14,2)) as 'Driver Pay'
FROM Sales.JobDetails JD
	INNER JOIN HumanResources.Drivers DR
	ON JD.DriverID = DR.DriverID
	INNER JOIN Sales.JobOrders as JO
	ON JD.JobID = JO.JobID

;
go

--test
select *
from dbo.JobRevenueReportV
;
go