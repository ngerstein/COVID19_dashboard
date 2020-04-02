LOAD DATA INFILE 'C:/Users/Neil/Documents/Projects/COVID-19/COVID-19-master/csse_covid_19_data/csse_covid_19_daily_reports/03-14-2020.csv' 
INTO TABLE daily_reports
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;