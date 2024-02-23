#!/bin/bash

echo "---------- Install prerequisite on $(hostname) ----------"

# Configure SSH
echo "[1]: Allow external ssh login on vbox on $(hostname)"
sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config

echo "[2]: Disable Password authentication on $(hostname)"
sudo sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
sudo sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config
sudo sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
sudo sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
sudo sed -i 's/.ssh/ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/g' /etc/ssh/sshd_config

echo "[3]: Copy Host ssh key on $(hostname)"
cat /vagrant_data/id_rsa.pub >> .ssh/authorized_keys

echo "[4]: Restart sshd on on $(hostname)"
sudo systemctl restart sshd

# Configure DNS
echo "[5]: Configure /etc/hosts on $(hostname)"
cat /vagrant_data/hosts >> /etc/hosts

# Disable swap
echo "[6]: Disable swap on $(hostname)"
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Set SELinux in permissive mode
echo "[7]: Set SELinux in permissive mode on $(hostname)"
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

# Load Almalinux GPGkey from url 
echo "[8]: Load Almalinux GPGkey from url  on $(hostname)"
sudo sed -i 's/file:\/\/\/etc\/pki\/rpm-gpg\/RPM-GPG-KEY-AlmaLinux/https:\/\/repo.almalinux.org\/almalinux\/RPM-GPG-KEY-AlmaLinux/g' /etc/yum.repos.d/almalinux*

# Install python prerequisite
echo "[9]: Install python prerequisite on $(hostname)"
sudo dnf install -y openssl-devel bzip2-devel libffi-devel
sudo dnf groupinstall -y "Development Tools"

# Install Python 3.8
echo "[10]: Install Python 3.8 on $(hostname)"
sudo dnf install -y python38
