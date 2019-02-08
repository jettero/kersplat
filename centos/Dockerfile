FROM centos:latest
WORKDIR /root
ENV HOME=/root

#ENV http_proxy=http://PROXY_IP:PROXY_PORT/
#ENV https_proxy=http://PROXY_IP:PROXY_PORT/
ENV PY_V=2.7.14
ENV PY_B=$HOME/.pyenv/versions/$PY_V/bin
ENV PY=$PY_B/python PIP=$PY_B/pip

RUN yum -y install \
        git wget vim python-setuptools net-tools iproute strace \
        gcc make zlib-devel bzip2 bzip2-devel readline-devel sqlite \
        sqlite-devel openssl-devel xz xz-devel libffi-devel \
        ; \
    wget https://pkg.osquery.io/rpm/osquery-3.3.0-1.linux.x86_64.rpm; \
    rpm -i osquery-3.3.0-1.linux.x86_64.rpm; \
    rm     osquery-3.3.0-1.linux.x86_64.rpm; \
    yum clean all ; rm -rf /var/cache/yum

COPY requirements.txt requirements.txt
RUN curl https://pyenv.run | bash
RUN eval "$(/root/.pyenv/bin/pyenv init -)"; /root/.pyenv/bin/pyenv install $PY_V
RUN $PIP install --upgrade pip urllib3 requests; rm -rf ~/.cache/pip
RUN $PIP install --upgrade -r requirements.txt;  rm -rf ~/.cache/pip
RUN mkdir -vp /hubble /hubblestack_data

ENV http_proxy= https_proxy=

COPY docker-entrypoint.sh /
ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "bash", "-o", "vi" ]
