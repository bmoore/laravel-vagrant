# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/trusty32"

  config.vm.network :forwarded_port, guest: 1337, host: 5050
  config.vm.network :forwarded_port, guest: 80, host: 8081

  config.vm.synced_folder ".", "/var/www/", owner: "www-data", group: "www-data"

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file  = "init.pp"
  end

end
