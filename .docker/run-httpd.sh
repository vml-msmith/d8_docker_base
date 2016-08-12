#!/bin/bash

# Make sure not to be confused by old incompletely shutdown httpd.
rm  -rf /run/httpd/* /tmp/httpd*

exec /usr/sbin/apachectl -DFOREGROUND
