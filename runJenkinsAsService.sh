#!/bin/bash

i=0

logcheck=0

looper=0

echo "*** STARTING JENKINS SERVICE***" >> ~/jenkins/jenkins.log

java -jar ~/jenkins/.jars/jenkins.war >> ~/jenkins/jenkins.log 2>&1 < /dev/null &

grep -q 'Container startup failed' ~/jenkins/jenkins.log >> /dev/null

if [ "$?" -eq "0" ]; then
  echo "Jenkins Failed to start, the .war is corrupt, redownloading..."
  rm ~/jenkins/.jars/jenkins.war
  curl -L --progress-bar  http://mirrors.jenkins.io/war-stable/latest/jenkins.war > ~/jenkins/.jars/jenkins.war
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
  
  while [ "$looper" -eq 0 ]; do
    sleep 0.1
    printf "\b${sp:i%${#sp}:1}"
    if [ -f ~/.jenkins/secrets/initialAdminPassword ]; then
      looper=1
    fi
    i=$((i + 1))
  done

  echo -e "\b "
  cat ~/.jenkins/secrets/initialAdminPassword
  echo "Enter this password to unlock Jenkins."
fi
