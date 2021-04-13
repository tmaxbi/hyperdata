FROM python:3.7-buster

WORKDIR /root/hyperdata-installer/prerequisites

# install helm
COPY ./prerequisites .
RUN tar -zxvf helm-v3.4.2-linux-amd64.tar.gz
RUN mv linux-amd64/helm /usr/local/bin/helm

# install python package
RUN pip install --user ./python_packages/kubernetes-12.0.1.tar.gz

WORKDIR /root/hyperdata-installer/helm
COPY ./helm .