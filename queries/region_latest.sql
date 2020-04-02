# Region latest

SELECT * FROM
(SELECT "date", "region", "lat", "long", "confirmed", "deaths", "recovered", "active"
UNION ALL
(SELECT STR_TO_DATE(date, "%m/%d/%y") AS date,
`Country/Region` AS region,
ROUND(AVG(lat),2) AS lat, ROUND(AVG(`long`),2) AS `long`, ROUND(SUM(confirmed),0) AS confirmed, 
ROUND(SUM(deaths),0) AS deaths, ROUND(SUM(recovered),0) AS recovered, ROUND(SUM(confirmed - deaths - recovered)) AS active
FROM ts
WHERE STR_TO_DATE(date, "%m/%d/%y") = (SELECT MAX(STR_TO_DATE(date, "%m/%d/%y")) FROM ts)
GROUP BY `Country/Region`, 1)) s1
INTO OUTFILE 'C:/Users/Neil/Documents/Projects/COVID-19/output/region_latest.csv' 
FIELDS ENCLOSED BY '"' 
TERMINATED BY ',' 
ESCAPED BY '"' 
LINES TERMINATED BY '\r\n'
;