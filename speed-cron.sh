#!/bin/bash
# speed-cron.sh
DATE=$(date '+%Y-%m-%d %H:%M:%S')
RESULT=$(/usr/local/bin/speedtest --simple | awk -F': ' '{print $2}' | paste -sd "," -)
PING=$(echo "$RESULT" | cut -d, -f1)
DOWNLOAD=$(echo "$RESULT" | cut -d, -f2)
UPLOAD=$(echo "$RESULT" | cut -d, -f3)

echo "$DATE,$PING,$DOWNLOAD,$UPLOAD" >> /var/www/html/speedtest_results.csv

# Convert CSV to JSON
echo "[" > /var/www/html/speedtest_results.json
tail -n +1 /var/www/html/speedtest_results.csv | awk -F, '
BEGIN { ORS=""; }
{
    printf "%s{\"date\":\"%s\",\"ping\":%s,\"download\":%s,\"upload\":%s}",
           (NR>1 ? "," : ""), $1, $2, $3, $4;
}
END { print "]"; }
' >> /var/www/html/speedtest_results.json
