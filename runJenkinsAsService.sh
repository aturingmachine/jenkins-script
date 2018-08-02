#!/bin/bash

logcheck=0

echo "*** STARTING JENKINS SERVICE***" >> ~/jenkins/jenkins.log

java -jar ~/jenkins/.jars/jenkins.war >> ~/jenkins/jenkins.log 2>&1 < /dev/null &

grep -q corrupt ~/jenkins/jenkins.log

if [ "$?" -eq "0" ]; then
  echo "Jenkins Failed to start, the .war is corrupt, redownloading..."
  rm ~/jenkins/.jars/jenkins.war
  curl -L http://mirrors.jenkins.io/war-stable/latest/jenkins.war > ~/jenkins/.jars/jenkins.war
  echo '' > ~/jenkins/jenkins.log
  java -jar ~/jenkins/.jars/jenkins.war >> ~/jenkins/jenkins.log 2>&1 < /dev/null &
fi

grep -m 1 'This may also be found at' ~/jenkins/jenkins.log >> /dev/null
x=$?
if [ "$x" -eq 0 ]; then 
  sed -i '' '/password/d' ~/jenkins/jenkins.log
  logcheck=1
fi

if [ "$logcheck" -eq 0 ]; then
  echo 'Waiting for initial password...'
  sleep 10
  grep -A 5 password ~/jenkins/jenkins.log
fi
