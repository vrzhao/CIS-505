use apps_and_crunchbase;

-- 1. (3 pts) What are the top lists? (as indicated by the column: list)
select distinct list as "lists" from top300;

-- 2. (3 pts) The data in top300 was collected on a daily basis. Can you tell the data collection period?  
select min(date(insert_time)) as "First Day", max(date(insert_time)) as "Last Day", timestampdiff(day, min(date(insert_time)), max(date(insert_time))) + 1 as "Number of Days", count(distinct date(insert_time)) as "Number of Days with Data" from top300;

select year(insert_time) as "Year", month(insert_time) as "Month", count(distinct date(insert_time)) as "Data enteries in the Month", day(last_day(insert_time)) as "Days in the Month", if(year(insert_time) = 2012, 1, day(last_day(insert_time))) - count(distinct date(insert_time)) as "Missing Entries" from top300 group by year(insert_time), month(insert_time);

-- 3. (3 pts) On Aug 31, do we miss any data for any of the top lists? Please provide evidence to support your answer. 
select distinct list as "Missing Lists" from top300 where list not in (select distinct list from top300 where month(insert_time) = 08 and day(insert_time) = 31);

-- 4. (3 pts) Is the data for the list "Top Free" complete?
select min(date(insert_time)) as "First Day", max(date(insert_time)) as "Last Day", timestampdiff(day, min(date(insert_time)), max(date(insert_time))) + 1 as "Number of Days", count(distinct date(insert_time)) as "Number of Days in Top Free", if(timestampdiff(day, min(date(insert_time)), max(date(insert_time))) <> 0, 'No', 'Yes') as "Is the Data Complete?" from top300 where list = "Top Free";

-- 5. (3 pts) There are apps that appeared in the list of "Top Free" every single day for the whole period. How many such apps are there?
(select count(id) as count from top300 where list = "Top Free" group by id having count(distinct id) = 366) union (select 0);

-- 6. (3 pts) How many apps have been ranked number 1 in the “Top Free” list?
select count(distinct id) as "Number of Ranked 1 Apps" from top300 where mod(idx, 300) = 1 and list = "Top Free";

-- 7. (3 pts) In the "Top Free" list, which two primary categories appear most often?
select Category_primary as "Primary Category", count(Category_primary) as count from apps, top300 where apps.id = top300.id and list = "Top Free" group by Category_primary order by count DESC limit 2;

-- 8. (3 pts) What is the shortest time in number of days between an app’s release date and the date an app makes to the top list? What do you think about this information? 
select min(timestampdiff(day,apps.Release_date,date(top300.insert_time))) as "Shortest Time (Days)" from top300, apps where top300.id = apps.id;

select timestampdiff(day,apps.Release_date,date(top300.insert_time)) as "Difference Between Release and Top300 (Days)" from top300, apps where top300.id = apps.id order by timestampdiff(day,apps.Release_date,date(top300.insert_time)) ASC ;

-- 9. A. (2 pts) During the data collection period, there are 300 apps per top list per day per Apple Store. Is the data in top300 complete? How do you know?  
select list, count(distinct date(insert_time)) as "Number of Days with Data" from top300 group by list;

-- B. (2 pts) If the data is not complete, can you make an estimate about the amount of data missing in the top300 table?  
select list, 366*300 as "Expected Data Points", count(distinct date(insert_time)) * 300 as "Data Points in the Database", 366*300 - count(distinct date(insert_time)) * 300 as "Data Points Missing" from top300 group by list;

-- 10. (3 pts) Is the apps table complete? That is, do we have data on all apps that appear in the top 300 list?  Please provide evidence supporting your answer.    
select count(distinct top300.id) as Top300, count(distinct apps.id) as Apps, count(distinct top300.id) - count(distinct apps.id) as Missing from top300 left join apps on top300.id = apps.id;

-- 11. Bonus question (2 pts): Have you noticed any other missing data or data of error? If so, please indicate them here.  
-- There are days with double insertion with different app ids. 
select list, count(distinct date(insert_time)) as "Number of Days with Data", cast(count(date(insert_time))/300 as unsigned) as "Number of Data Insertions" from top300 group by list;
-- There are days where data is collected more than once.
select distinct date(insert_time) as date, list, count(date(insert_time)) as "Data Collected", count(distinct id) as "Unique Ids" from top300 group by date(insert_time), list having count(date(insert_time)) > 300;
