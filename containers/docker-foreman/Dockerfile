FROM devopsil/puppet:3.7.0

RUN yum -y install epel-release
RUN yum -y install http://yum.theforeman.org/releases/1.9/el6/x86_64/foreman-release.rpm
RUN yum -y install https://download1.rpmfusion.org/free/el/rpmfusion-free-release-6.noarch.rpm 
RUN yum -y install http://repository.it4i.cz/mirrors/repoforge/redhat/el6/en/x86_64/rpmforge/RPMS/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm

# Workdir
ENV workdir /work
RUN mkdir -p ${workdir} &&  chmod 1777 ${workdir} && ln -sv ${workdir} /var/lib/pgsql

## Foreman
RUN yum -y install foreman-installer

# make hostname -f work for foreman-installer
RUN puppet apply -e 'host { $::hostname: ensure => absent } -> host { "${::hostname}.docker.local": ip => $::ipaddress, host_aliases => [$::hostname] }' && foreman-installer --foreman-admin-password=changeme

# reset installer config, so the hostname is properly set at runtime
COPY foreman-installer-answers.yaml /etc/foreman/

# helper script to run puppet agent
COPY puppet-agent.sh /

# rerun setup with current hostname
CMD foreman-installer --foreman-admin-password=changeme \
  && puppet agent --test \
  && tail -f /var/log/foreman/production.log

EXPOSE 443



