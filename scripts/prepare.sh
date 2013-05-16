#!/bin/bash -ex

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

# Ruby
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
. ~/.bash_profile
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
rbenv install 1.9.3-p392
rbenv global 1.9.3-p392

# BOSH CLI
gem install bundler
gem install bosh_cli
rbenv rehash

(
	cd /home/vagrant/nise_bosh
  	bundle install
)

# NFS for SDS
sudo apt-get install nfs-kernel-server
sudo sh -c "echo '/cfsnapshot     127.0.0.1(rw,sync,no_subtree_check)' >> /etc/exports"
sudo mkdir /cfsnapshot
sudo /etc/init.d/nfs-kernel-server restart