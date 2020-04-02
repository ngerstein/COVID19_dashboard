DELIMITER //
 
CREATE PROCEDURE covid19_data()
BEGIN
# Update ts table - drop the entire ts table and create a new one
SELECT * FROM
(SELECT "Date", "Region", "Lat", "Long", "Confirmed", "Deaths", "Recovered", "Active", "Change"
UNION ALL
	(SELECT date, region, ROUND(AVG(lat),2) AS lat, ROUND(AVG(`long`),2) AS `long`, ROUND(SUM(confirmed),0) AS confirmed, 
	ROUND(SUM(deaths),0) AS deaths, ROUND(SUM(recovered),0) AS recovered, ROUND(SUM(active),0) AS active, ROUND(SUM(d_active),0) AS d_active 
	FROM
		(SELECT STR_TO_DATE(date, "%Y-%m-%d") AS date, 
		`Country/Region` AS region, `Province/State`,
		lat, `long`, confirmed, deaths, recovered, confirmed - deaths - recovered AS active,
		confirmed - deaths - recovered -
		(LAG(confirmed, 1) OVER(PARTITION BY `Country/Region`, `Province/State` ORDER BY STR_TO_DATE(date, "%Y-%m-%d")) -
		LAG(deaths, 1) OVER(PARTITION BY `Country/Region`, `Province/State` ORDER BY STR_TO_DATE(date, "%Y-%m-%d")) -
		LAG(recovered, 1) OVER(PARTITION BY `Country/Region`, `Province/State` ORDER BY STR_TO_DATE(date, "%Y-%m-%d")))
		AS d_active
		FROM ts
		WHERE STR_TO_DATE(date, "%Y-%m-%d") = (SELECT MAX(STR_TO_DATE(date, "%Y-%m-%d")) FROM ts)
		OR STR_TO_DATE(date, "%Y-%m-%d") = (SELECT DATE_SUB(MAX(STR_TO_DATE(date, "%Y-%m-%d")), INTERVAL 1 DAY) FROM ts)) s1
	WHERE date = (SELECT MAX(STR_TO_DATE(date, "%Y-%m-%d")) FROM ts)
	GROUP BY 1, 2)) s2
INTO OUTFILE 'C:/Users/Neil/Documents/Projects/COVID-19/output/region_latest.csv' 
FIELDS ENCLOSED BY '"' 
TERMINATED BY ',' 
ESCAPED BY '"' 
LINES TERMINATED BY '\r\n'
;

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

# Time series chart
SELECT * FROM
(SELECT "date", "series", "num", "ln_num"
UNION ALL
SELECT STR_TO_DATE(date, "%Y-%m-%d") AS date, "Total Recovered" AS series, ROUND(SUM(recovered),0) AS num, 
CASE WHEN SUM(recovered)=0 THEN NULL ELSE ROUND(LOG(SUM(recovered)),3) END AS ln_num FROM ts GROUP BY 1
UNION
SELECT date, location AS series, ROUND(SUM(confirmed),0) AS num, 
CASE WHEN SUM(recovered)=0 THEN NULL ELSE ROUND(LOG(SUM(confirmed)),3) END AS ln_num FROM
(SELECT `Country/Region` AS region, STR_TO_DATE(date, "%Y-%m-%d") AS date, 
SUM(confirmed) AS confirmed, SUM(deaths) AS deaths, SUM(recovered) AS recovered,
CASE 
WHEN `Country/Region` = "China" THEN `Country/Region` 
WHEN `Country/Region` = "US" THEN `Country/Region`
WHEN `Country/Region` = "Italy" THEN `Country/Region`
ELSE "Rest of World" END AS location 
FROM ts
GROUP BY 1, 2) s1
GROUP BY 1, 2) s2
INTO OUTFILE 'C:/Users/Neil/Documents/Projects/COVID-19/output/ts_chart.csv' 
FIELDS ENCLOSED BY '"' 
TERMINATED BY ',' 
ESCAPED BY '' 
LINES TERMINATED BY '\r\n'
;

END //
 
DELIMITER ;

#CALL covid19_data();