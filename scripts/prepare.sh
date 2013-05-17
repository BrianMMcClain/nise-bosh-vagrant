#!/bin/bash

# Git bootstrap
sudo apt-get update
sudo apt-get install -y git-core

# If not using local nise-bosh, pull it from github
if [ ! -d "/home/vagrant/nise_bosh" ]; then
  git clone https://github.com/nttlabs/nise_bosh.git /home/vagrant/nise_bosh
fi

# Run nise_bosh init script
(
	cd /home/vagrant/nise_bosh
  	sudo ./bin/init
)

curl -L https://get.rvm.io | bash -s stable
echo -e "\nsource /home/vagrant/.rvm/scripts/rvm" >> /home/vagrant/.profile
source /home/vagrant/.rvm/scripts/rvm
rvm install 1.9.3-p392
rvm use --default 1.9.3-p392

# BOSH CLI
gem install bundler --no-rdoc --no-ri
gem install bosh_cli --no-rdoc --no-ri

(
	cd /home/vagrant/nise_bosh
  	sudo PATH=$PATH bundle install 
)

# Copy install script
cp /home/vagrant/release/.nise_bosh_install.sh /home/vagrant/install_release.sh
chmod +x /home/vagrant/install_release.sh

# Copy manifest file
cp /home/vagrant/release/.nise-bosh-manifest.yml /home/vagrant/manifest.yml

# NFS for SDS
sudo apt-get install nfs-kernel-server
sudo sh -c "echo '/cfsnapshot     127.0.0.1(rw,sync,no_subtree_check)' >> /etc/exports"
sudo mkdir /cfsnapshot
sudo /etc/init.d/nfs-kernel-server restart