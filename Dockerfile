FROM alpine:latest

RUN apk add --no-cache \
    bash \
    lighttpd \
    speedtest-cli \
    curl \
    dcron

RUN mkdir -p /var/www/html

COPY index.html /var/www/html/index.html

COPY speed-cron.sh /usr/local/bin/speed-cron.sh
RUN chmod +x /usr/local/bin/speed-cron.sh

RUN touch /var/www/html/speedtest_results.csv /var/www/html/speedtest_results.json

RUN chmod -R 755 /var/www/html && chown -R lighttpd:lighttpd /var/www/html

RUN echo "server.document-root = \"/var/www/html\"" > /etc/lighttpd/lighttpd.conf && \
    echo "dir-listing.activate = \"enable\"" >> /etc/lighttpd/lighttpd.conf && \
    echo "server.port = 80" >> /etc/lighttpd/lighttpd.conf

RUN echo "*/5 * * * * /usr/local/bin/speed-cron.sh" > /etc/crontabs/root

EXPOSE 80

# Start cron and lighttpd when the container runs
CMD ["sh", "-c", "crond && lighttpd -D -f /etc/lighttpd/lighttpd.conf"]
