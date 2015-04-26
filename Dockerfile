# silverlock/supervisord
#
# VERSION       v1.0
FROM debian:jessie
MAINTAINER Matt Silverlock matt@eatsleeprepeat.net

# Install and setup project dependencies
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y lsb-release supervisor locales

# Configure locales
RUN dpkg-reconfigure locales && \
    locale-gen C.UTF-8 && \
    /usr/sbin/update-locale LANG=C.UTF-8

ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Supervisor will import all *.conf files under /etc/supervisor/conf.d/*
RUN mkdir -p /etc/supervisor/conf.d/
COPY supervisord.conf /etc/supervisor/supervisord.conf

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]

EXPOSE 9001

