-- Describe the table --
describe ksproject;
/* The DESCRIBE command offers detailed information about each column in a table,
including the column name, data type, whether it allows NULL values, indexing
status, and default value.
*/
-- Drop the not required columns --
alter table ksproject
drop column goal,
drop pledged,
drop usd_pledged;
/*
Dropping 3 columns from this table which is redundant and will not be used for analysis-
1. goal: The funding goal set by the project creator (in the project’s respective currency).
2. pledged: The total amount of money backers pledged at the campaign's end. (country's respective currency)
3. usd_pledged: Kickstar’s internal currency conversion system (exchange rate at the time of the campaign’s deadline) for 
internal reporting and may not be as accurate or up-to-date as external currency.
*/
-- Refresh -- 
-- Check duplicate rows (if present) --
with check_duplicate as(
select *,
row_number()over(partition by id, name, category, main_category, currency, deadline, launched, state, backers, country, usd_pledged_real, usd_goal_real) as dup_rwn
from ksproject)

select * from check_duplicate
where dup_rwn > 1;
-- no duplicates found --

-- Which are the high and low-performing categories?
-- For successful categories --
with success_projects as(
select id, main_category,
case state when "successful" then 1 else 0 end as success_parity -- a new column success_parity will contain 0 (not successful) and 1 (successful) for all the projects
from ksproject)

select main_category,
round(sum(success_parity)*100/count(success_parity),2) as success_rate -- calculating the success rate for each main_category
from success_projects
group by main_category
order by success_rate desc;

-- For failed categories --
with failed_projects as(
select id, main_category,
case state when "failed" then 1 else 0 end as failed_parity -- similar to sucess_parity
from ksproject)

select main_category,
round(sum(failed_parity)*100/count(failed_parity),2) as failed_rate -- similar to success rate, but calculating failed rate
from failed_projects
group by main_category
order by failed_rate desc;

-- For canceled categories --
with canceled_projects as(
select id, main_category,
case state when "canceled" then 1 else 0 end as canceled_parity -- similar to sucess_parity
from ksproject)

select main_category,
round(sum(canceled_parity)*100/count(canceled_parity),2) as canceled_rate -- similar to success rate, but calculating canceled rate
from canceled_projects
group by main_category
order by canceled_rate desc;
/*
The performance metrics (success rate, failure rate, and cancellation rate) are calculated by dividing 
the number of successful, failed, or canceled projects by the total number of projects and multiplying 
the result by 100. This query calculates these performance metrics, groups the data by main categories, 
and sorts the results in descending order.
*/

--  Which categories have significant pledged amounts and a high number of backers?
select main_category, category,
round(sum(usd_pledged_real),2) as project_pledged_amount, -- rounded the value to 2 decimal places
sum(backers) as project_backers
from ksproject
group by main_category, category
order by project_pledged_amount desc
limit 10;
/*
I grouped the categories to calculate the total pledged amount and backer count. I ordered the results
in descending orders and used a limit clause to see the top 10 categories by total project pledged amount.
*/

-- Analyse & identify the relationship between the backers and the categories. --
select main_category,
round(sum(usd_pledged_real)/sum(backers),2) as pledged_by_backer_ratio
from ksproject
group by main_category
order by pledged_by_backer_ratio desc;
/*
In this query, I grouped the categories to calculate the pledged-to-backer ratio (pledged amount/backer), 
which represents the average pledged amount per backer. This metric helps in understanding the relationship
between categories and backers.
*/

-- Which countries have the highest number of successful projects?
with success_projects as(
select id, country,
case state when "successful" then 1 else 0 end as success_parity
from ksproject)

select country,
sum(success_parity) as successful_projects,
count(id) as total_projects from success_projects
group by country
order by total_projects desc
limit 5;
/*
I have used the cte to select id, country, and sucess_parity (explanation from the first query).
The countries were grouped, and the total number of successful projects hosted by each country 
was calculated using summation. I have used a limit clause to limit the result.
*/

-- How can we identify the categories that exceed their project goals and determine the average pledged amount by backers? --
select main_category, category, country,
round(sum(usd_goal_real),2) as project_goal_amount,
round(sum(usd_pledged_real),2) as project_pledged_amount,
round(avg(usd_pledged_real),2) as average_pledged_amount
from ksproject
group by main_category, category, country
having project_pledged_amount >= project_goal_amount
order by project_pledged_amount desc
limit 10;
/*
In this query, I grouped the categories and subcategories to identify those that achieved their 
project goals, meaning the pledged amount was greater than or equal to the goal. Additionally, 
I calculated the average pledged amount per backer for each subcategory.
*/

-- How can the optimal project duration and months with high success rates be identified?
with success_project_trend as(
select id, month(date(launched)) as project_launched_month, month(date(deadline)) as project_deadline_month,
case state when "successful" then 1 else 0 end as success_parity
from ksproject)
-- Insert this query for successfully launched month --
select project_launched_month,
round(sum(success_parity)*100/count(id),2) as success_rate
from success_project_trend 
group by project_launched_month
order by project_launched_month;
-- Insert this query for successfully deadline month --
select project_deadline_month,
round(sum(success_parity)*100/count(id),2) as success_rate
from success_project_trend 
group by project_deadline_month
order by project_deadline_month;

-- To find the best optimal duration of the project --
with optimal_duration as(
select main_category, 
date(launched) as project_launched_date, 
date(deadline) as  project_deadline_date,
case state when "successful" then 1 else 0 end as success_parity
from ksproject)

select main_category, 
round(avg(datediff(project_deadline_date,project_launched_date)),2) as project_duration
from optimal_duration
group by main_category
order by project_duration desc;
/*
This involves a combination of multiple queries:
1. Queries to analyze project success rates based on their launch and deadline months.
2. Queries to identify the optimal duration for categories to achieve success.
I used CTEs to extract and analyze the launch and deadline columns from the dataset. 
Additionally, I created a new column using a CASE statement and utilized the DATEDIFF 
function to calculate the project duration.
*/

-- How can analyzing category trends over the years, based on success, failure, and cancellation rates,
-- help identify top-performing categories and those with untapped potential?
with project_year as(
select year(date(launched)) as year, main_category, category,
sum(case state when "successful" then 1 else 0 end) as success_parity,
sum(case state when "failed" then 1 else 0 end) as failed_parity,
sum(case state when "canceled" then 1 else 0 end) as cancelled_parity
from ksproject
group by year(date(launched)),main_category, category),

-- Insert this query for successful project performance over the years --
project_success_performance as(
select year, main_category, category,
row_number()over(partition by year order by success_parity desc) as rwn
from project_year)

select year, main_category, category
from project_success_performance
where rwn = 1;

-- Insert this query for failed project performance over the years--
project_failed_performance as(
select year, main_category, category,
row_number()over(partition by year order by failed_parity desc) as rwn
from project_year)

select year, main_category, category
from project_failed_performance
where rwn = 1;

-- Insert this query for canceled project performance over the years --
project_cancelled_performance as(
select year, main_category, category,
row_number()over(partition by year order by cancelled_parity desc) as rwn
from project_year)

select year, main_category, category
from project_cancelled_performance
where rwn = 1;
/* I utilized two CTEs each in this query to evaluate the performance metrics. I applied
a window function to rank the categories based on the number of successful projects for 
each year.
*/

-- End of the project --
-- Thank you for your patience --


