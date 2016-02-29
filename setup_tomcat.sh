#!/usr/bin/env bash

cd /tmp
wget http://apache-mirror.rbc.ru/pub/apache/tomcat/tomcat-7/v7.0.59/bin/apache-tomcat-7.0.59.tar.gz
tar xzf apache-tomcat-7.0.59.tar.gz
mv apache-tomcat-7.0.59 /usr/local/tomcat7
