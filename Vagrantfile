# Vagrantfile to create 1 master and 2 worker Kubernetes nodes
VAGRANTFILE_API_VERSION = "2"

NUM_WORKERS = 2

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/focal64"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 2048
    vb.cpus = 2
  end

  # Master Node
  config.vm.define "k8s-master" do |master|
    master.vm.hostname = "k8s-master"
    master.vm.network "private_network", ip: "192.168.56.10"
    master.vm.provision "shell", path: "provision/master.sh"
  end

  # Worker Nodes
  (1..NUM_WORKERS).each do |i|
    config.vm.define "k8s-worker#{i}" do |worker|
      worker.vm.hostname = "k8s-worker#{i}"
      worker.vm.network "private_network", ip: "192.168.56.12#{i}"
      worker.vm.provision "shell", path: "provision/worker.sh"
    end
  end
end

