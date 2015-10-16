echo "setup mysql"

# https://opensourcedbms.com/dbms/installing-mysql-5-6-on-cent-os-6-3-redhat-el6-fedora/
# try:
# before:
# rpm -qa | grep -i mysql
# mysql-libs-5.1.67-1.el6_3.x86_64
#
# rpm -U MySQL-shared-compat-5.6.10-1.el6.x86_64.rpm
#
# After:
# rpm -qa | grep -i mysql
# MySQL-shared-compat-5.6.10-1.el6.x86_64.rpm
rpm --nosignature -U /vagrant/software/MySQL-shared-compat-5.6.26-1.el6.x86_64.rpm
# alternative to above
# http://www.servermule.com.au/help/linux/install-mysql-on-centos/
# sudo rpm -e --nodeps mysql-libs
# sudo rpm -i /vagrant/software/MySQL-shared-compat-5.6.26-1.el6.x86_64.rpm

# dependency perl!
# sudo yum install -y perl
rpm --nosignature -i /vagrant/software/perl/perl-5.10.1-141.el6.x86_64.rpm /vagrant/software/perl/perl-libs-5.10.1-141.el6.x86_64.rpm /vagrant/software/perl/perl-version-0.77-141.el6.x86_64.rpm /vagrant/software/perl/perl-Pod-Escapes-1.04-141.el6.x86_64.rpm /vagrant/software/perl/perl-Pod-Simple-3.13-141.el6.x86_64.rpm /vagrant/software/perl/perl-Module-Pluggable-3.90-141.el6.x86_64.rpm

# from http://tecadmin.net/step-to-install-mysql-5-6-12-on-centos-6-and-rhel-6/
rpm --nosignature -i /vagrant/software/MySQL-server-5.6.26-1.el6.x86_64.rpm
echo " mysql server installed - some warnings are expected earlier"
# no mysqladmin without client
rpm --nosignature -i /vagrant/software/MySQL-client-5.6.26-1.el6.x86_64.rpm 
#auto start it on boot
chkconfig mysql --level 2345 on
service mysql start
# reset root password to "root"
# copied from https://blog.starkandwayne.com/2014/05/14/changing-root-password-on-mysql-5-6/
# cp /vagrant/scripts/mysql/mysql-root-pwd.sh /home/vagrant/mysql-root-pwd.sh
# chmod 777 /home/vagrant/mysql-root-pwd.sh
# /home/vagrant/mysql-root-pwd.sh
/vagrant/scripts/mysql/mysql-root-pwd.sh

echo " changed password of mysql root user to root - warning is expected"
echo "done setup mysql"


