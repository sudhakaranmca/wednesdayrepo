
#!/bin/bash

THRESHOLD=$2
PROCESS_TO_MONITOR=$1

if [ $# -lt 2 ]
then
   echo " please provide the details like process_to_monitor and duration of monitoring period in minutes "
   exit 
while true
do
   echo " *******************************************************************************************" >> out_`hostname`.txt
   echo " `date` - `hostname` "  >> out_`hostname`.txt
   echo "*******************************************************************************************" >> res_output.txt
   top -bn1 | grep load | awk '{printf "CPU Load: %.2f\n", $(NF-2)}' >> out_`hostname`.txt
   free -m | awk 'NR==2{printf "Memory Usage: %s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }' >> out_`hostname`.txt
   #df -h | awk '$NF=="/"{printf "Disk Usage: %d/%dGB (%s)\n", $3,$2,$5}' >> out_`hostname`.txt
   ps -eo pid,cmd,%mem,%cpu --sort=-%mem | head -n 20 >> out_`hostname`.txt
   ps -eo pid,cmd,%mem,%cpu --sort=-%mem | head -n 20 | grep postgres  >> out_`hostname`.txt
   sleep 60
   echo " ==========================================================================================" >> out_`hostname`.txt
done 
