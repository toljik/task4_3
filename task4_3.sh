#!/bin/bash

apt-get update -y > /dev/null

if [ ! -d /var/log/task4_3/ ]; then
    mkdir /var/log/task4_3/
fi
exec 2>/var/log/task4_3/task4_3.err

if [ $# -gt 2 ] ; then
 if ( echo "$2" | grep -E -q "^?[0-9]+$") ; then
 echo "ERROR : Error entered extra parameters" 
 exit
 else
 #echo " ne numb"
 echo "ERROR : Error in input data" 
 exit
 fi
else
 if (echo "$2" | grep -E -q "^?[0-9]+$") ; then
 FILENAME=$1
 COUNTDELBACKUP=$2
 BACKUPNAME=` echo "$1" | sed "s/.*/'&'/"`
 else
 echo "ERROR : Error in input data" 
 exit
 fi
fi


if [ -z $1 ]; then
 echo "NOTICE : Please write directory to backup and how many backups need to save" 
 echo "EXAMPLE: sh task4_3.sh  /home/somedir/ 10"  
 exit
 else
  if [ -z $2 ]; then
  echo "NOTICE : Please write directory to backup and how many backups need to save"  
  echo "EXAMPLE: sh task4_3.sh  /home/somedir/ 10" 
  exit
  fi
fi

#FILENAME=$1
SAVEDIR=/tmp/backups
if [ ! -d "$SAVEDIR" ]; then
    mkdir $SAVEDIR
fi

if [ ! -e "$FILENAME" ]; then
 echo "ERROR : No file or directory to backup"  
fi


NAMEBACKUP=`echo ${FILENAME} | tr '/' '-' | sed 's/^[-]*//' | sed 's/[-]*$//'`

if [ ! -d $SAVEDIR ]; then
 mkdir $SAVEDIR
fi

COUNTBACKUP=`ls $SAVEDIR | grep -v "$BACKUPNAME" | wc -l`
if [ $COUNTBACKUP -gt 1 ]; then
 while [ $COUNTBACKUP -gt 1 ]
 do
 NEWCOUNT=$COUNTBACKUP
# echo "новый номер $NEWCOUNT"
 COUNTBACKUP=$(( $COUNTBACKUP - 1 ))
# echo " старый номер $COUNTBACKUP"
 mv "$SAVEDIR/$NAMEBACKUP.$COUNTBACKUP.tar.gz" "$SAVEDIR/$NAMEBACKUP.$NEWCOUNT.tar.gz"
 done
fi

CB=`ls $SAVEDIR | grep -v "$BACKUPNAME" | wc -l`
#echo " cb $CB"

if [ $CB -ge 1 ]; then
 mv "$SAVEDIR/$NAMEBACKUP.tar.gz" "$SAVEDIR/$NAMEBACKUP.1.tar.gz"
fi

tar -czvf "$SAVEDIR/$NAMEBACKUP".tar.gz  "$FILENAME" >> /dev/null
 echo "INFO : Created backup name:$FILENAME"  
COUNTBACKUP=`ls $SAVEDIR | grep -v "$BACKUPNAME" | wc -l`
#echo " кол бек апов перед удалением$COUNTBACKUP"
#COUNTDELBACKUP=$2

if [ $COUNTBACKUP -gt $COUNTDELBACKUP ]; then
 while [ $COUNTBACKUP -gt $COUNTDELBACKUP ]
 do
 NAMEDEL=`ls $SAVEDIR | grep -v "$BACKUPNAME" |  sort -nr -t . -k 2.1 | head -n1`
echo "INFO : Deleted backup: $NAMEDEL"
 rm -f "$SAVEDIR/$NAMEDEL"
 COUNTBACKUP=`ls $SAVEDIR | grep -v "$BACKUPNAME" | wc -l`
 done
fi
