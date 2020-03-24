# install EGI CA
yum --nogpgcheck -y install yum-protectbase ca-policy-egi-core fetch-crl

# fetch-crl 
chkconfig fetch-crl-boot off
chkconfig fetch-crl-cron on

