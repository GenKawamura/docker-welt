FROM centos:6

ARG DCACHE_MODE

## Workdir
ENV workdir /work
WORKDIR ${workdir}
RUN mkdir -p ${workdir} &&  chmod 1777 ${workdir}


## Installing dCache
RUN echo "DCACHE_MODE = $DCACHE_MODE"

RUN yum install -y wget openssl
ADD dcache_template /root/dcache_template
ADD postgresql-9.4 /root/postgresql-9.4
ADD yaim /root/yaim
ADD sbin /usr/sbin

ADD installers/0*.sh /root/installers/
RUN cd /root && for f in $(ls installers/0*.sh); do echo "$f"; bash -x $f; done
ADD installers/1*.sh /root/installers/
RUN cd /root && for f in $(ls installers/1*.sh); do echo "$f"; bash -x $f; done
ADD installers/2*.sh /root/installers/
RUN cd /root && for f in $(ls installers/2*.sh); do echo "$f"; bash -x $f; done
ADD installers/3*.sh /root/installers/
RUN cd /root && for f in $(ls installers/3*.sh); do echo "$f"; bash -x $f; done
ADD installers/5*.sh /root/installers/
RUN cd /root && for f in $(ls installers/5*.sh); do echo "$f"; bash -x $f; done
ADD installers/9*.sh /root/installers/
RUN cd /root && for f in $(ls installers/9*.sh); do echo "$f"; bash -x $f; done


# User
RUN adduser user1000 && adduser user1001
RUN ln -s /work /home/user1000/work
USER user1000

