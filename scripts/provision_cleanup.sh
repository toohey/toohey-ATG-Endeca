echo "starting to cleanup so that file size of vm is reduced"

# shutdown and cleanup servers started 
# endeca
/home/vagrant/scripts/stop_endeca_services.sh
rm -rf /usr/local/endeca/CAS/workspace/logs/*.log
rm -rf /usr/local/endeca/PlatformServices/workspace/logs/*.log
rm -rf /usr/local/endeca/ToolsAndFrameworks/11.1.0/server/workspace/logs/*.log

# mysql
service mysql stop
# maybe reduce size of ibdata1 makes sense - future
# http://vmassuchetto.github.io/2013/08/14/reducing-a-vagrant-box-size/

# jboss servers

# atg logs also
# cim logs
# server logs
# named server logs


# remove temp files created during install and prepare for new box!
# ref http://linoxide.com/linux-how-to/setup-centos-7-vagrant-base-box-virtualbox/
# from related bug - vewee's cleanup script for centos
# # Remove traces of mac address from network configuration
# also zhenji on https://github.com/mitchellh/vagrant/issues/1693
sed -i /HWADDR/d /etc/sysconfig/network-scripts/ifcfg-eth0
rm -f /etc/udev/rules.d/70-persistent-net.rules
rm -f /etc/sysconfig/network-scripts/ifcfg-eth1

yum clean all  
rm -rf /tmp/*  
rm -f /var/log/wtmp /var/log/btmp  
echo "will zero out the empty space ... this is likely to take a few minutes"
dd if=/dev/zero of=/EMPTY bs=1M  
rm -f /EMPTY  
cat /dev/null > ~/.bash_history && history -c 

echo "cleanup done"
