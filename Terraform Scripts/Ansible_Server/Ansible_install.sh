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
sudo sed -i 's/^#PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Reload the SSH service
sudo service sshd reload

# Switch to ansadmin user and generate SSH keys
sudo su - ansadmin -c "ssh-keygen -t rsa -f ~/.ssh/id_rsa -q -N ''"

# Install Ansible on the system
sudo amazon-linux-extras install ansible2 -y

# Verify Ansible installation
ansible --version
