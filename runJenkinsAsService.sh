#!/bin/bash

logcheck=0

echo "*** STARTING JENKINS SERVICE***" >> ~/jenkins/jenkins.log

java -jar ~/jenkins/.jars/jenkins.war >> ~/jenkins/jenkins.log 2>&1 < /dev/null &

grep -q corrupt ~/jenkins/jenkins.log >> /dev/null

if [ "$?" -eq "0" ]; then
  echo "Jenkins Failed to start, the .war is corrupt, redownloading..."
  rm ~/jenkins/.jars/jenkins.war
  curl -L http://mirrors.jenkins.io/war-stable/latest/jenkins.war > ~/jenkins/.jars/jenkins.war
  echo '' > ~/jenkins/jenkins.log
  java -jar ~/jenkins/.jars/jenkins.war >> ~/jenkins/jenkins.log 2>&1 < /dev/null &
fi

grep -m 1 'NEWJENKINSINSTALL' ~/jenkins/.new >> /dev/null 2>&1
x=$?

if [ "$x" -eq 0 ]; then 
  sed -i "" '1d' ~/jenkins/.new
  logcheck=1
fi

if [ "$logcheck" -eq 1 ]; then
  sp='/-\|'
  echo 'Waiting for initial password...'
  
  for (( i=1; i<=100; i++)); do
    sleep 0.1
    #printf "%0.s#" $i
    printf "\b${sp:i%${#sp}:1}"
  done
  echo -e "\b "
  printf " "
  echo -e "\n"  
  grep -A 5 following ~/jenkins/jenkins.log
  echo "Enter this password to unlock Jenkins."
fi
