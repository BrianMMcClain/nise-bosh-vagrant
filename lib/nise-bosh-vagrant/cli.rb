require 'trollop'

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

				opt :nise, "Path to nise-bosh if you don't wish to pull HEAD of master from GitHub", :type => :string
			end

			opts[:release] = ARGV[0]
			puts opts
		end

	end
end