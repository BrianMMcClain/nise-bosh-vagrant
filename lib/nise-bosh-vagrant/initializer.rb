require 'erb'

module NiseBOSHVagrant
	class Initializer

		attr_reader :release_path, :nise_path, :scripts_path, :vagrantfile_path, :manifest_file

		def initialize(opts)
			opts[:nise].nil? ? @nise_path = nil : @nise_path = opts[:nise]
			@release_path = opts[:release]
			@vagrantfile_path = File.join(@release_path, "Vagrantfile")
			@scripts_path = File.join(File.dirname(File.expand_path(__FILE__)), "../../scripts")
			@manifest_file = opts[:manifest]
		end

		def generate_vagrantfile(output_path=@vagrantfile_path)
			vagrantfile_template = File.open(File.join(File.dirname(File.expand_path(__FILE__)), '../../resources/Vagrantfile.erb'), "rb") { |f| f.read }
			template = ERB.new vagrantfile_template
			vagrantfile = template.result(binding)
			File.open(output_path, "wb") { |f| f.write(vagrantfile) }
		end

	end
end