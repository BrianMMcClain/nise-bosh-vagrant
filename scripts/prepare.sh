#!/bin/bash

# Install git
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

# Install ruby 1.9.3-p392
curl -L https://get.rvm.io | bash -s stable
echo -e "\nsource /home/vagrant/.rvm/scripts/rvm" >> /home/vagrant/.profile
source /home/vagrant/.rvm/scripts/rvm
rvm install 1.9.3-p392
rvm use --default 1.9.3-p392

# Install BOSH CLI
gem install bundler --no-rdoc --no-ri
gem install bosh_cli --no-rdoc --no-ri

# Bundle nise-bosh gems
(
	cd /home/vagrant/nise_bosh
  	sudo PATH=$PATH bundle install 
)

# Copy install script
cp /home/vagrant/release/.nise-bosh-install.sh /home/vagrant/install_release.sh
chmod +x /home/vagrant/install_release.sh

# Copy start/stop scripts
cp /home/vagrant/scripts/start.sh /home/vagrant/start.sh
chmod +x /home/vagrant/start.sh
cp /home/vagrant/scripts/stop.sh /home/vagrant/stop.sh
chmod +x /home/vagrant/start.sh

# Copy manifest file
cp /home/vagrant/release/.nise-bosh-manifest.yml /home/vagrant/manifest.yml