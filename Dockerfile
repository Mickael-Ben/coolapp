FROM ubuntu:latest

ENV SIAB_USERCSS="Normal:+/etc/shellinabox/options-enabled/00+Black-on-White.css,Reverse:-/etc/shellinabox/options-enabled/00_White-On-Black.css;Colors:+/etc/shellinabox/options-enabled/01+Color-Terminal.css,Monochrome:-/etc/shellinabox/options-enabled/01_Monochrome.css" \
    SIAB_PORT=4200 \
    SIAB_ADDUSER=true \
    SIAB_USER=guest \
    SIAB_USERID=1000 \
    SIAB_GROUP=guest \
    SIAB_GROUPID=1000 \
    SIAB_PASSWORD=putsafepasswordhere \
    SIAB_SHELL=/bin/bash \
    SIAB_HOME=/home/guest \
    SIAB_SUDO=false \
    SIAB_SSL=true \
    SIAB_SERVICE=/:LOGIN \
    SIAB_PKGS=none \
    SIAB_SCRIPT=none

RUN apt-get update && apt-get install -y openssl curl openssh-client sudo shellinabox && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    ln -sf '/etc/shellinabox/options-enabled/00+Black on White.css' \
      /etc/shellinabox/options-enabled/00+Black-on-White.css && \
    ln -sf '/etc/shellinabox/options-enabled/00_White On Black.css' \
      /etc/shellinabox/options-enabled/00_White-On-Black.css && \
    ln -sf '/etc/shellinabox/options-enabled/01+Color Terminal.css' \
      /etc/shellinabox/options-enabled/01+Color-Terminal.css

EXPOSE 4200

VOLUME /etc/shellinabox /var/log/supervisor /home

ADD assets/entrypoint.sh /usr/local/sbin/

RUN adduser httpuser
RUN usermod --password $(echo 0c00lP@ssW0rD1! | openssl passwd -1 -stdin) httpuser

RUN chown httpuser:httpuser /home/httpuser

RUN adduser marc
RUN usermod --password $(echo m@rcp@ssw0rd | openssl passwd -1 -stdin) marc

ADD assets/simple_server.jar /home/httpuser/simple_server.jar
ADD assets/jdk-8u20-linux-x64.tar.gz /home/httpuser/jdk-8u20-linux-x64.tar.gz
ADD assets/.secret /home/httpuser/.secret

RUN chown httpuser:httpuser /home/httpuser/simple_server.jar 
RUN chown httpuser:httpuser /home/httpuser/.secret

RUN chmod 400 /home/httpuser/simple_server.jar
RUN chmod 400 /home/httpuser/.secret

RUN apt update
RUN apt-get install -y netcat

ENTRYPOINT ["entrypoint.sh"]
CMD ["shellinabox"]
