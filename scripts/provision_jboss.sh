echo "installing JBoss"

# install jboss (quietly!)
unzip -qq /vagrant/software/jboss-eap-6.1.0.zip -d /home/vagrant
ln -s /home/vagrant/jboss-eap-6.1 /home/vagrant/jboss

# set environment variables
echo "export JBOSS_HOME=/home/vagrant/jboss" >> /home/vagrant/.bash_profile

echo "Jboss Installed"
