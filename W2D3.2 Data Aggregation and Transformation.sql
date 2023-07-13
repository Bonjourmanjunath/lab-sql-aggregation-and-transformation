# Needed for lab-sql-aggregation-and-transformation - challenge 1
# min, max
# avg, floor, round
# datediff
# extract month, extract weekday
# if / case
# coalesce
# concat
# left

# Needed for lab-sql-aggregation-and-transformation - challenge 2
# count, group by
# order by agg columns
# having


-- filtering on a "list" of items
select *
from offices
where city in ('NYC','Paris','Tokyo');

-- the above is the same as the the next query but below is a long winded way, especially 
-- if we were checking a list of 10s or 100s of items...
select *
from offices
where city = 'NYC' or city = 'Paris' or city = 'Tokyo';

-- typical way to check whats in a table, gives us all the columns and sample data of each column
select * from orders limit 5;
select * from orderdetails limit 5;

-- aggregation - MAX: returns the highest value within quantityOrdered
select max(quantityOrdered) from orderdetails;

-- we also have min for the lowest value, this can also apply to strings!
select max(status), min(status) from orders;
select distinct status from orders order by status;

-- and dates!
select min(orderDate), max(orderDate) from orders;

-- using datediff to calculate the difference (in days) between 2 dates
select datediff(max(orderDate), min(orderDate)) from orders;

select datediff("2023-01-10", "2023-01-01");

-- we can extract date parts and use these in our queries...
-- below we extract the year from the date and use it to filter our results to 2005 only
select * from orders
where year(orderDate) = 2005;

-- this achieves the same as the above
select * from orders 
where orderDate >= "2005-01-01" and orderDate < "2006-01-01";

-- we can use the between keyword to check if a value falls between two values 
-- (inclusive -- includes the stated values)
select * from payments
where amount between 2000 and 3000;

-- same as the above without using between
select checkNumber, amount, floor(amount), round(amount), ceiling(amount) from payments
where amount >= 2000 and amount <= 3000;

-- extracting year and month parts from a date - below we use that to filter results to
-- january 2005.
select * from orders
where year(orderDate) = 2005
and month(orderDate) = 1;

-- now() gives the current timestamp (date and time)
-- current_date gives the current date
-- below we calculate the number of days between today and the start of 2023
select date(now()) - date("2023-07-01");

-- weekday extracts an integer value from a date representing the day of the week
select weekday(current_date); -- 3 = Thursday
-- 0 = Monday
-- 1 = Tuesday
-- 2 = Wednesday
-- 3 = Thursday
-- 4 = Friday
-- 5 = Saturday
-- 6 = Sunday

-- case statements are super useful!
-- basic syntax of a case statement
select case when 5=3 then 'Haha'
			when 5=5 then 'Ya got me'
            else 'Weeee'
            end;

-- we can use a case statement in the select portion of a script to alter what is shown
-- below we use it to change the date to show if it is a weekday or weekend
select case when weekday(current_date) < 5 then 'Weekday' else 'Weekend' end;

-- here we use it to both show the change and filter to only weekends
-- select all rows from payments filtered to just weekends
select *,
case when weekday(paymentDate) < 5 then 'Weekday' else 'Weekend' end as "isWeekend"
from payments
where case when weekday(paymentDate) < 5 then 'Weekday' else 'Weekend' end = 'Weekend';

-- if we don't specify an else in our case statement and thing not found/captured will be null
-- here, the second column will be null for weekend days
select case when weekday(paymentDate) < 5 then 'Weekday' else 'Weekend' end as "isWeekend"
, case when weekday(paymentDate) < 5 then 1 end
, weekday(paymentDate) < 5 from payments;

-- count doesn't count nulls....
select count(*) as total_count
, count(weekday(paymentDate) < 5) as weekday_count_or_not
, sum(weekday(paymentDate) < 5) as weekday_count
, count(case when weekday(paymentDate) < 5 then 1 end) as weekday_count2
, count(case when weekday(paymentDate) >= 5 then 1 end) as weekend_count
from payments;

-- we can use if statements as well in SQL: if ( condition, true_outcome, false_outcome ) 
-- (similar to excel/sheets syntax)
select if (weekday(current_date) < 5, 'Weekday', 'Weekend');

-- isnull can be use to check if a value is null or not
select *, isnull(image), isnull(productLine), isnull(image) and isnull(productLine) from productlines;

-- coelesce is a great function to replace a null values with something more appropriate
select *
, coalesce(htmlDescription, 5)
, coalesce(htmlDescription, case when left(textDescription,1) like 'A' then textDescription end, 5) 
from productLines;

-- concat(str1,str2,str3,....) is use to break sentences togather, awwww
select productLine
, textDescription
, concat(productLine, ' :- ', textDescription)
from productlines;

-- aggregating by something? then we want to group by too - group by all the non-aggregate items
-- you have in your select column
select year(paymentDate), month(paymentDate), sum(amount), avg(amount), count(*) 
from payments
group by year(paymentDate), month(paymentDate);

-- we can have multiple aggregate columns in the same query
select year(paymentDate),  sum(amount), avg(amount), count(*) 
from payments
group by year(paymentDate);

-- dateformat can be used to truncate a date
select DATE_FORMAT(paymentDate, '%Y-%m') , sum(amount), avg(amount), count(*) 
from payments
group by DATE_FORMAT(paymentDate, '%Y-%m')
order by DATE_FORMAT(paymentDate, '%Y-%m');

-- to see specific records of a year, month...
select * 
from payments 
where year(paymentDate) = 2004
      and month(paymentDate) = 10;
      
-- HAVING
-- we can use the having keyword to filter on aggregations
select year(paymentDate),  sum(amount), avg(amount), count(*) 
from payments
group by year(paymentDate)
having sum(amount) > 2000000
order by year(paymentDate);
