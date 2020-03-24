UMD_URL=http://repository.egi.eu/sw/production/umd/4/sl6/x86_64/updates/umd-release-4.1.3-1.el6.noarch.rpm
UMD_VERSION=$(basename $UMD_URL)
HOME=/root

#------------------------------------
# install
#------------------------------------
[ -e /etc/yum.repos.d/dag.repo ] && rm -v /etc/yum.repos.d/dag.repo


# UMD
if ! [ -e $HOME/$UMD_VERSION ]; then
    rpm -e umd-release
    wget $UMD_URL -O $HOME/$UMD_VERSION
    yum -y install $HOME/$UMD_VERSION

    # yum reset
    yum clean all
fi


