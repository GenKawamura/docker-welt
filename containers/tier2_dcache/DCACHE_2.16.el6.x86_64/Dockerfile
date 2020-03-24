FROM centos:6

ARG DCACHE_MODE

## Workdir
ENV workdir /work
WORKDIR ${workdir}
RUN mkdir -p ${workdir} &&  chmod 1777 ${workdir}


## Installing dCache
RUN echo "DCACHE_MODE = $DCACHE_MODE"

RUN yum install -y wget
ADD installers /root/installers
ADD dcache_template /root/dcache_template
ADD postgresql-9.4 /root/postgresql-9.4
ADD sbin /usr/sbin

RUN cd /root && for f in $(ls installers/*.sh); do echo "$f"; bash -x $f; done

# User
RUN adduser user1000 && adduser user1001
RUN ln -s /work /home/user1000/work
USER user1000

