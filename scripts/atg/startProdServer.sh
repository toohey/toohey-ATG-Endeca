#!/bin/sh
echo -ne "\033]0;Prod Server\007"
~/jboss/bin/run_crs_ps.sh
