Nise BOSH Vagrant
=================

NOTE: This is still under development and currently only generates the Vagrantfile, it does not complete the nise-bosh components currently

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
