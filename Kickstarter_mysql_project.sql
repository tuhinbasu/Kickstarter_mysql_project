-- Describe the table --
describe ksproject;
/* The DESCRIBE command offers detailed information about each column in a table, including the column name, data type, 
whether it allows NULL values, indexing status, and default value.
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
-- no duplicate found --

-- Which are the high and low-performing categories?
-- Successful --
with success_projects as(
select id, main_category,
case state when "successful" then 1 else 0 end as success_parity
from ksproject)

select main_category,
round(sum(success_parity)*100/count(success_parity),2) as success_rate
from success_projects
group by main_category
order by success_rate desc;

-- Failed --
with failed_projects as(
select id, main_category,
case state when "failed" then 1 else 0 end as failed_parity
from ksproject)

select main_category,
round(sum(failed_parity)*100/count(failed_parity),2) as failed_rate
from failed_projects
group by main_category
order by failed_rate desc;

-- Canceled --
with canceled_projects as(
select id, main_category,
case state when "canceled" then 1 else 0 end as canceled_parity
from ksproject)

select main_category,
round(sum(canceled_parity)*100/count(canceled_parity),2) as canceled_rate
from canceled_projects
group by main_category
order by canceled_rate desc;

--  Which categories have significant pledged amounts and a high number of backers?
select main_category, category,
round(sum(usd_pledged_real),2) as project_pledged_amount,
sum(backers) as project_backers
from ksproject
group by main_category, category
order by project_pledged_amount desc
limit 10;


-- Backer Behaviour --
select main_category,
round(sum(usd_pledged_real)/sum(backers),2) as pledged_by_backer_ratio
from ksproject
group by main_category
order by pledged_by_backer_ratio desc;

-- Which country hosts the most successful projects
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

-- How many projects in main_category meet their goal,and average pledge on these projects
select main_category, category, country,
round(sum(usd_goal_real),2) as project_goal_amount,
round(sum(usd_pledged_real),2) as project_pledged_amount,
round(avg(usd_pledged_real),2) as average_pledged_amount
from ksproject
group by main_category, category, country
having project_pledged_amount >= project_goal_amount
order by project_pledged_amount desc
limit 10;

-- Trend in project launch and deadline --
with success_project_trend as(
select id, month(date(launched)) as project_launched_month, month(date(deadline)) as project_deadline_month,
case state when "successful" then 1 else 0 end as success_parity
from ksproject)

-- For launched month --
select project_launched_month,
round(sum(success_parity)*100/count(id),2) as success_rate
from success_project_trend
group by project_launched_month
order by project_launched_month;
-- For deadline month --
select project_deadline_month,
round(sum(success_parity)*100/count(id),2) as success_rate
from success_project_trend
group by project_deadline_month
order by project_deadline_month;

-- Best optimal duration of the project --
with optimal_duration as(
select main_category, 
date(launched) as project_launched_date, 
date(deadline) as  project_deadline_date,
case state when "successfull" then 1 else 0 end as success_parity
from ksproject)

select main_category, 
round(avg(datediff(project_deadline_date,project_launched_date)),2) as project_duration
from optimal_duration
group by main_category
order by project_duration desc;

-- 7. How can analyzing category trends over the years, based on success, failure, and cancellation rates, 
-- help identify top-performing categories and those with untapped potential?
with project_year as(
select year(date(launched)) as year, main_category, category,
sum(case state when "successful" then 1 else 0 end) as success_parity,
sum(case state when "failed" then 1 else 0 end) as failed_parity,
sum(case state when "cancelled" then 1 else 0 end) as cancelled_parity
from ksproject
group by year(date(launched)),main_category, category),

-- Insert the below code for --
-- Successful project performance over the years --
project_success_performance as(
select year, main_category, category,
row_number()over(partition by year order by success_parity desc) as rwn
from project_year)

select year, main_category, category
from project_success_performance
where rwn = 1;

-- Insert the below code for --
-- Failed project performance over the years--
project_failed_performance as(
select year, main_category, category,
row_number()over(partition by year order by failed_parity desc) as rwn
from project_year)

select year, main_category, category
from project_failed_performance
where rwn = 1;

-- Insert the below code for --
-- Cancelled project performance over the years --
project_cancelled_performance as(
select year, main_category, category,
row_number()over(partition by year order by cancelled_parity desc) as rwn
from project_year)

select year, main_category, category
from project_cancelled_performance
where rwn = 1;


