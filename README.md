# Fetch Take Home Assignment

## Part 1: Exploring the Data (see part1.ipynb for code)

### Data Quality Issues

* The BARCODE variable from products and transactions presents a range of data quality issues.  Although it is reported as a number, it should be converted from a float to an object as a barcode is meant to act as an identifier and shouldn't be formatted with a ".0" at the end.  Additionally, BARCODE should act as the primary key in products which means it should be completely unique by row, and this isn't the case.  I identified duplicate barcodes in products as well as entire rows which are duplicates.  There are also missing values for BARCODE in both products and transactions, making those rows useless if I am to join the datasets on that key.
* The FINAL_QUANTITY variable from transactions presents a range of data quality issues.  First, the data type should be an int, but it's reported as an object because many of the values are "zero".  Furthermore, the values which are "zero" don't make sense because I wouldn't think the row should exist if a customer didn't buy any items of a given barcode.  There are also some values which are reported as floats which don't make sense for a variable which is reporting quantity.  On a similar note, the FINAL_SALE variable has " " values which prevent it from having a float data type, although it should not necessarily be assumed that they should be imputed with "0" as they may just be missing.
* Missing values: There are multiple fields with missing values throughout the 3 datasets.  Some may be justified, such as "CATEGORY_4", as not all products will have multiple sub-categories which can be entered.  However, there are missing values for BARCODE in both products and transactions which is a problem because it's the primary key in products.  There are also missing values for variables like "MANUFACTURER", "BRAND", and "GENDER" which are worth exploring (why is the branding unknown for some products? Did users choose not to enter their gender into the data?).
* The structure of the transactions table is very unclean and confusing.  There is no primary key which identifies each row in the table, which should correspond to a unique product of a certain quantity that the user bought.  Although it makes sense that RECEIPT_ID is not a unique identifier (there can be multiple products/barcodes on one receipt), it doesn't make sense that there are duplicate barcodes within the same receipt across rows.  The FINAL_QUANTITY variable should reflect the amount of repeated barcodes on a given receipt, but because there are duplicate barcodes/receipt number combinations, it is unclear how the data should be aggregated.  It seems strange to me that the vast majority of receipt numbers have only 1 unique barcode associated (21310 occurences), many receipt numbers only have missing barcodes (2801 occurences), and only a small amount of receipt numbers have more (318 occurences of 2 unique barcodes; 11 occurences of 3 unique barcodes).  I would think most customers would buy a larger range of products on a single receipt.
* The users table contains exactly 100k entries and the transactions table contains exactly 50k entries.  These exact numbers cause suspicion that I received samples of data rather than the full datasets.

### Fields Which are Challenging to Understand

* The "CATEGORY_x" variables from products are slightly confusing because they are only differentiated by different numbers which don't convey information.  However, looking at the data, it seems clear that the variables are referring to a sub-category which becomes more granular as x increases.  I would rename the columns to "Category", "Sub-Category", "Sub Category 2", "Sub Category 3".
* I would verify the difference in meaning between the "PURCHASE_DATE" and "SCAN_DATE" in transactions.  It is confusing to me that these two dates are often different in a given row of data because I would expect the customer to purchase the items at approximately the same time items are scanned.  SCAN_DATE is also reported as a datetime whereas PURCHASE_DATE is reported only as a date, so I might request that I also get PURCHASE_DATE as a datetime so I could properly compare the two variables.
* FINAL_QUANTITY variable: see fourth bullet point of previous section

## Part 2: SQL Queries (see part2.sql for code)

* What are the top 5 brands by receipts scanned among users 21 and over?

    NERDS CANDY (14), DOVE (14), COCA-COLA (13), SOUR PATCH KIDS (13), HERSHEY'S (13)

* What is the percentage of sales in the Health & Wellness category by generation?

    Gen Alpha: N/A (No Sales), Gen Z: 0%, Millenials: 57.28%, Gen X: 57.25%, Baby Boomers: 57.26%, Silent: 0%, Greatest: N/A (No Sales)

    Note: Users with ages corresponding to Gen Alpha and Greatest Generation existed in users but didn't match with any user ids in transactions.  Gen Z and Silent had very little sample size (2 and 6 total rows in the inner joined data, respectively).  I am also assuming that "percentage of sales" refers to % of the summed sales amount, not the number of sales regardless of the amount.

* At what percent has Fetch grown year over year?

    Weighted YoY Average Growth: 40.2%

    Assumptions: For this problem, the KPI I am using to define Fetch's growth is total users.  I would have opted for using revenue as the KPI based on FINAL_SALE from transactions, but my EDA from part 1 revealed that purchase and scan dates from transactions only cover 2024.  Additionally, the user table appears more clean and trustworthy than transactions (see part 1).  The caveat to this approach is that I do not have data on user churn, as factoring this in would give me a more accurate metric for total growth.  Therefore, I am assuming that users who create an account remain Fetch's customers up to the present day.  In order to obtain the target KPI, I calculated the cumulative number of users each year, as a non-cumulative total each year would reflect the rate of growth rather than the growth itself (a declining number of new Fetch users doesn't mean the company is shrinking if the previous users have retained; it only means the company is growing at a slower rate).  Then, I calculated a weighted average to account for low sample sizes of users in the beginning years.

## Part 3: Communicating With Stakeholders

Hello [Stakeholder],

    I have completed your requested analysis with the goal of understanding Fetch's YoY growth since the first users joined the app in 2014.  
    
    I hoped to use the app's total revenue as a KPI for defining company growth, but I ran into numerous data quality issues.  First, the company's transaction data only includes the year 2024, as I will need a full extract of data going back to 2014 in order to calculate YoY revenue growth.  Furthermore, I have concerns with the cleanliness of the transaction data which I hope to address with the data warehousing team in more detail (there appear to be duplicate entries and field names which I found difficult to interpret).

    Despite my difficulties with the data, I used an alternative KPI to measure Fetch's YoY growth, which is the total number of users who created an account on the app.  This KPI shows that Fetch has grown a weighted average of 40.2% per year since 2014.  The highest-growth years took place in the beginning years of the company (ie. 272% growth from 2017-2018), and this growth has consistenly slowed down in more recent years (ie. 13% growth from 2023-2024).  It is worth mentioning that this KPI does not take user churn into account.

    For next steps, I will meet with the data warehousing team to discuss my mentioned concerns with the data, and I will request data reflecting the entire history of Fetch's user transactions.  Furthermore, in order to complete a more accurate analysis of Fetch's user growth, I will request churn data which reflects users who deleted their accounts or are no longer active on the app.  I hope to reach out again next week to discuss Fetch's revenue growth as well as net-user growth.  Please reach out if you have any additional analysis requests.  Thank you and have a nice day.

    Sincerely,

    Ethan Schacht
    Data Analyst
    Fetch Rewards Inc
