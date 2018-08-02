#!/bin/bash

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

logcheck=$(grep -m 1 password ~/jenkins/jenkins.log)


if [ "$logcheck" -eq 1 ]; then
  sleep 10
  grep -A 5 generated ~/jenkins/jenkins.log
fi
