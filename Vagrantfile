# -*- mode: ruby -*-
# vi: set ft=ruby :
vagrant_dir = File.expand_path(File.dirname(__FILE__))

# Ensure that shared dirs are available created
FileUtils.mkdir_p(File.dirname(__FILE__)+'/www')

Vagrant.configure("2") do |config|
	# Add the box and settings for virtualbox
	config.vm.box = "wheezy-point-three-vbox"
	config.vm.box_url = "http://dl.dropboxusercontent.com/s/zswmalbfkxmfr1u/wheezy-point-three-vbox.box?dl=1"

	config.vm.provider "virtualbox" do |v|
		v.customize ["modifyvm", :id, "--memory", 512]
	end

	config.vm.hostname = "sslplayground"
	config.hostsupdater.aliases = ["sslplayground.dev"]
	config.vm.network :private_network, ip: "33.55.44.11"

	# Make SSH key available to the box
	config.ssh.forward_agent = true

	# Mount the local project's www/ directory as /var/www inside the virtual machine.
	config.vm.synced_folder "www", "/var/www", :mount_options => [ "dmode=755", "fmode=644" ], :owner => "www-data", :group => "www-data"

	# Sync the salt folder
	config.vm.synced_folder "srv/", "/srv/"

	# Provision the box with Salt
	config.vm.provision :salt do |salt|
		salt.verbose = true
		salt.minion_config = 'minion/vagrant.conf'
		salt.run_highstate = true
	end
end