#!/bin/bash
# speed-cron.sh

# Perform the speed test
DATE=$(date '+%Y-%m-%d %H:%M:%S')
RESULT=$(/usr/bin/speedtest --simple | awk -F': ' '{print $2}' | paste -sd "," -)
PING=$(echo "$RESULT" | cut -d, -f1)
DOWNLOAD=$(echo "$RESULT" | cut -d, -f2)
UPLOAD=$(echo "$RESULT" | cut -d, -f3)

# Append to CSV if all fields are valid
if [ -n "$PING" ] && [ -n "$DOWNLOAD" ] && [ -n "$UPLOAD" ]; then
    echo "$DATE,$PING,$DOWNLOAD,$UPLOAD" >> /var/www/html/speedtest_results.csv
fi

# Convert CSV to JSON
echo "[" > /var/www/html/speedtest_results.json
awk -F, 'NF == 4 && $1 != "" && $2 != "" && $3 != "" && $4 != "" {
    gsub(" ms", "", $2); # Remove 'ms' from ping
    gsub(" Mbit/s", "", $3); # Remove 'Mbit/s' from download
    gsub(" Mbit/s", "", $4); # Remove 'Mbit/s' from upload
    printf "%s{\"date\":\"%s\",\"ping\":%s,\"download\":%s,\"upload\":%s}",
           (NR>1 ? "," : ""), $1, $2, $3, $4;
}' /var/www/html/speedtest_results.csv >> /var/www/html/speedtest_results.json
echo "]" >> /var/www/html/speedtest_results.json
