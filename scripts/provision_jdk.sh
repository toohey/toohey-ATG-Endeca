echo "starting to install JDK"

# installing jdk
rpm -U /vagrant/software/jdk-7u79-linux-x64.rpm

#setting up env variables
echo "export JAVA_HOME=/usr/java/jdk1.7.0_79" >> /home/vagrant/.bash_profile \
 && echo "export JAVA_VM=/usr/java/jdk1.7.0_79/bin/java" >> /home/vagrant/.bash_profile \
 && echo "export JAVA_ARGS=-Duser.timezone=UTC" >> /home/vagrant/.bash_profile \
 && echo "export JAVA_OPTS=-Duser.timezone=UTC" >> /home/vagrant/.bash_profile \
 && echo "export PATH=/usr/java/jdk1.7.0_79/bin:$PATH" >> /home/vagrant/.bash_profile

echo "JDK installion done"
