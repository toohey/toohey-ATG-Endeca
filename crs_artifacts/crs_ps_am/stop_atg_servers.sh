
ps -aef | sed -n '/crs_ps\.xml/{/grep/!p;}' | awk '{print$2}' | xargs -i kill -9 {}
ps -aef | sed -n '/crs_am\.xml/{/grep/!p;}' | awk '{print$2}' | xargs -i kill -9 {}