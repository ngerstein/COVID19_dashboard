SELECT `Province/State`, `Country/Region`, Lat, `Long`, `1/22/20` AS confirmed, "1/22/20" AS date FROM confirmed
UNION
SELECT `Province/State`, `Country/Region`, Lat, `Long`, `1/23/20` AS confirmed, "1/23/20" AS date FROM confirmed
ORDER BY `Country/Region`, `Province/State` 
;