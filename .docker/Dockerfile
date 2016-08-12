FROM centos:7
MAINTAINER "Michael Smith" <michael.smith@vml.com>

ENV container docker

RUN yum -y install httpd; yum clean all;

COPY config/httpd/httpd.conf /etc/httpd/conf/httpd.conf

#RUN service httpd start
RUN apachectl

EXPOSE 80

CMD ["/usr/sbin/init"]