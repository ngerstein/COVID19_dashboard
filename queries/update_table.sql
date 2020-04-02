/* Create a temporary table with new data */
DROP TABLE temp_update;
CREATE TEMPORARY TABLE temp_update 
(`Province/State` VARCHAR(50), `Country/Region` VARCHAR(50), `Last Update` VARCHAR(19), 
Confirmed int, Deaths int, Recovered int, Latitude double, Longitued double);

/* Load data from CSV into temporary table */
LOAD DATA INFILE 'C:/Users/Neil/Documents/Projects/COVID-19/COVID-19-master/csse_covid_19_data/csse_covid_19_daily_reports/03-14-2020.csv' 
INTO TABLE temp_update
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

# Append data into existing table
INSERT INTO daily_reports (`Province/State`, `Country/Region`, `Last Update`, Confirmed, Deaths, Recovered, Latitude, Longitude)
SELECT * FROM temp_update;

SELECT * FROM daily_reports ORDER BY `Country/Region`, `Province/State`;
