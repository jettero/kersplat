FROM centos:latest
WORKDIR /root
ENV HOME=/root

RUN yum -y install \
        git wget vim python-setuptools net-tools iproute strace \
        gcc make zlib-devel bzip2 bzip2-devel readline-devel sqlite \
        sqlite-devel openssl-devel xz xz-devel libffi-devel \
        ; \
    wget https://pkg.osquery.io/rpm/osquery-3.3.0-1.linux.x86_64.rpm; \
    rpm -i osquery-3.3.0-1.linux.x86_64.rpm; \
    rm     osquery-3.3.0-1.linux.x86_64.rpm; \
    yum clean all ; rm -rf /var/cache/yum; \
    rm anaconda*

ENV PY_V=2.7.14
ENV PYENV_INSTALLER_URL=https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer
ENV PYENV_ROOT=/usr/local/pyenv
ENV PATH=$PYENV_ROOT/bin:$PATH

RUN umask 022
RUN curl -s -S -L "$PYENV_INSTALLER_URL" -o /usr/bin/pyenv-installer; chmod 0755 /usr/bin/pyenv-installer
RUN /usr/bin/pyenv-installer
RUN eval "$(pyenv init -)"; pyenv install $PY_V
RUN eval "$(pyenv init -)"; pyenv local 2.7.14; pyenv shell 2.7.14

COPY kersplat.sh /etc/profile.d/kersplat.sh
COPY requirements.txt requirements.txt
RUN source /etc/profile.d/kersplat.sh; \
     pip install --upgrade pip urllib3 requests; \
     pip install --upgrade -r requirements.txt; \
     pip install pip-tools ipython; \
     rm -rf ~/.cache/pip requirements.txt

RUN chown 1000:1000 -R $PYENV_ROOT

copy bashrc /root/.bashrc
COPY docker-entrypoint.sh /
ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "bash", "-o", "vi" ]
