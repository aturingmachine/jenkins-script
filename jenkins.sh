#!/bin/bash

if [ ! -f ~/jenkins/.jars/jenkins.war ]; then
    echo '' > ~/jenkins/jenkins.log
    echo "Installing Jenkins..."
    curl -L http://mirrors.jenkins.io/war-stable/latest/jenkins.war > ~/jenkins/.jars/jenkins.war
    sleep 1
    ~/jenkins/runJenkinsAsService.sh
    exit 0
fi

sleep 2

ps S | grep -v 'grep' | grep -m 1 "/usr/bin/java \-jar" > /dev/null 2>&1

gec=$?

if [ "$gec" -eq 1 ]; then
    echo "Starting Jenkins..."
    ~/jenkins/runJenkinsAsService.sh
    echo "Jenkins Started."
  else
    echo "Stopping Jenkins..."
    ~/jenkins/stopJenkinsService.sh
fi
