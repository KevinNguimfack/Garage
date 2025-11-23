#!/bin/bash

# Disable swap
swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab

# Install tools
apt-get update
apt-get install -y apt-transport-https curl containerd gpg ca-certificates
mkdir -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.34/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Set up containerd
mkdir -p /etc/containerd
containerd config default > /etc/containerd/config.toml
systemctl restart containerd
systemctl enable containerd

# Install kubeadm, kubelet, kubectl
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.34/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

# Wait for master join script
while [ ! -f /vagrant/join.sh ]; do
  echo "Waiting for join.sh..."
  sleep 10
done

# Join the cluster
bash /vagrant/join.sh

