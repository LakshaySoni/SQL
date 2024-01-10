Query 1 : How many accidents have occurred in urban verses rural areas ?
 Ans           Select area,count(*) Total_Acc from accident
         group by area
 
Query 2 : Which day of the week has the highest number of accidents ?
Ans  	    Select datename(dw,date) Day_name,count(*) Total_Acc from accident
  group by datename(dw,date)
  Order by Total_Acc desc

  Query 3 : What is avg of vehicle involved in accidents based on their type ?
    
 Ans : Select Vehicletype, 
   count(*) toatl_a,
   avg(agevehicle) Avg_age 
   from vehicle 
   where agevehicle is not null
   group by Vehicletype 
order by toatl_a desc

Query 4 : Can we identify any trends in accidents based on the age of vehicles involved?	
Select
 age_group,
avg(agevehicle) Avg_age ,
count(*) toatl_a
from (
select agevehicle,
case
when agevehicle between 0 and 5 then 'New'
when agevehicle between 5 and 10 then 'Regular'
else 'old'
end as age_group
from vehicle
where agevehicle is not null
) subquery
Group by age_group
 order by toatl_a desc

 Query 5 : Are there any specific weather conditions that contribute to severe accidents?
Ans.   declare @severity varchar(max)
set @severity = 'serious'

Select weatherconditions, count(*) Total
from accident
--where severity=  @severity
group by weatherconditions
order by Total desc

Query 6 : Do accidents often involve impacts on the left-hand side of vehicles?
 Ans: Select lefthand, count(*) Total
from vehicle
group by lefthand
having lefthand is not null
order by Total desc

Query 7 : Are there any relationships between journey purposes and the severity of accidents?
Ans : 	
with CTE as
(
select v.journeypurpose, a.severity ,count(a.area) total, type=
case 
	when count(a.area) between 0 and 1000  then 'low'
	when count(a.area) between 1001 and 3000  then 'Avg'
	else 'high'
end
from accident A
join vehicle V
on A.accidentIndex=V.accidentIndex
group by v.journeypurpose, a.severity
)
select * from CTE order by total desc


Query 8. Calculate the average age of vehicles involved in accidents , considering Day light and point of impact 
Ans .
Declare @Point varchar(max)
Declare @light varchar(max)
Set @light = 'Darkness'
Set @Point = 'Front'
select 
v.PointImpact,
a.lightconditions,
avg(v.agevehicle) Avgage,
Count(a.severity) total
from accident A
join vehicle V
on A.accidentIndex=V.accidentIndex
Group by v.PointImpact,lightconditions
having a.lightconditions = @light and v.PointImpact = @Point
Order by Avgage desc
