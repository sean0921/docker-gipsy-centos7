FROM centos:7
MAINTAINER sean0921

RUN groupadd --gid 1000 user \
    && useradd -g user -s /bin/bash --uid 1000 user \
    && rm /etc/localtime \
    && ln -s /usr/share/zoneinfo/Asia/Taipei /etc/localtime

RUN yum update -y    \
    && yum clean all \
    && yum install --nogpgcheck -y \
       openmpi \
       redhat-lsb \
       bzip2

USER user
ENV HOME=/home/user
WORKDIR /home/user

RUN sh -c 'curl -L https://repo.anaconda.com/archive/Anaconda3-5.2.0-Linux-x86_64.sh > ./anaconda.sh' \
    && bash ./anaconda.sh -b \
    && sh -c 'echo "# added by docker script for anaconda3-python" >> ~/.bashrc' \
    && sh -c 'echo export PATH="/home/user/anaconda3/bin:$PATH" >> ~/.bashrc' \
    && sh -c 'echo alias python3=python >> ~/.bashrc' 

WORKDIR /home/user/tarball
COPY GipsyX-rc0.2-Linux-Centos7-avx.tgz /home/user/tarball/GipsyX-rc0.2-Linux-Centos7-avx.tgz
COPY goa-var-GipsyX-Rc0.2.tgz /home/user/tarball/goa-var-GipsyX-Rc0.2.tgz

RUN tar -zxvf /home/user/tarball/GipsyX-rc0.2-Linux-Centos7-avx.tgz -C /home/user \
    && tar -zxvf /home/user/tarball/goa-var-GipsyX-Rc0.2.tgz -C /home/user

RUN sh -c 'echo "#for gipsy" >> ~/.bashrc' \
    && sh -c 'echo "source $HOME/GipsyX-rc0.2/rc_GipsyX.sh" >> ~/.bashrc'

WORKDIR /home/user
RUN bash --login -c "cd /home/user/GipsyX-rc0.2/ && ./verify.py"

