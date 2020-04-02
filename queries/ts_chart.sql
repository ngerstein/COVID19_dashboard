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


