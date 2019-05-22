use apps_and_crunchbase;

-- 1. Retrieve all the attributes for app "Twitter" 
select * from apps where name like "Twitter";

-- 2.	Retrieve the name and price for the apps whose name contains the string "sun" (hint: can begin with "sun", end with "sun", or have "sun" in the middle (e.g. Samsung) 
select name, price from apps where name like "%sun%";

-- 3.	 Retrieve the number of apps whose seller url is not missing 
select count(*) from apps where seller_url is not null;

-- 4. Retrieve the primary categories (don't show duplicates) 
select distinct Category_primary from apps;

-- 5	Retrieve the min, average, max prices for the primary category "Finance" 
select min(price) as MIN, avg(price) as Average, max(price) as MAX from apps where Category_primary like "Finance";

-- 6.	Show the distribution of the price of apps. In other words, list all of the prices with the count of the apps at a given price.  Please order your results by price in ascending order. (Hint, you should have two columns in your result: price and count. If you are interested in knowing the price structure of apps, you might want to read the first few paragraphs of this article).
select price, count(price) as count from apps group by price order by price ASC;

-- 7. What is the mean price among the paid apps for each category? list in descending order of the mean price.
select Category_primary as Category, AVG(price) as Average from apps where price > 0 group by Category_primary order by Average DESC;

-- 8. Give a top 10 countdown of the most prolific app developers (e.g. list (in decreasing order) the names of the developers that write the most apps and the total number of apps they wrote. (Hint: Two columns, developer name, number of apps, in decreasing order, only the top 10 please)  
select Developer_name, count(Developer) as count from apps group by Developer order by count DESC limit 10;

-- 9. Retrieve the id and name for the developers who developed apps in at least 10 primary categories;
select Developer, Developer_name from apps group by Developer having count(distinct Category_primary) >= 10;

-- 10. Are there apps with the same name?  Ask about the answer.
select (if(count(n) > 0, 'Yes', 'No')) as 'Are there apps with the same name?', count(n) as 'Number of Names used by at least 2 apps' from (select name, count(name) as n from apps group by name having n > 1) as a;

-- 11. Retrieve the name of the app that has the highest number of ratings (i.e., rating_count) and the number of ratings it received.  
select name, rating_count from apps, app_reviews, (select max(rating_count) as count from app_reviews) as maximum where apps.id = app_reviews.id and app_reviews.rating_count = maximum.count;

-- 12. Retrieve the name and primary category for the apps that are game-center enabled and whose primary category is not "Games".
select name, Category_primary from apps where Category_primary <> "Games" and Game_center = 1;

-- 13. In which primary category, the apps have the highest mean average_rating? 
select Category_primary as Category, rating as Average from (select Category_primary, AVG(average_rating) as rating from apps, app_reviews where apps.id = app_reviews.id group by Category_primary) as average having rating = max(rating);

-- 14. List the total number of ratings (rating_count) for each primary category? Please list them in descending order of the total number of ratings. 
select Category_primary as Category, sum(rating_count) as rating_count from apps, app_reviews where apps.id = app_reviews.id group by Category_primary order by rating_count DESC;

-- 15. List the primary category, number of ratings and average ratings for the app “Google Earth”. 
select Category_primary as Primary_Category, rating_count, average_rating from apps, app_reviews where apps.id = app_reviews.id and name like "Google Earth";
