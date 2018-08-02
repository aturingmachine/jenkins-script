JENKINSWARPID=$(ps S | grep -v 'grep' | grep -m 1 jenkins.war | awk '{print $1}')

echo '*** STOPPING JENKINS SERVICE ***' >> ~/jenkins/jenkins.log

kill -9 $JENKINSWARPID && echo 'Service Stopped.'

echo "*** SERVICE STOPPED USING kill -9 *** \n\n\n\n\n" >> ~/jenkins/jenkins.log
