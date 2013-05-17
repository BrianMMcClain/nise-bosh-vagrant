require 'erb'
require 'pty'
require 'yaml'

module NiseBOSHVagrant
	class Runner

		attr_reader :release_path, :nise_path, :scripts_path, :vagrantfile_path, :manifest_file, :manifest_copy_path, :install_script_path

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

		def copy_manifest(output_dir=@release_path, manifest_file=@manifest_file)
			@manifest_copy_path = File.join(output_dir, '.nise-bosh-manifest.yml')
			FileUtils.cp(manifest_file, @manifest_copy_path)
		end

		def generate_install_script(output_dir=@release_path, manifest_file=@manifest_copy_path)
			manifest = YAML.load_file manifest_file
			jobs = []
			manifest['jobs'].each do |job|
				jobs << job['name']
			end

			puts "Job list: #{jobs}"

			install_script_template = File.open(File.join(File.dirname(File.expand_path(__FILE__)), '../../resources/install_release.sh.erb'), "rb") { |f| f.read }
			install_script_erb = ERB.new install_script_template

			install_script = "#!/bin/bash\n\n"
			install_script += "(\n"
			install_script += "		cd /home/vagrant/nise_bosh\n"


			jobs.each do |job|
				manifest_path = "/home/vagrant/release/.nise-bosh-manifest.yml"
				job_name = job
				install_entry = install_script_erb.result(binding)
				install_script += "#{install_entry}\n"
			end

			install_script += ")"

			@install_script_path = File.join(output_dir, ".nise_bosh_install.sh")
			File.open(@install_script_path, "wb") { |f| f.write(install_script) }
			FileUtils.chmod 0755, @install_script_path
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