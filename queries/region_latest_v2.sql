# Region latest

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
		OR STR_TO_DATE(date, "%Y-%m-%d") = (SELECT MAX(STR_TO_DATE(date, "%Y-%m-%d"))-1 FROM ts)) s1
	WHERE date = (SELECT MAX(STR_TO_DATE(date, "%Y-%m-%d")) FROM ts)
	GROUP BY 1, 2)) s2
INTO OUTFILE 'C:/Users/Neil/Documents/Projects/COVID-19/output/region_latest.csv' 
FIELDS ENCLOSED BY '"' 
TERMINATED BY ',' 
ESCAPED BY '"' 
LINES TERMINATED BY '\r\n'
;