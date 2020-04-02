# Update ts table - drop the entire ts table and create a new one

DROP table ts;
CREATE TABLE `covid19`.`ts` (`Country/Region` text, `Lat` text, `Long` text, `Province/State` text, `confirmed` text, `date` text, `deaths` text, `recovered` text);

LOAD DATA INFILE 'C:/Users/Neil/Documents/Projects/COVID-19/ts.csv' 
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


DROP table counties;
CREATE TABLE `covid19`.`counties` (`County` text, `Province/State` text, `Country/Region` text, `Lat` double, `Long` double, `confirmed` int, `deaths` int, `recovered` int, `date` text);

LOAD DATA INFILE 'C:/Users/Neil/Documents/Projects/COVID-19/counties.csv' 
INTO TABLE counties
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;