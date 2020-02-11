FROM centos:7

## Workdir
ENV workdir /work
WORKDIR ${workdir}
RUN mkdir -p ${workdir} &&  chmod 1777 ${workdir}


## Installing some tools
RUN yum -y install epel-release


# User
RUN adduser user1000 && adduser user1001
RUN ln -s /work /home/user1000/work
USER user1000
