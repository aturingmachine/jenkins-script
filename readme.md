# Jenkins Script

## Install

Clone this repo to `~/jenkins`

Add an alias to your `.bashrc` or `.bash_profile`

`alias jenkins="~/jenkins/jenkins.sh"`

---

Running `jenkins` should then download the latest `.war` and start the jenkins server

Running it again will stop it.

If the `.war` is corrupt the script should redownload the `.war` and start jenkins.
