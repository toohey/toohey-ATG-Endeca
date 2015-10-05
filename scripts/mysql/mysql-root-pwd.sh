#!/usr/bin/env bash
mysql_secret=$(awk '/password/{print $NF}' /root/.mysql_secret)  
mysqladmin -u root --password=${mysql_secret} password root  
