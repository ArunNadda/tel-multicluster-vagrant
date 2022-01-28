Vagrant.configure("2") do |config|
    config.vm.provision "shell", inline: <<-SHELL
        apt-get update -y
        echo "10.0.0.15  proxy-node proxy-node.akn-teleport-vagrant01.com" >> /etc/hosts
        echo "10.0.0.15  teletron-proxy teletron-proxy.akn-teleport-vagrant01.com" >> /etc/hosts
        echo "10.0.0.16  auth-node auth.akn-teleport-vagrant01.com" >> /etc/hosts
        echo "10.0.0.16  auth auth.akn-teleport-vagrant01.com" >> /etc/hosts
        echo "10.0.0.200  ssh-node" >> /etc/hosts
        echo "10.0.0.55  proxy-node02 proxy-node02.akn-teleport-vagrant02.com" >> /etc/hosts
        echo "10.0.0.55  teletron-proxy02 teletron-proxy02.akn-teleport-vagrant02.com" >> /etc/hosts
        echo "10.0.0.56  auth-node02 auth-node02.akn-teleport-vagrant02.com" >> /etc/hosts
        echo "10.0.0.56  auth02 auth02.akn-teleport-vagrant02.com" >> /etc/hosts
    SHELL

    config.vm.define "auth" do |master|
      master.vm.box = "spox/ubuntu-arm"
      master.vm.hostname = "auth-node"
      master.vm.network "private_network", ip: "10.0.0.16"
      master.vm.provider "vmware_desktop" do |vb|
          vb.memory = 1024
          vb.cpus = 1
      end
      master.vm.provision "shell", path: "scripts/common.sh"
      master.vm.provision "shell", path: "scripts/auth.sh"
      master.vm.provision "shell", path: "scripts/dyn-tokens.sh"
    end
    
    config.vm.define "proxy" do |master|
      master.vm.box = "spox/ubuntu-arm"
      master.vm.hostname = "proxy-node"
      master.vm.network "private_network", ip: "10.0.0.15"
      master.vm.provider "vmware_desktop" do |vb|
          vb.memory = 1024
          vb.cpus = 1
      end
      master.vm.provision "shell", path: "scripts/common.sh"
      master.vm.provision "shell", path: "scripts/proxy.sh"
    end

    
    config.vm.define "sshnode" do |master|
      master.vm.box = "spox/ubuntu-arm"
      master.vm.hostname = "ssh-node"
      master.vm.network "private_network", ip: "10.0.0.200"
      master.vm.provider "vmware_desktop" do |vb|
          vb.memory = 1024
          vb.cpus = 1
      end
      master.vm.provision "shell", path: "scripts/common.sh"
      master.vm.provision "shell", path: "scripts/node.sh"
    end


    config.vm.define "auth02" do |master|
      master.vm.box = "spox/ubuntu-arm"
      master.vm.hostname = "auth-node02"
      master.vm.network "private_network", ip: "10.0.0.56"
      master.vm.provider "vmware_desktop" do |vb|
          vb.memory = 1024
          vb.cpus = 1
      end
      master.vm.provision "shell", path: "scripts/common.sh"
      master.vm.provision "shell", path: "scripts/auth02.sh"
      master.vm.provision "shell", path: "scripts/dyn-tokens02.sh"
    end

    config.vm.define "proxy02" do |master|
      master.vm.box = "spox/ubuntu-arm"
      master.vm.hostname = "proxy-node02"
      master.vm.network "private_network", ip: "10.0.0.55"
      master.vm.provider "vmware_desktop" do |vb|
          vb.memory = 1024
          vb.cpus = 1
      end
      master.vm.provision "shell", path: "scripts/common.sh"
      master.vm.provision "shell", path: "scripts/proxy02.sh"
    end
  end
