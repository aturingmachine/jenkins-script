#!/bin/bash

RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

new=0

if [ ! -f ~/jenkins/.jars/jenkins.war ]; then
    echo '' > ~/jenkins/jenkins.log
    echo -e "${BLUE}Dowloading Latest LTS Jenkins build, this may take a minute...\n"
    curl -L --progress-bar http://mirrors.jenkins.io/war-stable/latest/jenkins.war > ~/jenkins/.jars/jenkins.war
    echo -e "${NC}"
    sleep 1
    new=1
    touch ~/jenkins/.new
    echo 'NEWJENKINSINSTALL' > ~/jenkins/.new
fi


sleep 1

ps S | grep -v 'grep' | grep -m 1 "/usr/bin/java \-jar" > /dev/null 2>&1

gec=$?

lsof -i:8080 >> /dev/null

portcheck=$?

if [  "$portcheck" -eq 0 ] && [ "$gec" -eq 1 ]; then
  echo -e "${RED}Port 8080 in use, please clear it and try again.{$NC}\n"
  exit 1
fi

if [ \( "$gec" -eq 1 \) -o \( "$new" -eq 1 \) ]; then
    echo -e "${BLUE}Starting Jenkins...${NC}\n"
    ~/jenkins/runJenkinsAsService.sh
    echo -e "\n${GREEN}Jenkins Started. Navigate to http://localhost:8080 to view.${NC}\n"
  else
    echo -e "${GREEN}Stopping Jenkins...${NC}\n"
    ~/jenkins/stopJenkinsService.sh
fi
