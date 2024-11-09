#!/bin/bash

# Update the system
dnf update -y

# Set hostname to jenkins-server
hostnamectl set-hostname jenkins-server

# Add the hostname entry to /etc/hosts
echo "127.0.0.1 jenkins-server" >> /etc/hosts

# Install Java 17
dnf install java-17-amazon-corretto java-17-amazon-corretto-devel -y

# Set JAVA_HOME
echo "export JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto" >> /etc/profile
echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/profile

# Install Maven
wget https://dlcdn.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz
tar xf apache-maven-3.9.6-bin.tar.gz -C /opt
ln -s /opt/apache-maven-3.9.6 /opt/maven

# Set Maven environment variables
echo "export M2_HOME=/opt/maven" >> /etc/profile
echo "export M2=\$M2_HOME/bin" >> /etc/profile
echo "export PATH=\$M2:\$PATH" >> /etc/profile

# Source the profile to apply the environment variables
source /etc/profile

# Add Jenkins repository
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Install Jenkins
dnf install jenkins -y

# Configure Jenkins to use Java 17
echo 'JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto' >> /etc/sysconfig/jenkins

# Start Jenkins service and enable it to start on boot
systemctl start jenkins
systemctl enable jenkins

# Install Git
dnf install git -y

# Create a script to display Jenkins initial admin password and verify installations
cat << 'SCRIPT' > /root/jenkins-info.sh
#!/bin/bash
echo "Jenkins Initial Admin Password:"
cat /var/lib/jenkins/secrets/initialAdminPassword

echo -e "\nJenkins URL:"
echo "http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):8080"

echo -e "\nJava Version:"
java -version

echo -e "\nMaven Version:"
mvn -version
SCRIPT

# Make the script executable
chmod +x /root/jenkins-info.sh

# Make environment variables available to all users
echo "source /etc/profile" >> /etc/bashrc

# Display Jenkins information after installation
/root/jenkins-info.sh

# Save the output to a file for later reference
/root/jenkins-info.sh > /root/installation_info.txt
