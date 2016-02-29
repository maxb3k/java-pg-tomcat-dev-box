#!/usr/bin/env bash

if type -p java; then
    echo found java executable in PATH
    exit 0
fi

#Setup oracle hotspot JDK 7.
#Download. Thanks to http://stackoverflow.com/questions/10268583/how-to-automate-download-and-installation-of-java-jdk-on-linux
wget -P /tmp --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u75-b13/jdk-7u75-linux-x64.rpm 1> NUL 2> NUL

#install downloaded jdk
rpm -ivh /tmp/jdk-7u75-linux-x64.rpm

#setup environment variables
cat > /etc/profile.d/java.sh <<END \
#!/bin/bash
JAVA_HOME=/usr/java/jdk1.7.0_75/
#PATH=$JAVA_HOME/bin:$PATH
#export PATH JAVA_HOME
END

chmod +x /etc/profile.d/java.sh
source /etc/profile.d/java.sh
