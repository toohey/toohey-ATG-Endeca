# Quick Install Oracle Commerce (ATG+Endeca)

### About

This installs Oracle Commerce platform (ATG + Endeca) using common defaults. This is to help setup developer environments for projects more easily and consistently. This creates a vagrant box for you to use as vagrant base box internally within your teams easily.

If you get lost, you can consult [ATG Commerce guide](http://www.oracle.com/technetwork/documentation/atgwebcommerce-393465.html) and [Endeca Commerce guide](http://www.oracle.com/technetwork/indexes/documentation/endecaguidedsearch-1552767.html) for help.

This guide was inspired by (and copies from) [https://github.com/grahammather/ATG-CRS](https://github.com/grahammather/ATG-CRS) and [https://github.com/kpath/Vagrant-CRS](https://github.com/kpath/Vagrant-CRS). And whereas there are many similarities, there are some major differences:

* Target  
	* This is to help create developer environments not for production  
	* This script is only for installing software stack
	* and then creating a non-project specific base box
* Offline usage possible  
	* This script uses only the files listed  
	* Does not update the OS or anything else silently
	* hence internet connection not required after downloading    
* Products used  
	* MySQL is used rather than Oracle DB  
	* CentOS 6.5 is used rather than Oracle Linux  

### Conventions

Throughout this document, the top-level directory that you checked out from git will be referred to as ``script-dir``

### Product versions used in this guide:

- CentOS 6.5 (x86_64)
- MySQL Server 5.6 
- MySQL Connector/J 5.1
- Java 7
- Jboss EAP 6.1
- Oracle Commerce 11.1
	- Commerce Platform
	- Commerce Reference Store
	- MDEX
	- Platform Services
	- Tools And Frameworks with Experience Manager
	- Content Acquisition Server

###Licences
Specified in the COPYING file that is part of this.

### Other software dependencies

- Vagrant 1.7.4
- VirtualBox 4.3.3
- vagrant hosts-updater plugin (optional)

### Technical Requirements

This product stack is pretty heavy.  It's a DB, three endeca services and multiple ATG servers.  You're going to need:

- 16 GB RAM on your machine (10 gig for VM)

## Download required Commerce (ATG+Endeca) software

### ATG 11.1

- Go to [Oracle Edelivery](http://edelivery.oracle.com)
- Accept the restrictions
- On the search page Select the following options: 
  - Product Pack -> ATG Web Commerce
  - Platform -> Linux x86-64
- Click Go
- Click the top search result "Oracle Commerce (11.1.0), Linux"
- Download the following parts:
  - Oracle Commerce Platform 11.1 for UNIX
  - Oracle Commerce Reference Store 11.1 for UNIX
  - Oracle Commerce MDEX Engine 6.5.1 for Linux
  - Oracle Commerce Content Acquisition System 11.1 for Linux
  - Oracle Commerce Experience Manager Tools and Frameworks 11.1 for Linux
  - Oracle Commerce Guided Search Platform Services 11.1 for Linux

**NOTE**  The Experience Manager Tools and Frameworks zipfile (V46389-01.zip) expands to a `cd` directory containing an installer.  You need to unzip this file.  

### Java 7

- Go to the [Oracle JDK 7 Downloads Page](http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html)
- Download "jdk-7u79-linux-x64.rpm"

### JBoss EAP 6.1

- Go to the [JBoss product downloads page](http://www.jboss.org/products/eap/download/)
- Click "View older downloads"
- Click on the zip downloader for 6.1.0.GA

###MySql Database
- Go to the [MySql Community Server download](http://dev.mysql.com/downloads/mysql/)
- select platform "Red Hat Enterprise Linux / Oracle Linux"
- Download the following parts:
	- Red Hat Enterprise Linux 6 / Oracle Linux 6 (x86, 64-bit), RPM Package Client Utilities (MySQL-client-5.6.26-1.el6.x86_64.rpm)
	- Red Hat Enterprise Linux 6 / Oracle Linux 6 (x86, 64-bit), RPM Package MySQL Server (MySQL-server-5.6.26-1.el6.x86_64.rpm)
	- Red Hat Enterprise Linux 6 / Oracle Linux 6 (x86, 64-bit), RPM Package Compatibility Libraries (MySQL-shared-compat-5.6.26-1.el6.x86_64.rpm)

###MySql DB Driver

- Go to the [MySQL Connector/J download](http://dev.mysql.com/downloads/connector/j/)
- Select Platform "Platform independent"
- Download Platform Independent (Architecture Independent), ZIP Archive (mysql-connector-java-5.1.36.zip)  

**NOTE**  The mysql-connector zipfile expland to multiple files. Only the .jar file is the driver and only that needs to be copied into `script-dir/software` directory. 


## Software Check

**IMPORTANT:** Move everything you downloaded (and unzipped) to the `script-dir/software` directory at the top level of this project.  

Before going any further, make sure your software directory looks like one of the following:

```
software/
├── MySQL-client-5.6.26-1.el6.x86_64.rpm
├── MySQL-server-5.6.26-1.el6.x86_64.rpm
├── MySQL-shared-compat-5.6.26-1.el6.x86_64.rpm
├── OCPlatform11.1.bin
├── OCReferenceStore11.1.bin
├── OCcas11.1.0-Linux64.sh
├── OCmdex6.5.1-Linux64_829811.sh
├── OCplatformservices11.1.0-Linux64.bin
├── cd
├── ├── ...
├── └── ...
├── jboss-eap-6.1.0.zip
├── jdk-7u79-linux-x64.rpm
├── mysql-connector-java-5.1.36-bin.jar
└── readme.txt
```

## Install Required Virtual Machine Software

Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) and [Vagrant](http://www.vagrantup.com/downloads.html).

Tested / Recommended versions are:  

- VirtualBox 4.3.3
- Vagrant	1.7.4



## Create the vm

`vagrant up`

When it's done you'll have a vm created that is all ready to install and run ATG CRS.  

It will have installed 
jdk7 at /usr/java/jdk1.7.0_79 
jboss at /home/vagrant/jboss
endeca at /usr/local/endeca
ATG at /home/vagrant/ATG/ATG11.1
MySQL Connector/J at /home/vagrant/ATG/ATG11.1/mysql

You'll also have the required environment variables set in the .bash_profile of the "vagrant" user.  

Add an entry to /etc/hosts file

	192.168.70.5	atgbox.dev  

The above is done automatically by vagrant if you have **vagrant-hostsupdater** plugin installed. If you want you can install it using (easiest if you are online) :  

	vagrant plugin install vagrant-hostsupdater


To get a shell on the atgbox.dev vm, type

`vagrant ssh`

Key Information:

- The atgbox.dev vm has the private IP 192.168.70.5.  This is defined at the top of the Vagrantfile.
- java is installed in `/usr/java/jdk1.7.0_79`
- jboss is installed at `/home/vagrant/jboss`
- All Endeca software is installed under `/usr/local/endeca`
	- MDEX `/usr/local/endeca/MDEX/6.5.1`  
	- Platform Services `/usr/local/endeca/PlatformServices/11.1.0/`  
	- Tools And Frameworks `/usr/local/endeca/ToolsAndFrameworks/11.1.0`  
- Endeca apps should be installed at `/usr/local/endeca/Apps`
- ATG at ``/home/vagrant/ATG/ATG11.1``
- MySQL Connector/J at ``/home/vagrant/ATG/ATG11.1/mysql``
- Your `script-dir` directory is mounted at `/vagrant`.  You'll find the installers you downloaded at `/vagrant/software`from within the atg vm
- Endeca services are started when vm boots
	- convenience scripts are in /home/vagrant/scripts/
- From within the atg vm, you can use the scripts `/vagrant/scripts/atg/start_endeca_services.sh`and `/vagrant/scripts/atg/stop_endeca_services.sh`to start|stop all the endeca services at once:
	  - endecaplatform
	  - endecaworkbench
	  - endecacas

##Package and add new vagrant box for easy reuse
Run the following command to create a new vagant box:

	vagrant package --output toohey-atg-installed.box  
	vagrant box add toohey-atg-installed toohey-atg-installed.box  

On my machine, the size of the box file is 2.7 gigs. Considering that download of software is 2.4 gigs + .3 gig OS means this is as low as it can get.  

Now, you dont need the scripts that created this VM. So remove it and remove the downloaded Vagrantfile. Its easy to create brand new instances.

	vagrant destroy  
	rm Vagrantfile  

##Create a fresh new virtual machine
Finally, every time you now need to create a new clean virtual machine with fresh installation of atg + endeca + jboss + mysql on centos, run

	mkdir my-new-project
	cd my-new-project
	vagrant init toohey-atg-installed
