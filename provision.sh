#! /bin/sh

# locale
update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# update Repositories:
apt-get update

# install basic packages:
apt-get install -y \
    git \
    htop \
    unzip \
    python-dev \
    python-software-properties \
    python-pip \
    python-psycopg2 \
    build-essential \
    libproj-dev \
    libgeos-dev \
    libgdal-dev \
    protobuf-compiler \
    libprotobuf-dev \
    libtokyocabinet-dev \
    libgeos-c1 \
    postgresql-9.3 \
    postgresql-9.3-postgis-2.1 \
    postgresql-contrib

# install imposm
pip install imposm

# add Tilemill PPa
add-apt-repository -y ppa:developmentseed/mapbox

# update package index:
apt-get update

# install Tilemill:
apt-get install -y \
    tilemill \
    libmapnik \
    nodejs

# deploy custom pg_hba.conf and restart postgres server:
ln -s -f /vagrant/config/pg_hba.conf /etc/postgresql/9.3/main/pg_hba.conf
service postgresql restart

# setup database, db user and postgis
su - postgres -c "psql -c 'CREATE USER vagrant;'"
su - postgres -c "psql -c 'CREATE DATABASE osm OWNER vagrant;'"
su - postgres -c "psql -d osm -c 'CREATE EXTENSION postgis;'"

# configure tilemill
ln -s -f /vagrant/config/tilemill.config /etc/tilemill/tilemill.config

# start tilemill as system service
service tilemill start
