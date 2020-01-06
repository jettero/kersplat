ARG OSI=centos:7
FROM $OSI
WORKDIR /root
ENV HOME=/root

RUN yum -y install epel-release \
 && yum -y install \
     yum git wget vim \
     net-tools iproute \
     strace gcc make zlib-devel bzip2 \
     bzip2-devel readline-devel \
     sqlite sqlite-devel \
     openssl-devel xz xz-devel \
     libffi-devel graphviz \
     libgit2 libgit2-devel \
 && yum clean all \
 && rm -rf /var/cache/yum anaconda*

RUN wget https://pkg.osquery.io/rpm/osquery-3.3.0-1.linux.x86_64.rpm \
 && rpm -i osquery-3.3.0-1.linux.x86_64.rpm \
 && yum clean all && rm -rf /var/cache/yum anaconda* osquery*.rpm

ENV PYENV_INSTALLER_URL=https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer
ENV PYENV_ROOT=/usr/local/pyenv
ENV PATH=$PYENV_ROOT/bin:$PATH

RUN umask 022
RUN curl -s -S -L "$PYENV_INSTALLER_URL" -o /usr/bin/pyenv-installer; chmod 0755 /usr/bin/pyenv-installer
RUN /usr/bin/pyenv-installer

RUN eval "$(pyenv init -)"; pyenv install 3.6.10
RUN eval "$(pyenv init -)"; pyenv shell   3.6.10; pip install --upgrade pip && rm -rf ~/.cache/pip
RUN eval "$(pyenv init -)"; pyenv shell   3.6.10; pip install --upgrade urllib3 requests pip-tools ipython && rm -rf ~/.cache/pip

RUN eval "$(pyenv init -)"; pyenv install 2.7.16
RUN eval "$(pyenv init -)"; pyenv shell   2.7.16; pip install --upgrade pip && rm -rf ~/.cache/pip
RUN eval "$(pyenv init -)"; pyenv shell   2.7.16; pip install --upgrade urllib3 requests pip-tools ipython && rm -rf ~/.cache/pip

# NOTE: can't do 3.8.1 until salt-ssh resolves their 'distro' package problem
# in setup.py

# RUN eval "$(pyenv init -)"; pyenv install 3.8.1
# RUN eval "$(pyenv init -)"; pyenv shell   3.8.1; pip install --upgrade pip && rm -rf ~/.cache/pip
# RUN eval "$(pyenv init -)"; pyenv shell   3.8.1; pip install --upgrade urllib3 requests pip-tools ipython && rm -rf ~/.cache/pip

COPY requirements.txt requirements.txt

RUN eval "$(pyenv init -)"; pyenv shell 3.6.10; pip install --upgrade -r requirements.txt && rm -rf ~/.cache/pip
RUN eval "$(pyenv init -)"; pyenv shell 2.7.16; pip install --upgrade -r requirements.txt && rm -rf ~/.cache/pip
# RUN eval "$(pyenv init -)"; pyenv shell 3.8.1 ; pip install --upgrade -r requirements.txt && rm -rf ~/.cache/pip

RUN eval "$(pyenv init -)"; pyenv global 2.7.16; echo 2.7.16 > /etc/PY_V; chmod 0644 /etc/PY_V

COPY kersplat.sh /etc/profile.d/kersplat.sh

RUN groupadd -fg 1000 kersplat; \
    useradd -os /bin/bash -d /work -m -g 1000 -u 1000 kersplat

COPY bashrc /root/.bashrc
COPY bashrc /work/.bashrc
COPY docker-entrypoint.sh /

RUN chown -cR root:root /root
RUN chown kersplat:kersplat -cR /work; \
    chmod 0755 /docker-entrypoint.sh; \
    chmod 0644 /etc/profile.d/kersplat.sh

WORKDIR /work
ENV HOME=/work
USER kersplat

ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "bash", "-o", "vi" ]
