# DockerSpeedTest

Automation and updates to https://blog.zsec.uk/weekend-monitor/ original script:
```
#!/bin/bash
# speed-cron.sh
# Monitors Speedtests of Home Broadband via logging
# Plans to add interactive monitoring + email notifications

echo "<p>"  >> /var/www/html/index.html
date >> /var/www/html/index.html
echo "<br>" >> /var/www/html/index.html
/usr/local/bin/speedtest --simple >>  /var/www/html/index.html
echo "</p><br>" >> /var/www/html/index.html
```

## Instructions
```
git clone https://github.com/ZephrFish/DockerSpeedTest/
cd DockerSpeedTest
docker build -t speedtest-web-enhanced .
docker run -d -p 8080:80 speedtest-web-enhanced
```
