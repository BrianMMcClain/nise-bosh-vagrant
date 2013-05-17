Nise BOSH Vagrant
=================

Nise BOSH Vagrant is a mashup of [nise_bosh](https://github.com/nttlabs/nise_bosh) and [Vagrant](http://www.vagrantup.com/)


Requirements
------------
- Vagrant >= v1.2 (Not tested on anything older)
- A BOSH release to run
- A custom manifest file


Usage
-----
`nise-bosh-vagrant <Path to Release> --manifest <Path to manifest>`

This will generate a Vagrantfile, spin up a VM, and use nise_bosh to deploy your BOSH release as defined in the manifest file

```
$ cd </path/to/release>
$ vagrant ssh
$ ./install_release.sh
$ ./start.sh
```

What does that command do?
--------------------------

1. Generate a Vagrantfile, install scripts, etc
2. Boot up a lucid64 image in Vagrant and install prerequisites
3. Create management scripts

Management Scripts
------------------
* `/home/vagrant/install_release.sh` -- Install your BOSH release using nise_bosh
* `/home/vagrant/start.sh` -- Start the BOSH release jobs after they've been installed
* `/home/vagrant/stop.sh` -- Stop the BOSH release jobs
