#!/bin/sh
ps -aef | sed -n '/crs_am\.xml/{/grep/!p;}' | awk '{print$2}' | xargs -i kill -9 {}

