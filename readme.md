# Jenkins Script

## Install

Clone this repo to `~/jenkins`

`git clone git@github.com:aturingmachine/jenkins-script.git ~/jenkins`

Add an alias to your `.bashrc` or `.bash_profile`

`alias jenkins="~/jenkins/jenkins.sh"`

---

Running `jenkins` should then download the latest `.war` and start the jenkins server

Running it again will stop it.

If the `.war` is corrupt the script should redownload the `.war` and start jenkins.

## Usage

If you have made the alias you can simply run `jenkins`. Otherwise run `~/jenkins/jenkins.sh`

Adding the `-s` flag will tell you whether or not a Jenkins Server is running.

> This only checks if the Jenkins build downloaded by this script is running.

## Issues

If while waiting for an initial password the script hangs for an extended period of time, kill the script
and check the logs. It is possible the Jenkins server died quietly causing us to be unable to exit a loop.
