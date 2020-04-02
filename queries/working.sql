SELECT * FROM (
SELECT "Province/State", "Country/Region", "Lat", "Long", "date", "confirmed", "deaths", "recovered"
UNION ALL
(SELECT `Province/State`, `Country/Region`, Lat, `Long`, STR_TO_DATE(date, "%m/%d/%y") AS date, confirmed, deaths, recovered FROM ts
ORDER BY `Country/Region`, `Province/State`, date)
) s1
INTO OUTFILE 'C:/Users/Neil/Documents/Projects/COVID-19/output/full_ts.csv' 
FIELDS ENCLOSED BY '"' 
TERMINATED BY ',' 
ESCAPED BY '"' 
LINES TERMINATED BY '\r\n'
;