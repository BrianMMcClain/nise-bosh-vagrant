require 'trollop'

require 'nise-bosh-vagrant/initializer'
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
       nise-bosh-vagrant [options] <BOSH Release>+

Options:
EOS

				opt :manifest, "Path to manifest file", :type => :string
				opt :nise, "Path to nise-bosh if you don't wish to pull HEAD of master from GitHub", :type => :string
			end

			Trollop::die :manifest, "must provilde a manifest file" if opts[:manifest].nil?
			Trollop::die :manifest, "must exist" unless File.exist?(opts[:manifest])

			opts[:release] = ARGV[0]

			init = NiseBOSHVagrant::Initializer.new(opts)
			init.generate_vagrantfile
			init.start_vm
			init.prepare_vm
		end

	end
end