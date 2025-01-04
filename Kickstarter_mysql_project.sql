-- Project Details --
describe ksproject;
-- check duplicate --
with check_duplicate as(
select *,
row_number()over(partition by id) as dup_rwn
from ksproject)

select * from check_duplicate
where dup_rwn > 1;
-- no duplicate by id number --

-- Find successfull, failed, & cancelled projects --
with success_projects as(
select id, main_category,
case state when "successful" then 1 else 0 end as success_parity
from ksproject)

select main_category,
round(sum(success_parity)*100/count(success_parity),2) as success_rate
from success_projects
group by main_category
order by success_rate desc
limit 5;
-- Failed --
with failed_projects as(
select id, main_category,
case state when "failed" then 1 else 0 end as failed_parity
from ksproject)

select main_category,
round(sum(failed_parity)*100/count(failed_parity),2) as failed_rate
from failed_projects
group by main_category
order by failed_rate desc
limit 5;
-- Canceled --
with canceled_projects as(
select id, main_category,
case state when "canceled" then 1 else 0 end as canceled_parity
from ksproject)

select main_category,
round(sum(canceled_parity)*100/count(canceled_parity),2) as canceled_rate
from canceled_projects
group by main_category
order by canceled_rate desc
limit 5;

-- Which category within main category with highest pledged
-- amount, most backers
select main_category, category,
round(sum(usd_pledged_real),2) as project_pledged_amount,
sum(backers) as project_backers
from ksproject
group by main_category, category
order by project_pledged_amount desc
limit 10;
-- Which country host most successful projects
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

-- How many projects in main_category meet their goal, 
-- and average pledge on these projects
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

-- Products that has performed good and low over the years --
with project_year as(
select year(date(launched)) as year, main_category, category,
sum(case state when "successful" then 1 else 0 end) as success_parity,
sum(case state when "failed" then 1 else 0 end) as failed_parity,
sum(case state when "cancelled" then 1 else 0 end) as cancelled_parity
from ksproject
group by year(date(launched)),main_category, category),

project_performance as(
select year, main_category, category,
row_number()over(partition by year order by success_parity desc) as rwn
from project_year)

select year, main_category, category
from project_performance
where rwn = 1;









