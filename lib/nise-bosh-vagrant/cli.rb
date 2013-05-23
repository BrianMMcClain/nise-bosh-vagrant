require 'trollop'

require 'nise-bosh-vagrant/runner'
require 'nise-bosh-vagrant/version'

module NiseBOSHVagrant
	class CLI

		def self.start
			opts = Trollop::options do
				  version NiseBOSHVagrant::VERSION
  banner <<-EOS
Based on nise-bosh from NTT Labs and Vagrant from HashiCorp

Requires Vagrant >= 1.2

Usage:
       nise-bosh-vagrant [options] <BOSH Release>

Options:
EOS

				opt :manifest, "Path to manifest file", :type => :string
				opt :nise, "Path to nise-bosh if you don't wish to pull HEAD of master from GitHub", :type => :string
				opt :install, "Run install script after preparing the VM"
				opt :start, "Start all jobs after installing them (implies --install)"
				opt :memory, "Amount of memory to allocate to the VM in MB", :type => :integer, :default => 512
			end

			Trollop::die :manifest, "must provide a manifest file" if opts[:manifest].nil?
			Trollop::die :manifest, "must exist" unless File.exist?(opts[:manifest])

			opts[:release] = ARGV[0]

			if opts[:start]
				opts[:install] = true
			end

			# Generate, start and prepare a fresh VM
			runner = NiseBOSHVagrant::Runner.new(opts)
			runner.generate_vagrantfile
			runner.copy_manifest
			runner.generate_install_script
			puts "---> Starting Vagrant VM"
			runner.start_vm
			puts "---> Preparing Vagrant VM"
			runner.prepare_vm

			# If instructed, install the release
			if opts[:install]
				puts "---> Installing release"
				runner.install_release
			end

			# If instructed, start the release
			if opts[:start]
				puts "---> Starting release"
				runner.start_release
			end
		end

	end
end