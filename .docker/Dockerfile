FROM centos:7
MAINTAINER "Michael Smith" <michael.smith@vml.com>

ENV container docker

RUN yum -y update && yum clean all
RUN yum -y install wget; yum clean all

RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

RUN yum -y update && yum clean all
RUN yum -y install httpd php55w php55w-gd php55w-mysql php55w-opcache mod_ssl openssl; yum clean all

COPY config/httpd/httpd.conf /etc/httpd/conf/httpd.conf

COPY ssl/ca.crt /etc/pki/tls/certs/localhost.crt
COPY ssl/ca.key /etc/pki/tls/private/localhost.key
COPY ssl/ca.csr /etc/pki/tls/private/localhost.csr

EXPOSE 80 443

ADD run-httpd.sh /run-httpd.sh
RUN chmod -v +x /run-httpd.sh

CMD ["/run-httpd.sh"]