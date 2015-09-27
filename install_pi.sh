#!/bin/bash

echo -n "check cmdline..."

temp=$(mktemp)
temp2=$(mktemp)

cat /boot/cmdline.txt | sed -e 's/ /\n/g' > $temp2

while read line
do
 if [ $(echo $line | grep -c 'ttyAMA0,115200') -gt 0 ]
    then
#grep -n "console=ttyAMA0,115200 kgdboc=ttyAMA0,115200" $line
#echo $line | tr -d "console=ttyAMA0,115200 kgdboc=ttyAMA0,115200" >> $temp
echo $line > /dev/null

else
  echo -n  $line" " >> $temp
# | sed 's\g\console=ttyAMA0\' | sed 's\g\115200 kgdboc=ttyAMA0,115200\' >> $temp
fi


done < $temp2

if [ $(md5sum /boot/cmdline.txt | cut -f1 -d ' ') = $(md5sum $temp | cut -f1 -d ' ') ]
then
echo -e "\e[32m[OK]\e[0m"
else
  echo -e "\e[1;33m I found a potential problem in /boot/cmdline.txt\e[0m"
  echo -e "\e[33m /dev/ttyAMA0 seems to be used by the linux console, but plantaria need it! \e[0m"
  echo ""
  echo -e "\e[31m[Current /boot/cmdline.txt]\e[0m"
  cat /boot/cmdline.txt
  echo ""
  echo -e "\e[34m[Suggested /boot/cmdline.txt]\e[0m"
  cat $temp
  echo ""
  echo ""
  echo -e "\e[35mDo you want me replace the /boot/cmdline.txt? (i will create a copy of the current one)\e[0m"
  echo "Please type "YES" or "NO"!"
read userinput
if [ $(echo $userinput | grep -ic "yes") -eq 1 ]
  then
  cp -v /boot/cmdline.txt ~/cmdline.txt_bak
  if [ $? -ne 0 ]
    then
    echo -e "\e[1;31mA error accured while creating the copy of /boot/cmdline.txt\e[0m"
    echo -e "\e[1;31mAborted!\e[0m"
    exit 1

  fi
 echo -e "\e[36mwrite suggested cmdline.txt to /boot/cmdline.txt using "sudo"\e[0m"
 echo "sudo cp -v $temp /boot/cmdline.txt"
 sudo cp -v $temp /boot/cmdline.txt
else
  echo -e "\e[1;31mAborted!\e[0m"
  exit 2
fi
fi

#less $temp
