
# copy mysql driver into atg installation
mkdir ~/ATG/ATG11.1/mysql
cp /vagrant/software/mysql-connector-java-5.1.36-bin.jar ~/ATG/ATG11.1/mysql/

# need to setup jboss server
# add mysql driver to jboss as module - only once
mkdir -p /home/vagrant/jboss/modules/com/mysql/main
cp /vagrant/software/mysql-connector-java-5.1.36-bin.jar /home/vagrant/jboss/modules/com/mysql/main
cp /vagrant/scripts/jboss/module.xml /home/vagrant/jboss/modules/com/mysql/main

# create jboss server instances and use it from CIM
# DON't create jboss instances using CIM
# also dont do post deploy tasks to jboss installation
# this is currently done manually
# may automate it in future - for now manual
# crs_ps_am - 2 db, 2 instances (ps,am)
# connection pools: crs_coreDS, crs_verDS
# crs_ps:8180 connect to crs_coreDS
# crs_am:8280 connect to crs_coreDS, crs_verDS
# use existing jboss instances and configue
# appropriate in ATG

# create db in mysql as CIM cant create it
mysql -u root -proot -e 'create database crs_core'
mysql -u root -proot -e 'create database crs_ver'

# copy jboss server setup (or manually do it as per install ):
cp /vagrant/crs_artifacts/crs_ps_am/run_*.sh ~/jboss/bin/
chown vagrant:vagrant ~/jboss/bin/run_*.sh
chmod +x ~/jboss/bin/run_*.sh
cp /vagrant/crs_artifacts/crs_ps_am/crs*.xml ~/jboss/standalone/configuration/
cp /vagrant/crs_artifacts/crs_ps_am/tail*.sh ~/scripts/
chown vagrant:vagrant ~/scripts/tail*.sh
chmod +x ~/scripts/tail*.sh

# also copy atg server start stop scripts
cp /vagrant/crs_artifacts/crs_ps_am/start_atg_servers.sh ~/scripts/
cp /vagrant/crs_artifacts/crs_ps_am/stop_atg_servers.sh ~/scripts/
chmod +x ~/scripts/*atg_servers.sh

cp /vagrant/crs_artifacts/crs_ps_am/stop_atg_servers.sh ~/scripts/
chown vagrant:vagrant ~/scripts/*atg_servers.sh
chmod +x ~/scripts/*atg_servers.sh

cp /vagrant/crs_artifacts/crs_ps_am/status.sh ~/scripts/
chown vagrant:vagrant ~/scripts/status.sh
chmod +x ~/scripts/status.sh

# start/stop scripts setup for foreground (GUI also)
mkdir -p ~/Desktop/Servers/
cp /vagrant/scripts/atg/startProdServer.sh ~/Desktop/Servers/
cp /vagrant/scripts/atg/stopProdServer.sh ~/Desktop/Servers/
cp /vagrant/scripts/atg/startAssetManagementServer.sh ~/Desktop/Servers/
cp /vagrant/scripts/atg/stopAssetManagementServer.sh ~/Desktop/Servers/
cp /vagrant/scripts/endeca/promoteContent.sh ~/Desktop/Servers/
chmod +x ~/Desktop/Servers/*.sh

# URLs for desktop
mkdir -p ~/Desktop/Shortcuts/
cp /vagrant/crs_artifacts/crs_ps_am/BCC-frontend.desktop ~/Desktop/Shortcuts/
cp /vagrant/crs_artifacts/crs_ps_am/BCC-DynAdmin.desktop ~/Desktop/Shortcuts/
cp /vagrant/crs_artifacts/crs_ps_am/BCC-startACC.desktop ~/Desktop/Shortcuts/
cp /vagrant/crs_artifacts/crs_ps_am/Prod-frontend.desktop ~/Desktop/Shortcuts/
cp /vagrant/crs_artifacts/crs_ps_am/Prod-DynAdmin.desktop ~/Desktop/Shortcuts/
cp /vagrant/crs_artifacts/crs_ps_am/Prod-startACC.desktop ~/Desktop/Shortcuts/
cp /vagrant/crs_artifacts/crs_ps_am/ExperienceManager.desktop ~/Desktop/Shortcuts/
cp /vagrant/scripts/endeca/Endeca-Workbench.desktop ~/Desktop/Shortcuts/
chmod +x ~/Desktop/Shortcuts/*.desktop

# install flash plugin
sudo rpm -ivh /vagrant/software/flash-plugin-11.2.202.521-release.x86_64.rpm


/home/vagrant/ATG/ATG11.1/home/bin/cim.sh -batch /vagrant/crs_artifacts/crs_ps_am/batch.cim

# OR

# manually
# cd /home/vagrant/ATG/ATG11.1/home
# bin/cim.sh -record -noencryption
# exit cim
# cp ../CIM/log/cim.log /vagrant/crs_artifacts/crs_ps_am/
# cp ../CIM/data/batch.cim /vagrant/crs_artifacts/crs_ps_am/

# uses:
# - JBoss: /home/vagrant/jboss
# - Java: /usr/java/jdk1.7.0_79
# - mysql driver: /home/vagrant/ATG/ATG11.1/mysql/mysql-connector-java-5.1.36-bin.jar
# - security: /home/vagrant/ATG/ATG11.1/home/security/crs_ps_am/
# - archive: /usr/local/endeca/Apps/CRS/data/workbench/application_export_archive/CRS


# copy runAssembler commands here manually


# endeca EAC app CRS needs to be deployed outside CIM
/vagrant/scripts/endeca/crs-eac-app-setup.sh

# # endeca workbench password was not admin. so maybe sling was corrupt
# # https://community.oracle.com/message/12895542
# # Stop the Endeca TAF service
# ~/scripts/stop_endeca_services.sh
# # remove the C:\Endeca\ToolsAndFrameworks_1\11.1.0\server\workspace\state\sling folder
# rm -r /usr/local/endeca/ToolsAndFrameworks/11.1.0/server/workspace/state/sling
# # start the Endeca TAS service
# ~/scripts/start_endeca_services.sh
# # update credential - interactive
# cd /usr/local/endeca/ToolsAndFrameworks/11.1.0/credential_store/bin
# ./manage_credentials.sh delete --user admin --key ifcr
# echo "enter admin as password (twice) ... not automated yet"
#
# # ./manage_credentials.sh add --user admin --key ifcr



# atg CIM deployment updates deployment scanner for jboss instance
# hence copy correct files after that
cp /vagrant/crs_artifacts/crs_ps_am/crs*.xml ~/jboss/standalone/configuration/

# fix other configuration problems
# in /home/vagrant/ATG/ATG11.1/home/servers/crs_ps/localconfig/atg/endeca/ApplicationConfiguration.properties add
# keyToApplicationName=default=CRS
# 
echo "keyToApplicationName=default=CRS" >> /home/vagrant/ATG/ATG11.1/home/servers/crs_ps/localconfig/atg/endeca/ApplicationConfiguration.properties
# create in ca instance /atg/search/SynchronizationInvoker.properties with
# host=locahost
# port=8860
mkdir -p /home/vagrant/ATG/ATG11.1/home/servers/crs_am/localconfig/atg/search/
echo "host=localhost" > /home/vagrant/ATG/ATG11.1/home/servers/crs_am/localconfig/atg/search/SynchronizationInvoker.properties \
	&& echo "port=8861" >> /home/vagrant/ATG/ATG11.1/home/servers/crs_am/localconfig/atg/search/SynchronizationInvoker.properties

# create in ca instance /atg/deployment/DeploymentManager.properties
# maxThreads=1
# useDistributedDeployment=false
mkdir -p /home/vagrant/ATG/ATG11.1/home/servers/crs_am/localconfig/atg/deployment/
echo "maxThreads=1" > /home/vagrant/ATG/ATG11.1/home/servers/crs_am/localconfig/atg/deployment/DeploymentManager.properties \
	&& echo "useDistributedDeployment=false" >> /home/vagrant/ATG/ATG11.1/home/servers/crs_am/localconfig/atg/deployment/DeploymentManager.properties

# in ca and prod instance, disable rest security - used in user segment sharing
# /atg/rest/security/RequestCredentialAccessController.enable=false
# maybe only needed in ca server since that is segment server - later
mkdir -p /home/vagrant/ATG/ATG11.1/home/servers/crs_am/localconfig/atg/rest/security/
echo "enabled=false" > /home/vagrant/ATG/ATG11.1/home/servers/crs_am/localconfig/atg/rest/security/RequestCredentialAccessController.properties
mkdir -p /home/vagrant/ATG/ATG11.1/home/servers/crs_ps/localconfig/atg/rest/security/
echo "enabled=false" > /home/vagrant/ATG/ATG11.1/home/servers/crs_ps/localconfig/atg/rest/security/RequestCredentialAccessController.properties

# for supporting incremental change in pub server config:
# /atg/commerce/search/ProductCatalogOutputConfig
# /atg/commerce/search/StoreLocationOutputConfig
# /atg/commerce/endeca/index/CategoryToDimensionOutputConfig
# /atg/content/search/ArticleOutputConfig
# /atg/content/search/MediaContentOutputConfig
# ensure targetName=Production is not commented
echo "targetName=Production" >> /home/vagrant/ATG/ATG11.1/home/servers/crs_am/localconfig/atg/commerce/search/ProductCatalogOutputConfig.properties
echo "targetName=Production" >> /home/vagrant/ATG/ATG11.1/home/servers/crs_am/localconfig/atg/commerce/search/StoreLocationOutputConfig.properties
echo "targetName=Production" >> /home/vagrant/ATG/ATG11.1/home/servers/crs_am/localconfig/atg/commerce/endeca/index/CategoryToDimensionOutputConfig.properties
echo "targetName=Production" >> /home/vagrant/ATG/ATG11.1/home/servers/crs_am/localconfig/atg/content/search/ArticleOutputConfig.properties
echo "targetName=Production" >> /home/vagrant/ATG/ATG11.1/home/servers/crs_am/localconfig/atg/content/search/MediaContentOutputConfig.properties

# fix for LockManager error during startup
echo "lockServerPort=9010" > /home/vagrant/ATG/ATG11.1/home/servers/crs_am/localconfig/atg/dynamo/service/ClientLockManager.properties \
&& echo "useLockServer=false" >> /home/vagrant/ATG/ATG11.1/home/servers/crs_am/localconfig/atg/dynamo/service/ClientLockManager.properties \
&& echo "lockServerAddress=localhost" >> /home/vagrant/ATG/ATG11.1/home/servers/crs_am/localconfig/atg/dynamo/service/ClientLockManager.properties

# fix for BCC local preview not working
# the OOB config is (missing scope):
# $class=atg.service.preview.PreviewHost
# $scope=session
# hostName^=/OriginatingRequest.serverName
# port^=/OriginatingRequest.serverPort
# CIM has messed this up further and put localhost and port
# which does not work if accessed from external machine
echo "\$scope=request" > /home/vagrant/ATG/ATG11.1/home/servers/crs_am/localconfig/atg/dynamo/service/preview/Localhost.properties 


# start all jboss instances - background
# ~/scripts/start_atg_servers.sh
# OR
# start manually!

# full deployment
echo "wait for servers to start"
echo "goto BCC and do full deployment"
echo "*****************************************************"
echo "use Google Chrome to login as admin/Password1 on http://atgbox.dev:8280/atg/bcc"
echo "CA console > configuration > import from xml"
echo "click choose file"
echo "file /crs_artifacts/crs_ps_am/deploymentTopology.xml"
echo "click ok .. then cancel (atg bug shows dialog box again)"
echo "click configuration on left again"
echo "make changes live"
echo "do full deployment"
echo "click make changes live ... take a few minutes ... "
echo "./tail-crs_am.sh ... check for ... purging deployemnt data"
echo "./tail-crs_ps.sh ... check for ... BaselineUpdate for application CRS finished with status NotRunning"
echo "*****************************************************"
echo ""

# currently this is not working, so script exits
# read -n1 -r -p "Press space to promote content or anything else to exit ..." key

if [ "$key" = ' ' ]; then
    # Space pressed
	# promote_content in endeca
	# 
	/usr/local/endeca/Apps/CRS/control/promote_content.sh
else
    # Anything else pressed, do whatever else.
	# product showing http://atgbox.dev:8180/crs/storeus/browse/productDetailSingleSku.jsp?categoryNavIds=cat10016&navAction=push&categoryNav=true&categoryId=cat10016&productId=xprod2032&navCount=3
	# category not showing
	# workbench not authenticating to get segment means maybe config not picked.
	# just ATG working
	echo "remember to promote content else CRS homepage will not show"
	echo "product page will show"
	echo ""
	echo "*****************************************************"
	echo "*****************************************************"
	echo "*****************************************************"
	echo "*****************************************************"
	echo "*****************************************************"
	echo "*****************************************************"
	echo "run /usr/local/endeca/Apps/CRS/control/promote_content.sh"
	echo "AFTER full deployment ... CRS homepage doesnt show"
	echo "*****************************************************"
	echo "*****************************************************"
	echo "*****************************************************"
	echo "*****************************************************"
fi

# exit
# vagrant halt
# take snapshot - provisioned

# next steps:
# install multifox plugin
# run atg instances from GUI
# import deployment topology
# full deployment - initialize agents
# promote content
# check storefront shows fully
# vagrant halt
# take snapshot - ready

######################################################################

# test for ready:
# start servers
# CRS production homepage showing
# BCC incremental deployment working - try a project
# BCC preview working
# ensure ACC works
# check XM after BCC!! otherwise some context error
# XM preview working
# XM segments from BCC showing

# if all working, ready is good

######################################################################


# issues 

# done:


# todos:
# parameterize these scripts
# create vagrant box after script completion
# more space saving ideas - temp files deletion
# endeca logs - multiple places
# jboss work in progress files
# atg logs
# mysql errors, logs
# atg temp files
# guest additions update... versions in sync with all platforms

