# Region/Province latest
SELECT * FROM
(SELECT "date", "region/province", "lat", "long", "confirmed", "deaths", "recovered", "active"
UNION ALL
(SELECT STR_TO_DATE(date, "%m/%d/%y") AS date,
CASE WHEN `Province/State`="" THEN `Country/Region` ELSE CONCAT(`Province/State`, ", ", `Country/Region`) END AS `region/province`,
lat, `long`, 
CASE WHEN confirmed = 0 THEN NULL ELSE confirmed END AS confirmed,
CASE WHEN deaths = 0 THEN NULL ELSE deaths END AS deaths,
CASE WHEN recovered = 0 THEN NULL ELSE recovered END AS recovered,
CASE WHEN confirmed - deaths - recovered = 0 THEN NULL ELSE confirmed - deaths - recovered END AS active
FROM ts
WHERE STR_TO_DATE(date, "%m/%d/%y") = (SELECT MAX(STR_TO_DATE(date, "%m/%d/%y")) AS date FROM ts))) s1
INTO OUTFILE 'C:/Users/Neil/Documents/Projects/COVID-19/output/region_province_latest.csv' 
FIELDS ENCLOSED BY '"' 
TERMINATED BY ',' 
ESCAPED BY '' 
LINES TERMINATED BY '\r\n'
;