FROM centos:7

## Workdir
ENV workdir /work
WORKDIR ${workdir}
RUN mkdir -p ${workdir} &&  chmod 1777 ${workdir}

## Installing some tools
RUN yum -y install epel-release
RUN yum -y install firefox


# User
RUN adduser user1000 && adduser user1001
USER user1000
