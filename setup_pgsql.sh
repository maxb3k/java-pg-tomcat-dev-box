#!/usr/bin/env bash

#based on https://wiki.postgresql.org/wiki/YUM_Installation

PG_VERSION=9.4
PG_PACKAGE_NAME=postgresql94-server
PG_SERVICE_NAME=postgresql-9.4
PG_CONF="/var/lib/pgsql/$PG_VERSION/data/postgresql.conf"
PG_HBA="/var/lib/pgsql/$PG_VERSION/data/pg_hba.conf"
PG_DIR="/var/lib/pgsql/$PG_VERSION/data"

#check postgres already installed
if yum list installed "$PG_PACKAGE_NAME" >/dev/null 2>&1
then
  echo "Postgres alresdy installed"
  exit 0
fi

#setup package manager
if ! grep -Fq "exclude=postgresql*" /etc/yum/pluginconf.d/rhnplugin.conf
then
  echo 'exclude=postgresql*' >> /etc/yum/pluginconf.d/rhnplugin.conf
fi

yes | yum localinstall http://yum.postgresql.org/9.4/redhat/rhel-7-x86_64/pgdg-oraclelinux94-9.4-1.noarch.rpm

#install postgres package
yes | yum install $PG_PACKAGE_NAME

#Initialize
/usr/pgsql-9.4/bin/postgresql94-setup initdb

#Startup automatically when the OS starts
chkconfig $PG_SERVICE_NAME on

# Edit postgresql.conf to change listen address to '*':
sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" "$PG_CONF"

# Customize pg_hba.conf to acceept all connections:
sed -i "s/^local\s\+all\s\+all\s\+ident/local all all trust/g" "$PG_HBA"
    sed -i "s/^host\s\+all\s\+all\s\+\(.*\)\s\+ident/host all all \1 trust/g" "$PG_HBA"
echo "host    all             all             0.0.0.0/0                     trust" >> "$PG_HBA"

# Explicitly set default client_encoding
echo "client_encoding = utf8" >> "$PG_CONF"

# Restart so that all new config is loaded:
service $PG_SERVICE_NAME restart

#Create DB
cat << EOF | su - postgres -c psql
-- Create the database user:
CREATE USER wso2 WITH PASSWORD 'password';

-- Create the database:
CREATE DATABASE wso2 WITH OWNER=wso2;

EOF
