#IKEA Webserver
#©2023 Chello N.V. IKEA, LLC Kiss Kornél Inter IKEA Group.
#DEBIAN Base IMAGE
FROM debian:latest
#Working directory
WORKDIR /var/www/html
#Exposing the port numbers (HTTP/HTTPS/Webmin)
EXPOSE 80
EXPOSE 443
EXPOSE 10000
#Environment variables
ENV LANG en_US.utf8
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_RUN_USER www-data
ENV APACHE_LOG_DIR /ikea/ingka/
ENV APACHE_PID_FILE /var/run/apache2/apache2$SUFFIX.pid
ENV APACHE_RUN_GROUP www-data
#Get all packages, Make Log Directory, Make Error Directory
RUN apt-get update
RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
	&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
RUN mkdir /ikea/
RUN mkdir /ikea/ingka
RUN touch /ikea/ingka/logl.log
RUN apt-get update
RUN apt -y install apache2
RUN apt -y install php php-common
RUN apt -y install php-cli php-fpm php-json php-pdo php-mysql php-zip php-gd  php-mbstring php-curl php-xml php-pear php-bcmath
RUN apt -y install libapache2-mod-php
RUN apt-get install wget -y
RUN apt-get install  libapache2-mod-security2 -y
ADD page_default/Page_style/ Page_style/
RUN mkdir /var/www/html/error
#COPY Assets/Resources
COPY page_default/index.html /var/www/html
COPY apache2.conf /etc/apache2
COPY security.conf /etc/apache2/conf-available
COPY page_default/Page_style/css.css /var/www/html
COPY page_default/error404.php /var/www/html/error
COPY page_default/error403.php /var/www/html/error
COPY page_default/error401.php /var/www/html/error
COPY page_default/error500.php /var/www/html/error
COPY page_default/error502.php /var/www/html/error
COPY 000-default.conf /etc/apache2/sites-available
#Running Apache!
CMD ["apache2", "-D", "FOREGROUND"]