#!/bin/bash

# 1. Download and install kubectl
echo "Downloading kubectl..."
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.27.1/2023-04-19/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv kubectl /bin
echo "kubectl installed."

# 2. Download and install eksctl
echo "Downloading eksctl..."
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /bin
echo "eksctl installed."

# 3. Install AWS CLI
echo "Downloading AWS CLI v2..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
echo "AWS CLI installed."

# 4. Modify SSH configuration to allow root login
echo "Modifying SSH configuration..."
sudo sed -i 's/^#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
sudo sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config


# 5. Set root password (WARNING: Storing plaintext password in a script is insecure)
echo "Setting root password..."
echo "root:rootusr" | sudo chpasswd

# 6. Reload SSH service
echo "Reloading SSH service..."
sudo service sshd reload
echo "SSH service reloaded. Root login is now enabled."

echo "All tasks completed."
