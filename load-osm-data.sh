#! /bin/sh

# load-osm-data.sh
#
# Download OSM data and import to local postgresql database
#
# Usage: ./load-osm-data.sh <URL to [regional] planetfile.osm.pbf>
#

mkdir -p /home/vagrant/osm
cd /home/vagrant/osm

echo '### Downloading OSM Planetfile...'
wget $1

echo '### Cloning osm-bright GitHub Repoistory...'
git clone https://github.com/mapbox/osm-bright.git

echo '### Create OSM Bright Tilemill Project'
cp /vagrant/config/osm-bright-configure.py /home/vagrant/osm/osm-bright/configure.py
cd /home/vagrant/osm/osm-bright
sudo ./make.py
sudo chown -R vagrant:vagrant /home/vagrant/osm/osm-bright

echo '### Importing OSM data...'
cd /home/vagrant/osm
imposm -U vagrant -d osm -m osm-bright/imposm-mapping.py \
    --read --write --optimize --deploy-production-tables *.osm.pbf

echo '### Downloading OSM land polygons...'
sudo mkdir -p /usr/share/mapbox/project/OSMBright/shp
cd /usr/share/mapbox/project/OSMBright/shp
sudo wget http://data.openstreetmapdata.com/simplified-land-polygons-complete-3857.zip
sudo wget http://data.openstreetmapdata.com/land-polygons-split-3857.zip
sudo chown -R mapbox:mapbox /usr/share/mapbox/project/OSMBright/
