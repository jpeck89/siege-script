#!/usr/bin/bash

# The interval between Siege runs will be every 15th minute
INTERVAL=900
DATE=$(date +%F)

mkdir $DATE

# Preface the log file with a time stamp so old logs aren't written to and they are easy to organize
file=$(date +%F_%H:%M)

# This test will run every 15 minutes for 24 hours
for NUM in {1..10};
  do 
    sleep=$(date +%s.%N | awk "{print $INTERVAL - (\$1 % $INTERVAL)}") 
    # Wait until the 0th, 15th, 30th, 45th minute
    sleep $sleep
    # Running 10000 requests, 20 at a time, mark the log file with the test number, and add a special useragent to each apache request
    siege --concurrent=10 --reps=500 --file=./urls.txt --log=./$DATE/${file}-siege.log --mark="Finished test $NUM" --user-agent="jpeck-test" >> ./$DATE/$NUM
done

# Once the full test is done export the log file without notes to a csv file for an easy copy paste to google docs
egrep '^[^*]' ./$DATE/${file}-siege.log > ./$DATE/${file}-siege.csv
