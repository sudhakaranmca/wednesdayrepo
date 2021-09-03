#!/bin/bash
THRESHOLD_IN_MIN=$2
PROCESS_TO_MONITOR=$1
SLEEP_INTERVAL=10

#postgres
# cd /sys/fs/cgroup/cpu    cat cpuacct.usage
# cd /sys/fs/cgroup/memory cat memory.usage_in_bytes

i=0

if [ $# -lt 2 ]
then
   echo " please provide the details like process_to_monitor and duration of monitoring period in minutes "
   exit 0
fi
 
THRESHOLD=$2
PROCESS_TO_MONITOR=$1
iteration=`expr 60 / $SLEEP_INTERVAL`
iteration=`expr $iteration \* $THRESHOLD_IN_MIN`
echo " value of iteration is $iteration "
while  [ ${i} -lt ${iteration} ]
do
   echo " *******************************************************************************************" >> out_`hostname`.txt
   echo " `date` - `hostname` "  >> out_`hostname`.txt
   echo "*******************************************************************************************" >> out_`hostname`.txt
   top -bn1 | grep load | awk '{printf "CPU Load: %.2f\n", $(NF-2)}' >> out_`hostname`.txt
   free -m | awk 'NR==2{printf "Memory Usage: %s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }' >> out_`hostname`.txt
   #df -h | awk '$NF=="/"{printf "Disk Usage: %d/%dGB (%s)\n", $3,$2,$5}' >> out_`hostname`.txt
   ps -eo pid,cmd,%mem,%cpu --sort=-%mem | head -n 20 >> out_`hostname`.txt
   ps -eo pid,cmd,%mem,%cpu --sort=-%mem | head -n 20 | grep postgres  >> out_`hostname`.txt
   sleep $SLEEP_INTERVAL
   echo " ==========================================================================================" >> out_`hostname`.txt

   i=`expr $i + 1`
done 
