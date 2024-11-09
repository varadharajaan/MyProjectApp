#!/bin/bash

# Update the system
dnf update -y

# Set hostname to jenkins-server
hostnamectl set-hostname jenkins-server

# Add the hostname entry to /etc/hosts
echo "127.0.0.1 jenkins-server" >> /etc/hosts

# Install Java (Jenkins requirement)
dnf install java-17-amazon-corretto -y

# Add Jenkins repository
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Install Jenkins
dnf install jenkins -y

# Start Jenkins service
systemctl start jenkins
systemctl enable jenkins

# Install useful packages
dnf install git docker -y

# Start Docker service
systemctl start docker
systemctl enable docker

# Add ec2-user to docker group
usermod -aG docker ec2-user

# Create a script to display Jenkins initial admin password
echo '#!/bin/bash
echo "Jenkins Initial Admin Password:"
cat /var/lib/jenkins/secrets/initialAdminPassword
echo "\nJenkins URL:"
echo "http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):8080"' > /root/jenkins_info.sh

chmod +x /root/jenkins_info.sh

# Display Jenkins information after installation
/root/jenkins_info.sh