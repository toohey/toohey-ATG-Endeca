#!/bin/sh
JAVA_OPTS="$JAVA_OPTS -server -Xms1536m -Xmx3072m -XX:MaxPermSize=256m -Dsun.rmi.dgc.server.gcInterval=3600000 -Dsun.rmi.client.gcInterval=3600000"
. /home/vagrant/jboss/bin/standalone.sh --server-config=crs_am.xml $*
