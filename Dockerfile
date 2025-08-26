FROM haproxy:latest

COPY haproxy.cfg      /usr/local/etc/haproxy/haproxy.cfg
COPY ip-whitelist.txt /usr/local/etc/haproxy/ip-whitelist.txt

# Uncomment the following lines to install debugging tools.
# 
# USER root
# RUN apt-get update -y; apt-get install -y procps net-tools strace curl host
# USER haproxy
