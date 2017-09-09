FROM python:3.6.2-alpine3.6
RUN pip install --upgrade \
    pip \
    awsebcli
RUN apk --update add \
    bash \
    git \
    openssh-client

ADD eb_deploy.sh .
RUN mkdir /var/tmp/workspace
WORKDIR /var/tmp/workspace
