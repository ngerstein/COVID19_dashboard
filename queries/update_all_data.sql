# Update ts table - drop the entire ts table and create a new one

DROP table ts;
CREATE TABLE `covid19`.`ts` (`Country/Region` text, `Lat` text, `Long` text, `Province/State` text, `confirmed` text, `date` text, `deaths` text, `recovered` text);

LOAD DATA INFILE 'C:/Users/Neil/Documents/Projects/COVID-19/COVID-19/ts.csv' 
INTO TABLE ts
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
;

ALTER TABLE ts MODIFY Lat DOUBLE;
ALTER TABLE ts MODIFY `Long` DOUBLE;
ALTER TABLE ts MODIFY confirmed INT;
ALTER TABLE ts MODIFY deaths INT;
ALTER TABLE ts MODIFY recovered INT;

CALL covid19_data();