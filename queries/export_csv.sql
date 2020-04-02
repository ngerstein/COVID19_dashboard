SELECT * FROM daily_reports
INTO OUTFILE 'C:/Users/Neil/Documents/Projects/COVID-19/test.csv' 
FIELDS ENCLOSED BY '"' 
TERMINATED BY ',' 
ESCAPED BY '"' 
LINES TERMINATED BY '\r\n'
;