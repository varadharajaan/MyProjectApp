#!/bin/bash

# Update the system hostname
echo "ansible-server" | sudo tee /etc/hostname

echo "127.0.0.1 ansible-server" >> /etc/hosts 

# The following commands will be executed after the reboot (manually or via cron job):

# Create a new user ansadmin and set a password
sudo useradd ansadmin
echo "ansadmin:rootusr" | sudo chpasswd

# Add ansadmin to sudoers with NOPASSWD option
echo "ansadmin ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers

# Modify the SSH configuration to enable password authentication
# Remove any existing PasswordAuthentication line and insert PasswordAuthentication yes
sudo sed -i '/^#\?PasswordAuthentication.*/d' /etc/ssh/sshd_config && echo 'PasswordAuthentication yes' | sudo tee -a /etc/ssh/sshd_config


# Reload the SSH service
sudo service sshd reload

# Switch to ansadmin user and generate SSH keys
sudo su - ansadmin -c "ssh-keygen -t rsa -f ~/.ssh/id_rsa -q -N ''"

# Install Ansible on the system
sudo amazon-linux-extras install ansible2 -y

# Verify Ansible installation
ansible --version

# Change directory to /opt
cd /opt

# Create a directory named docker
sudo mkdir docker

# Change ownership of the docker directory to ansadmin
sudo chown ansadmin:ansadmin docker

# Change directory to /opt/docker
cd /opt/docker

# Install Docker
sudo yum install -y docker

# Add the user ansadmin to the docker group
sudo usermod -aG docker ansadmin

# Verify ansadmin's group memberships to ensure docker is listed
id ansadmin

# Start the Docker service
sudo service docker start

# Start Docker with systemd
sudo systemctl start docker

# Ensure Docker starts on boot
sudo systemctl enable docker

# Ensure Docker status
sudo systemctl status docker

# Change directory back to /opt/docker
cd /opt/docker

