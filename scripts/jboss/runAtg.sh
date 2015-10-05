#!/bin/sh
JAVA_OPTS="$JAVA_OPTS -server -Xms2048m -Xmx3072m -XX:MaxPermSize=768m -XX:MaxNewSize=768m -Dsun.rmi.dgc.server.gcInterval=3600000 -Dsun.rmi.client.gcInterval=3600000"
. /home/vagrant/jboss/bin/standalone.sh --server-config=crs_sso.xml $*
