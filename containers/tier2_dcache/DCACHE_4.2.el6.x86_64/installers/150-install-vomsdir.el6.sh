## install repo
wget http://linuxsoft.cern.ch/wlcg/wlcg-sl6.repo -O /etc/yum.repos.d/wlcg-sl6.repo

yum clean all

## install vomsdir
yum --nogpgcheck -y install wlcg-voms-atlas wlcg-voms-ops
