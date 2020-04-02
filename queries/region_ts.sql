# Province/Region level (most fine). If province/state data is available, it is on that level, otherwise it is the whole country/region
SELECT * FROM (
SELECT "region", "lat", "long", "date", "confirmed", "deaths", "recovered"
UNION ALL
(SELECT
CASE WHEN `Province/State`="" THEN `Country/Region` ELSE CONCAT(`Province/State`, ", ", `Country/Region`) END AS region,
lat, `long`, STR_TO_DATE(date, "%m/%d/%y") AS date, confirmed, deaths, recovered FROM ts
ORDER BY `Country/Region`, `Province/State`, date)
) s1
INTO OUTFILE 'C:/Users/Neil/Documents/Projects/COVID-19/output/region_ts.csv' 
FIELDS ENCLOSED BY '"' 
TERMINATED BY ',' 
ESCAPED BY '"' 
LINES TERMINATED BY '\r\n'
;