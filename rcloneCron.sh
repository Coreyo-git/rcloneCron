#! /bin/bash

# stores current date in DD/MM/YYYY for backup times
currentdate=`date +"%d/%m/%y"`

#Checks local onedrive and then cloud onedrive and logs which one was missing files

rclone check /home/coreyo/Documents/onedrive onedrive:/ --missing-on-dst cloudlog.txt --missing-on-src locallog.txt

# Stores both logs to a variable and checks them
clog=$(cat /home/coreyo/scripts/cloudlog.txt)
llog=$(cat /home/coreyo/scripts/locallog.txt)

echo $clog
echo $llog

#If cloud log is empty true else false
if [ -n "$clog" ];
then
    echo "$clog"
    cchange=true
    echo "cloud has a changed file"
else
    echo "Cloud has not changed"
    cchange=false
fi

#If Local log is empty true else false
if [ -n "$llog" ];
then
    lchange=true
    echo "local has a changed file"
else
    echo "Local has not changed"
    lchange=false
fi

# if both local and cloud had changed exit
if [ "$cchange" == true ] && [ "$lchange" == true ];
then
    zenity --info --title "Hello" --text "Cronjob onedrive error syncing"
    rm /home/coreyo/scirpts/cloudlog.txt
    rm /home/coreyo/scripts/locallog.txt
    exit 0
fi

#if cloud has changed prepare to copy
if [ "$cchange" == true ] && [ "$lchange" == false ]; 
then
    echo "Preparing sync.."
    sync.sh
    rm /home/coreyo/scirpts/cloudlog.txt
    rm /home/coreyo/scripts/locallog.txt
fi

#if local has changed prepare sync
if [ "$lchange" == true ] && [ "$cchange" == false ]; 
then 
    echo "Preparing copy"
    copy.sh
    rm /home/coreyo/scirpts/cloudlog.txt
    rm /home/coreyo/scripts/locallog.txt
fi
