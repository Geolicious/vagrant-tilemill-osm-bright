# Vagrant - Tilemill OSM-Bright Template

A preconfigured Vagrant box running Ubuntu 14.04, Tilemill and PostgreSQL/Postgis.
Tilemill will be accesible via Browser on http://localhost:20009.

## Get Started:

- install Vagrant and Virtualbox
- run `vagrant up` on your local machine inside the repository.
- wait for vagrant to complete downloading the Ubuntu base box and installing the software
- log into the VM by running `vagrant ssh`

## Download OSM Data and Import to PostgreSQL:

Inside the VM you can run the `load-osm-data.sh` script to download OSM
data and import it to PostgreSQL. It will also setup OSM Bright.

When running the script, attach the download address of an OSM Planet file:

```bash
./load-osm-data.sh https://s3.amazonaws.com/metro-extracts.mapzen.com/leipzig_germany.osm.pbf
```

Example Download Sources:

- https://mapzen.com/data/metro-extracts
- http://download.geofabrik.de/

Depending on the size of the planet file, the download/import will take
some time.

## Use a Digital Ocean VPS instead of Virtualbox as provider

Install vagrant-digitalocean provider

`vagrant plugin install vagrant-digitalocean`

Start a box with provider digital_ocean

`vagrant up --provider=digital_ocean`

The vagrant-digitalocean Provider does not support port forwarding at the moment,
so you need to forward them manually each time you want to work with Tilemill.

- after creation, log into your box with `vagrant ssh remote`
- run the following to get the public IP of your Digital Ocean box

  ```bash
  echo `ifconfig eth0 | grep 'inet addr:'| cut -d: -f2 | awk '{ print $1}'`
  ```

- on your host machine, run

  ```bash
  ssh -CA vagrant@<your-public-ip> -L 20009:localhost:20009 -L 20008:localhost:20008
  ```

- and leave that running while working with Tilemill
- you can now access Tilemill via http://localhost:20009 in your browser


__Warning__

Depending on the size of the Digitalocean droplet you are running, you
get charged as your box is existing. Because the ressources are reserved,
you get charged for a stopped droplet too. If you dont want to pay while
not working on it, you can destroy the droplet with vagrant:
`vagrant destroy remote`.
The downside is that you have to run your data import every time you
recreate the droplet.
