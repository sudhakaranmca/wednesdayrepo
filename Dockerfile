FROM php:5-apache
COPY ./index.php /var/www/html/index.php
COPY ./resourcetest.sh /tmp/resourcetest.sh
RUN ["chmod", "a+rx", "/var/www/html/index.php"] \
    ["chmod", "+x", "/tmp/resourcetest.sh"]
#ENTRYPOINT [ "/bin/sh", "-c" ]
#CMD [ "/tmp/resourcetest.sh" ]
ENTRYPOINT ["sh", "/tmp/resourcetest.sh"]
