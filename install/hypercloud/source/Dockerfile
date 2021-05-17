FROM python:3.7-alpine

WORKDIR /root/hyperdata_installer

RUN apk --no-cache add curl bash openssl

# install helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 \
    && chmod +x get_helm.sh && ./get_helm.sh

COPY requirements.txt .

# install python package
RUN pip install -r requirements.txt

COPY ./helm .