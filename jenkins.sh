#!/bin/bash

RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

ps S | grep -v 'grep' | grep -m 1 "\-jar $HOME/jenkins/.jars/jenkins.war" > /dev/null 2>&1

startCheck=$?

if [ "$1" == "-s" ]; then
  if [ "$startCheck" -eq 0 ]; then
    echo "There is a Jenkins Server running on http://localhost:8080"
  else
    echo "No Jenkins Servers running."
  fi
  
  exit 0
fi

### They have a jenkins running, we need to kill it and exit clean.
if [ "$startCheck" -eq 0 ] && [ -f ~/jenkins/.jars/jenkins.war  ]; then 
  echo -e "${RED}Found a running instance of a Jenkins, stopping it now.${NC}"
  ~/jenkins/stopJenkinsService.sh
  exit 0
### There is an instance running and we do not want to exit
elif [ "$startCheck" -eq 0 ]; then 
  echo -e "${RED}Found a running instance of a Jenkins, stopping it now.${NC}"
  ~/jenkins/stopJenkinsService.sh
fi

### There is no jenkins war in _OUR_ directory, download one.
if [ ! -f ~/jenkins/.jars/jenkins.war ]; then
    echo '' > ~/jenkins/jenkins.log
    echo -e "${BLUE}Dowloading Latest LTS Jenkins build, this may take a minute...\n"
    curl -L --progress-bar http://mirrors.jenkins.io/war-stable/latest/jenkins.war > ~/jenkins/.jars/jenkins.war
    echo -e "${NC}"
    sleep 1
    touch $HOME/jenkins/.new
    echo 'NEWJENKINSINSTALL' > $HOME/jenkins/.new
fi

### This is if we have a jenkins build, but it has not been run and created the
### directory used by jenkins, this is an edge case
if [ ! -d $HOME/.jenkins ] && [ ! -f $HOME/jenkins/.new ]; then
  echo -e "${BLUE}No Jenkins data found, running fresh install...${NC}"
  touch $HOME/jenkins/.new
fi

### Find out if our port is in use
lsof -i:8080 >> /dev/null

portcheck=$?

### If the port is in use, exit with an error code.
if [  "$portcheck" -eq 0 ]; then
  echo -e "${RED}Port 8080 in use, please clear it and try again.${NC}\n"
  runningPid=$(lsof -i:8080 | sed '1d' | awk '{print $2}')
  echo -e "${RED}Running application is: "
  ps -p $runningPid | awk '{print $4}' | sed '1d'
  echo -e "${NC}"
  exit 1
fi

### If we made it this far, no jenkins is running and the port is open. Time to send it.
echo -e "${BLUE}Starting Jenkins...${NC}\n"
~/jenkins/runJenkinsAsService.sh
if [ "$?" -eq 0 ]; then
  echo -e "\n${GREEN}Jenkins Started. Navigate to http://localhost:8080 to view.${NC}\n"
fi
