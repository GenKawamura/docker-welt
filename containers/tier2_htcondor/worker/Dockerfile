FROM centos:centos7

MAINTAINER Andy Pohl <apohl@morgridge.org>

# HTCondor User details:
ENV SUBMIT_USER submitter
ENV SUBMIT_GROUP ops
ENV GID 1000
ENV UID 1000
ENV PASS 123456

# Build in one RUN
RUN yum -y install \
         yum-utils \
         sudo \
         which \
         openssh-clients && \
    yum -y groupinstall 'Development Tools'
RUN yum -y install epel-release

RUN rpm --import http://research.cs.wisc.edu/htcondor/yum/RPM-GPG-KEY-HTCondor && \
    yum-config-manager --add-repo https://research.cs.wisc.edu/htcondor/yum/repo.d/htcondor-stable-rhel7.repo && \
    yum -y install condor-procd condor-external-libs condor-bosco condor-classads condor-python condor && \
    yum clean all && \
    rm -f RPM-GPG-KEY-HTCondor && \
    groupadd -g ${GID} ${SUBMIT_GROUP} && \
    useradd -m -u ${UID} -g ${GID} ${SUBMIT_USER} && \
    usermod -a -G condor ${SUBMIT_USER} && \
    echo ${PASS} | passwd --stdin ${SUBMIT_USER} && \
    mkdir /home/${SUBMIT_USER}/example && \
    sed -i 's/\(^Defaults.*requiretty.*\)/#\1/' /etc/sudoers && \
    rm -f /etc/localtime && \
    ln -s /usr/share/zoneinfo/CET /etc/localtime

# KNOBS and startup script
COPY start-condor.sh /usr/sbin/
#COPY condor_batch/* /etc/condor/config.d/

# Use this if you're not going to restart HTCondor in the container.
# If you do need to do that, you're better off running the condor_master
# command manually
CMD ["/usr/sbin/start-condor.sh"]
