FROM centos:7
MAINTAINER "Michael Smith" <michael.smith@vml.com>

ENV container docker

RUN yum -y update && yum clean all
RUN yum -y install httpd php php-mysql; yum clean all

COPY config/httpd/httpd.conf /etc/httpd/conf/httpd.conf


EXPOSE 80

ADD run-httpd.sh /run-httpd.sh
RUN chmod -v +x /run-httpd.sh

CMD ["/run-httpd.sh"]