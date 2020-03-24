#-------------------------------------
# Disable yum cron and daemons 
#-------------------------------------
if [ -e /etc/cron.hourly/yum-autoupdate ] || [ -e /etc/cron.hourly/yum ] || [ -e /etc/cron.daily/yum.cron ] || [ -e /etc/cron.daily/yum-autoupdate ];then
   echo "++++++++++++++++++++++++++++++++++++++++++++++++"
   echo "Yum cron jobs are now disabled"
   rm -f /etc/cron.hourly/yum-autoupdate
   rm -f /etc/cron.hourly/yum
   rm -f /etc/cron.daily/yum.cron
   rm -f /etc/cron.daily/yum-autoupdate
fi

yum_status=`chkconfig --list |grep yum |grep "3:on"`
service_name=`chkconfig --list |grep yum | cut -f 1`

for serv in $service_name; do

if [ "x$yum_status" != "x" ]; then
   echo "++++++++++++++++++++++++++++++++++++++++++++++++"
   echo "+ $serv has been switched to off"
   chkconfig $serv off
fi

if [ -e /var/lock/subsys/$serv ]; then
   /etc/init.d/$serv stop
fi
echo "Done $serv"

done

