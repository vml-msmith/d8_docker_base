FROM centos:7
MAINTAINER "Michael Smith" <michael.smith@vml.com>

ENV container docker

RUN yum -y update && yum clean all
RUN yum -y install wget; yum clean all

RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

RUN yum -y update && yum clean all
RUN yum -y install httpd php56w php56w-gd php56w-mysql php56w-opcache php56w-xml mod_ssl openssl; yum clean all

# Change the timezone to America/Chicago, regardless if it's turned off or not.
RUN sed -i 's,date.timezone =,date.timezone = America/Chicago,g' etc/php.ini

# Turn on the date.timezone setting in php.ini.
RUN sed -i 's/;date.timezone/date.timezone/g' /etc/php.ini

COPY config/httpd/httpd.conf /etc/httpd/conf/httpd.conf

# enable SSL by copying over crt, key and csr files.
COPY ssl/ca.crt /etc/pki/tls/certs/localhost.crt
COPY ssl/ca.key /etc/pki/tls/private/localhost.key
COPY ssl/ca.csr /etc/pki/tls/private/localhost.csr

EXPOSE 80 443

ADD run-httpd.sh /run-httpd.sh
RUN chmod -v +x /run-httpd.sh

CMD ["/run-httpd.sh"]