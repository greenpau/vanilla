FROM centos:latest

LABEL maintainer="Paul Greenberg"

RUN rpm -Va --nofiles --nodigest
RUN rpm -e --nodeps bind-license
RUN yum -y install bind-utils openssh-server openssh-clients \
    iproute tshark tcpdump telnet nmap-ncat traceroute \
    net-tools mailx

COPY app/ /app
RUN cd /app && tar xvzf caddy.tar.gz && mv caddy /usr/bin/
WORKDIR /app

ENTRYPOINT ["/app/init.sh"]
# CMD is ignored when a command is being passed
CMD ["/usr/bin/caddy", "-conf", "/etc/caddy/Caddyfile"]
