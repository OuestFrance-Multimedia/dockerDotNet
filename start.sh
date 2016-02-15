#!/bin/bash

# Setup git variables
if [ ! -z "$GIT_EMAIL" ]; then
 git config --global user.email "$GIT_EMAIL"
fi
if [ ! -z "$GIT_NAME" ]; then
 git config --global user.name "$GIT_NAME"
 git config --global push.default simple
fi

# Pull down code form git for our site!
if [ ! -z "$GIT_REPO" ]; then
  chmod -R 700 /root/.ssh

  if [ ! -f /root/.ssh/config ]; then
    echo "/root/.ssh/config doesn't exists: creating it with StrictHostKeyChecking no"
    echo -e "Host github.com\n\tStrictHostKeyChecking no\n" > /root/.ssh/config
  else
    echo "/root/.ssh/config exists: nothing to do"
  fi

  rm -rf /data/www
  if [ ! -z "$GIT_BRANCH" ]; then
    git clone -b $GIT_BRANCH $GIT_REPO /data/www/
  else
    git clone $GIT_REPO /data/www/
  fi
  #chown -Rf nginx.nginx /usr/share/nginx/*
fi

chown -R nginx:nginx /data


exec sudo -u nginx /usr/bin/fastcgi-mono-server4 --applications=/:/data/www --socket=unix:/data/nginxSock/unix.socket --printlog=True 

