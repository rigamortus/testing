#!/usr/bin/env bash
set -euo pipefail

# Install required packages
sudo apt-get update -q
sudo apt-get install -q -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    openjdk-8-jdk \
    git \
    unattended-upgrades \
    firewalld

# Add Docker GPG key and repository
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Add Jenkins GPG key and repository
# sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
#   https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
# echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
#   https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
#   /etc/apt/sources.list.d/jenkins.list > /dev/null
# Install Docker and Jenkins
# sudo apt-get update -q
sudo apt-get install -q -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
#     jenkins

# Modify Jenkins config for IPv4
if ! sudo grep java.net.preferIPv4Stack=true /etc/default/jenkins > /dev/null; then
    #shellcheck disable=SC2016
    echo 'JAVA_ARGS="$JAVA_ARGS -Djava.net.preferIPv4Stack=true"' | sudo tee -a /etc/default/jenkins
fi

# Add users to docker group
sudo usermod -aG docker "$USER"
sudo usermod -aG docker jenkins
newgrp docker

# Enable and start services
sudo systemctl enable docker
sudo systemctl enable jenkins
sudo systemctl enable unattended-upgrades
sudo systemctl enable firewalld
sudo systemctl restart docker
sudo systemctl restart jenkins
sudo systemctl restart unattended-upgrades
sudo systemctl restart firewalld

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Configure firewalld
sudo firewall-cmd --permanent --zone=public --add-service=http
sudo firewall-cmd --permanent --zone=public --add-masquerade
sudo firewall-cmd --permanent --add-forward-port=port=80:proto=tcp:toport=8080
sudo firewall-cmd --permanent --direct --add-rule ipv4 nat OUTPUT 0 -p tcp -o lo --dport 80 -j REDIRECT --to-ports 8080
sudo firewall-cmd --reload

