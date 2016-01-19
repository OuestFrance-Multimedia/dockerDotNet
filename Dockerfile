FROM debian:jessie

RUN apt-get update \
  && apt-get install mono-fastcgi-server4 -y

RUN apt-get install git -y
RUN apt-get install sudo -y


RUN groupadd -r nginx -g 400 && \
  useradd -u 400 -r -g nginx -d /nonexistent -s /bin/false -c "nginx user" nginx

RUN mkdir -p /data/www
RUN mkdir -p /data/nginxSock

ADD ./start.sh /start.sh
RUN chmod 755 /start.sh

CMD ["/bin/bash", "/start.sh"]

