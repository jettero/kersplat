ARG OSI=centos:latest
FROM $OSI
WORKDIR /root
ENV HOME=/root

RUN yum makecache \
 && yum -y update \
 && yum -y install yum git wget vim \
 && yum -y install net-tools iproute \
 && yum -y install strace gcc make zlib-devel bzip2 \
 && yum -y install bzip2-devel readline-devel \
 && yum -y install sqlite sqlite-devel \
 && yum -y install openssl-devel xz xz-devel \
 && yum -y install libffi-devel graphviz \
 && yum clean all \
 && rm -rf /var/cache/yum anaconda*

RUN wget https://pkg.osquery.io/rpm/osquery-3.3.0-1.linux.x86_64.rpm \
 && rpm -i osquery-3.3.0-1.linux.x86_64.rpm \
 && yum clean all && rm -rf /var/cache/yum anaconda* osquery*.rpm

ARG PY_V=3.6.10

ENV PYENV_INSTALLER_URL=https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer
ENV PYENV_ROOT=/usr/local/pyenv
ENV PATH=$PYENV_ROOT/bin:$PATH

RUN umask 022
RUN curl -s -S -L "$PYENV_INSTALLER_URL" -o /usr/bin/pyenv-installer; chmod 0755 /usr/bin/pyenv-installer
RUN /usr/bin/pyenv-installer
COPY requirements.txt requirements.txt
RUN eval $(pyenv init -); pyenv install $PY_V
RUN eval $(pyenv init -); pyenv shell   $PY_V; pip install --upgrade pip                 && rm -rf ~/.cache/pip
RUN eval $(pyenv init -); pyenv shell   $PY_V; pip install --upgrade urllib3 requests    && rm -rf ~/.cache/pip
RUN eval $(pyenv init -); pyenv shell   $PY_V; pip install --upgrade -r requirements.txt && rm -rf ~/.cache/pip
RUN eval $(pyenv init -); pyenv shell   $PY_V; pip install --upgrade pip-tools ipython   && rm -rf ~/.cache/pip

COPY kersplat.sh /etc/profile.d/kersplat.sh

RUN groupadd -fg 1000 kersplat; \
    useradd -os /bin/bash -d /work -m -g 1000 -u 1000 kersplat

copy bashrc /root/.bashrc
copy bashrc /work/.bashrc
COPY docker-entrypoint.sh /

RUN chown kersplat:kersplat -R $PYENV_ROOT /work; \
    chmod 0755 /docker-entrypoint.sh; \
    chmod 0644 /etc/profile.d/kersplat.sh

WORKDIR /work
ENV HOME=/work
USER kersplat

ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "bash", "-o", "vi" ]
