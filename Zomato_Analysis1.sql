CREATE DATABASE IF NOT EXISTS ZOMATO_ANALYSIS;

USE ZOMATO_ANALYSIS;

SELECT * FROM  zomato1 ;
ALTER TABLE zomato1 RENAME COLUMN `ï»¿RestaurantID` TO  RestaurantID;

-- 1. Build a country Map Table
CREATE TABLE country_map (
    CountryCode INT PRIMARY KEY,
    CountryName VARCHAR(50)
);

INSERT INTO country_map VALUES 
(1,'India'),
(14,'Australia'),
(30,'Brazil'),
(37,'Canada'),
(94,'Indonesia'),
(148,'New Zealand'),
(162,'Philippines'),
(166,'Qatar'),
(184,'Singapore'),
(189,'South Africa'),
(191,'Sri Lanka'),
(208,'Turkey'),
(214,'UAE'),
(215,'United Kingdom'),
(216,'United States');

SELECT * FROM  country_map;


/* 2. Build a Calendar Table using the Column Datekey
  Add all the below Columns in the Calendar Table using the Formulas.
   A.Year
   B.Monthno
   C.Monthfullname
   D.Quarter(Q1,Q2,Q3,Q4)
   E. YearMonth ( YYYY-MMM)
   F. Weekdayno
   G.Weekdayname
   H.FinancialMOnth ( April = FM1, May= FM2  …. March = FM12)
   I. Financial Quarter ( Quarters based on Financial Month)*/
    CREATE TABLE calendar AS
    SELECT DISTINCT  `Date` AS FullDate, YEAR(`Date`) AS Year,
    MONTH(`Date`) AS MonthNo, MONTHNAME(`Date`) AS MonthFullName,
    CONCAT('Q', QUARTER(`Date`)) AS Quarter,
    DATE_FORMAT(`Date`, '%Y-%b') AS YearMonth, WEEKDAY(`Date`)+1 AS WeekdayNo, DAYNAME(`Date`) AS WeekdayName,
	CASE
        WHEN MONTH(`Date`) >= 4 THEN MONTH(`Date`) - 3
        ELSE MONTH(`Date`) + 9
    END AS FinancialMonth,
    CASE
        WHEN MONTH(`Date`) BETWEEN 4 AND 6 THEN 'FQ1'
        WHEN MONTH(`Date`) BETWEEN 7 AND 9 THEN 'FQ2'
        WHEN MONTH(`Date`) BETWEEN 10 AND 12 THEN 'FQ3'
        ELSE 'FQ4'
    END AS FinancialQuarter

    FROM zomato1;

SELECT * FROM  calendar
ORDER BY FullDate asc ;

-- 3.Find the Numbers of Resturants based on City and Country.
SELECT CountryCode,Country,city ,count(RestaurantID)
FROM zomato1
GROUP BY CountryCode,Country,city
ORDER BY CountryCode ASC,city asc ;

-- 4.Numbers of Resturants opening based on Year , Quarter , Month
SELECT  YEAR(`Date`) AS Year, CONCAT('Q', QUARTER(`Date`)) AS QUARTER,
MONTHNAME(`Date`) AS Month, COUNT(RestaurantID) AS RestaurantsOpened
FROM zomato1
GROUP BY YEAR(`Date`), CONCAT('Q', QUARTER(`Date`)), MONTHNAME(`Date`)
ORDER BY YEAR(`Date`),CONCAT('Q', QUARTER(`Date`)),RestaurantsOpened DESC;

-- 5. Count of Resturants based on Average Ratings
SELECT Rating, Count(RestaurantID) as `Total Restaurants`
FROM zomato1
GROUP BY Rating
ORDER BY Rating ;

-- 6. Create buckets based on Average Price of reasonable size and find out how many resturants falls in each buckets
SELECT  CASE
          WHEN Average_Cost_for_two < 500 THEN 'Low (<500)'
		  WHEN Average_Cost_for_two BETWEEN 500 AND 1000 THEN 'Medium (500-1000)'
          WHEN Average_Cost_for_two BETWEEN 1001 AND 2000 THEN 'High (1000-2000)'
         ELSE 'Premium (>2000)'
    END AS PriceBucket,
    Count(RestaurantID) AS TotalRestaurants
FROM zomato1
GROUP BY PriceBucket;

-- 7. Percentage of Resturants based on "Has_Table_booking"
SELECT  Has_Table_booking,  COUNT(*) * 100.0 / (SELECT COUNT(*) FROM zomato1) AS Percentage
FROM zomato1
GROUP BY Has_Table_booking;

-- 8.Percentage of Resturants based on "Has_Online_delivery"
SELECT  Has_Online_delivery,  COUNT(*) * 100.0 / (SELECT COUNT(*) FROM zomato1) AS Percentage
FROM zomato1
GROUP BY Has_Online_delivery;

SELECT * FROM zomato1;











