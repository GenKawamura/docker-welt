FROM centos:6

ARG DCACHE_HEAD
ARG DCACHE_POOL

## Workdir
ENV workdir /work
WORKDIR ${workdir}
RUN mkdir -p ${workdir} &&  chmod 1777 ${workdir}


## Installing dCache
RUN echo "DCACHE_HEAD = $DCACHE_HEAD, DCACHE_POOL = $DCACHE_POOL"

ADD installers /root/installers
ADD dcache_template /root/dcache_template
ADD postgresql-9.4 /root/postgresql-9.4
ADD sbin /usr/sbin

RUN cd /root && for f in $(ls installers/*.sh); do echo "$f"; done

# User
RUN adduser user1000 && adduser user1001
RUN ln -s /work /home/user1000/work
USER user1000

