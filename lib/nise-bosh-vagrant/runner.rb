require 'erb'
require 'pty'

module NiseBOSHVagrant
	class Runner

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

		def exec(cmd)
			begin
				PTY.spawn (cmd) do |stdout, stdin, pid|
					begin
						stdout.each { |line| print line }
					rescue Errno::EIO
					end
				end
			rescue PTY::ChildExited
			end
		end

		def start_vm(release_path=@release_path)
			up_cmd = "cd #{release_path} ; vagrant up"
			self.exec(up_cmd)
			
		end

		def prepare_vm(release_path=@release_path)
			prepare_cmd = "cd #{release_path} ; vagrant ssh -c \"/home/vagrant/scripts/prepare.sh\""
			self.exec(prepare_cmd)
		end
	end
end