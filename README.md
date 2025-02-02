# Fetch Take Home Assignment

## Part 1: Exploring the Data (see part1.ipynb for code)

### Data Quality Issues

* The BARCODE variable from products and transactions presents a range of data quality issues.  Although it is reported as a number, it should be converted from a float to an object as a barcode is meant to act as an identifier and shouldn't be formatted with a ".0" at the end.  Additionally, BARCODE should act as the primary key in products which means it should be completely unique by row, and this isn't the case.  I identified duplicate barcodes in products as well as entire rows which are duplicates.  There are also missing values for BARCODE in both products and transactions, making those rows useless if I am to join the datasets on that key.
* The FINAL_QUANTITY variable from transactions presents a range of data quality issues.  First, the data type should be an int, but it's reported as an object because many of the values are "zero".  Furthermore, the values which are "zero" don't make sense because I wouldn't think the row should exist if a customer didn't buy any items of a given barcode.  There are also some values which are reported as floats which don't make sense for a variable which is reporting quantity.  On a similar note, the FINAL_SALE variable has " " values which prevent it from having a float data type, although it should not necessarily be assumed that they should be imputed with "0" as they may just be missing.
* Missing values: There are multiple fields with missing values throughout the 3 datasets.  Some may be justified, such as "CATEGORY_4", as not all products will have multiple sub-categories which can be entered.  However, there are missing values for BARCODE in both products and transactions which is a problem because it's the primary key in products.  There are also missing values for variables like "MANUFACTURER", "BRAND", and "GENDER" which are worth exploring (Why is the branding unknown for some products? Did users choose not to enter their gender into the data?).
* The structure of the transactions table is very unclean and confusing.  There is no primary key which identifies each row in the table, which should correspond to a unique product of a certain quantity that the user bought.  Although it makes sense that RECEIPT_ID is not a unique identifier (there can be multiple products/barcodes on one receipt), it doesn't make sense that there are duplicate barcodes within the same receipt across rows.  The FINAL_QUANTITY variable should reflect the amount of repeated barcodes on a given receipt, but because there are duplicate barcodes/receipt number combinations, it is unclear how the data should be aggregated.  It seems strange to me that the vast majority of receipt numbers have only 1 unique barcode associated (21310 occurences), many receipt numbers only have missing barcodes (2801 occurences), and only a small amount of receipt numbers have more (318 occurences of 2 unique barcodes; 11 occurences of 3 unique barcodes).  I would think most customers would buy a larger range of products on a single receipt.
* The users table contains exactly 100k entries and the transactions table contains exactly 50k entries.  These exact numbers cause suspicion that I received samples of data rather than the full datasets.

### Fields Which are Challenging to Understand

* The "CATEGORY_x" variables from products are slightly confusing because they are only differentiated by different numbers which don't convey information.  However, looking at the data, it seems clear that the variables are referring to a sub-category which becomes more granular as x increases.  I would rename the columns to "Category", "Sub-Category", "Sub Category 2", "Sub Category 3".
* I would verify the difference in meaning between the "PURCHASE_DATE" and "SCAN_DATE" in transactions.  It is confusing to me that these two dates are often different in a given row of data because I would expect the customer to purchase the items at approximately the same time items are scanned.  SCAN_DATE is also reported as a datetime whereas PURCHASE_DATE is reported only as a date, so I might request that I also get PURCHASE_DATE as a datetime so I could properly compare the two variables.

## Part 2: SQL Queries (see part2.sql for code)

Closed Question A:

Open Question A:

Open Question B:

## Part 3: Communicating With Stakeholders
