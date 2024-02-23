Vagrant.configure("2") do |config|
  ip_prefix= "192.168.100.1"

  # minions config
  minions = 3
  (1..minions).each do |i|
    config.vm.define "minion#{i}" do |minion|
      minion.vm.box = "almalinux/8"
      minion.vm.hostname = "minion#{i}"
      minion.vm.network :private_network, ip: "#{ip_prefix}#{i}"
      minion.vm.provider :virtualbox do |vb|
        vb.name = "minion#{i}"
        vb.memory = 2048
        vb.cpus = 2
      end
      minion.vm.synced_folder "./data", "/vagrant_data"
      minion.vm.provision "shell", path: "./scripts/install_prerequisite.sh"
    end
  end

  # master config
  i = 0
  config.vm.define "master" do |master|
    master.vm.box = "almalinux/8"
    master.vm.hostname = "master"
    master.vm.network :private_network, ip: "#{ip_prefix}#{i}"
    master.vm.provider :virtualbox do |vb|
      vb.name = "master"
      vb.memory = 2048
      vb.cpus = 2
    end
    master.vm.synced_folder "./data", "/vagrant_data"
    master.vm.provision "shell", path: "./scripts/install_prerequisite.sh"
  end
end
