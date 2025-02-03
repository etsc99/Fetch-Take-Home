/* Part 2: SQL Queries */

-- What are the top 5 brands by receipts scanned among users 21 and over? --

WITH users_over_21 as ( -- This CTE gets a list of IDs from users over 21 years old
    SELECT ID
    FROM users
    WHERE TIMESTAMPDIFF(YEAR, BIRTH_DATE, CURDATE()) >= 21),

brand_receipts as ( -- This CTE creates a table of the count of distinct receipt ids by brand
    SELECT p.BRAND, COUNT(DISTINCT t.RECEIPT_ID) as receipt_count
    FROM transactions as t
    INNER JOIN products as p 
    ON t.BARCODE = p.BARCODE
    INNER JOIN users_over_21 as u -- joining only on the users above 21 y/o
    ON t.USER_ID = u.ID
    GROUP BY p.BRAND)

SELECT BRAND, receipt_count -- Finally, reporting the table only for the top 5 receipt counts
FROM brand_receipts
ORDER BY receipt_count DESC
LIMIT 5;

-- What is the percentage of sales in the Health & Wellness category by generation? --

WITH user_generations as ( -- This CTE defines the generations based on birth date
    SELECT ID,
        CASE 
            WHEN BIRTH_DATE >= '1997-01-01' THEN 'Generation Z'
            WHEN BIRTH_DATE BETWEEN '1981-01-01' AND '1996-12-31' THEN 'Millennials'
            WHEN BIRTH_DATE BETWEEN '1965-01-01' AND '1980-12-31' THEN 'Generation X'
            WHEN BIRTH_DATE BETWEEN '1946-01-01' AND '1964-12-31' THEN 'Baby Boomers'
            WHEN BIRTH_DATE BETWEEN '1928-01-01' AND '1945-12-31' THEN 'Silent Generation'
            WHEN BIRTH_DATE < '1928-01-01' THEN 'Greatest Generation' -- There are a few birth dates which are entered as before 1901 but I will keep them in this bucket
            ELSE 'Generation Alpha'
        END as GENERATION
    FROM users),

sales_by_generation as ( -- This CTE gets the health/wellness sales and total sales by generation
    SELECT 
        ug.GENERATION,
        SUM(CASE WHEN p.CATEGORY_1 = 'Health & Wellness' THEN t.FINAL_SALE ELSE 0 END) as health_sales,
        SUM(t.FINAL_SALE) as total_sales
    FROM transactions as t
    INNER JOIN products as p ON t.BARCODE = p.BARCODE
    INNER JOIN user_generations as ug ON t.USER_ID = ug.ID
    GROUP BY ug.GENERATION
)

SELECT GENERATION, health_sales, total_sales, -- Finally, dividing the health/wellness sales by the total sales to get the percent by generation for that category
    (health_sales / total_sales) * 100 as health_sales_percentage
FROM sales_by_generation;


-- At what percent has Fetch grown year over year? --

WITH yearly_users as ( -- This CTE gets the amount of user ids by year (all user ids are confirmed to be unique per the analysis in part 1)
    SELECT YEAR(CREATED_DATE) as year, COUNT(ID) as new_users
    FROM users
    GROUP BY YEAR(CREATED_DATE)),

cumulative_users as ( -- This CTE uses a window function to get the total cumulative created users by year
    SELECT year, SUM(new_users) OVER (ORDER BY year) as total_cumulative_users
    FROM yearly_users),

yearly_growth as ( -- This CTE uses each previous year's total cumulative users to calculate the % Fetch has grown year over year
    SELECT 
        year, total_cumulative_users,
        LAG(total_cumulative_users) OVER (ORDER BY year) as previous_year_users,
        (total_cumulative_users - LAG(total_cumulative_users) OVER (ORDER BY year)) 
        / LAG(total_cumulative_users) OVER (ORDER BY year) * 100 as percent_growth
    FROM cumulative_users)

-- Finally, using a weighted average based on the amount of previous year users to get a weighted average year-over-year growth pct for Fetch

SELECT ROUND(SUM(percent_growth * previous_year_users) / SUM(previous_year_users), 2) as weighted_avg_yoy_growth
FROM yearly_growth
WHERE percent_growth IS NOT NULL;

