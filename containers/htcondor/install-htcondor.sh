#!/bin/bash

cd $(dirname $0)

usage="$0 [master/worker/submitter] [name of condor master (collector)]"

[ $# -eq 0 ] && echo "$usage" && exit 0

node=$1
htcondor_master=$2
echo "Type = $node, HTCondor Master = $htcondor_master"

## Functions
install_commons(){
    RUN rpm --import http://research.cs.wisc.edu/htcondor/yum/RPM-GPG-KEY-HTCondor && \
    yum-config-manager --add-repo https://research.cs.wisc.edu/htcondor/yum/repo.d/htcondor-stable-rhel7.repo && \
    yum -y install condor-procd condor-external-libs condor-bosco condor-classads condor-python condor && \
    yum clean all
}

install_htcondor(){
    echo "Making HTCondor $node node ..."
    install_commons
    cp -rv $node/${node}_config.d/*.conf /etc/condor/config.d/
    sed -e "s/htcondor_master/$htcondor_master/g" -i /etc/condor/config.d/*.conf
}

## Main
case $node in
    master|worker|submitter)
	install_htcondor
	;;
    *)
	echo "[$node] is not defined"
	exit -1
	;;
esac

