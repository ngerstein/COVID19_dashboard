SELECT `Province/State`, `Country/Region`, Lat, `Long`, 
CAST(CONCAT(year, "-", month, "-", day) AS DATE) AS date, 
confirmed, deaths, recovered FROM
(SELECT *, CONCAT('20',RIGHT(date, 2)) AS year,
CASE
WHEN LENGTH(SUBSTRING(SUBSTRING_INDEX(date, "/", 2), POSITION("/" IN SUBSTRING_INDEX(date, "/", 2))+1, LENGTH(SUBSTRING_INDEX(date, "/", 2)))) = 1
THEN CONCAT("0", SUBSTRING(SUBSTRING_INDEX(date, "/", 2), POSITION("/" IN SUBSTRING_INDEX(date, "/", 2))+1, LENGTH(SUBSTRING_INDEX(date, "/", 2))))
ELSE SUBSTRING(SUBSTRING_INDEX(date, "/", 2), POSITION("/" IN SUBSTRING_INDEX(date, "/", 2))+1, LENGTH(SUBSTRING_INDEX(date, "/", 2))) END AS day,
CASE
WHEN LENGTH(LEFT(date, POSITION("/" IN SUBSTRING_INDEX(date, "/", 2))-1)) = 1 THEN CONCAT("0", LEFT(date, POSITION("/" IN SUBSTRING_INDEX(date, "/", 2))-1))
ELSE LEFT(date, POSITION("/" IN SUBSTRING_INDEX(date, "/", 2))-1) END AS month
FROM ts) s1
ORDER BY 2, 1, 5 desc;

SELECT `Province/State`, `Country/Region`, Lat, `Long`, STR_TO_DATE(date, "%m/%d/%y") AS date, confirmed, deaths, recovered FROM ts;