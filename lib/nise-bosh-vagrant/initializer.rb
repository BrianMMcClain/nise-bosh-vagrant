require 'erb'

module NiseBOSHVagrant
	class Initializer

		attr_reader :release_path, :nise_path

		def initialize(opts)
			opts[:nise].nil? ? @nise_path = nil : @nise_path = opts[:nise]
			@release_path = opts[:release]
		end

		def generate_vagrantfile
			vagrantfile_template = File.open(File.join(File.dirname(File.expand_path(__FILE__)), '../../resources/Vagrantfile.erb'), "rb") { |f| f.read }
			template = ERB.new vagrantfile_template
			vagrantfile = template.result(binding)
			puts vagrantfile
		end

	end
end