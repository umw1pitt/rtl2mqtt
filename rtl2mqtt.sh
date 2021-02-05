#!/bin/bash

# A simple script that will receive events from a RTL433 SDR

# Author: Marco Verleun <marco@marcoach.nl>
# Version 2.0: Adapted for the new output format of rtl_433

# Remove hash on next line for debugging
#set -x

export LANG=C
PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"

#
# Start the listener and enter an endless loop
#

rtl_431 -f 344975000 -F json -M utc | while read line
do
  sensor_id=`echo $line |  jq -c ".id"`
  sensor_data=`echo "$line"`
  
  echo $sensor_id
  echo $sensor_data
  #send sensor data to unique MQTT topic by sensor ID. MQTT debug on '-d'
  echo $sensor_data | mosquitto_pub -h $MQTT_HOST -p 1881 -i RTL_433 -l -t honeywell/sensor/$sensor_id -u $USER -P $PASS -d

done

