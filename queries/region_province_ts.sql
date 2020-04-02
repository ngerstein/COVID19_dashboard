# Region/Province latest
SELECT * FROM
(SELECT "date", "region/province", "lat", "long", "confirmed", "deaths", "recovered", "active"
UNION ALL
(SELECT STR_TO_DATE(date, "%Y-%m-%d") AS date,
CASE WHEN `Province/State`="" THEN `Country/Region` ELSE CONCAT(`Province/State`, ", ", `Country/Region`) END AS `region/province`,
lat, `long`, confirmed, deaths, recovered, confirmed - deaths - recovered AS active
FROM ts
WHERE STR_TO_DATE(date, "%Y-%m-%d") >= (SELECT DATE_SUB(MAX(STR_TO_DATE(date, "%Y-%m-%d")), INTERVAL 45 DAY) FROM ts))) s1
INTO OUTFILE 'C:/Users/Neil/Documents/Projects/COVID-19/output/region_province_ts.csv' 
FIELDS ENCLOSED BY '"' 
TERMINATED BY ',' 
ESCAPED BY '' 
LINES TERMINATED BY '\r\n'
;