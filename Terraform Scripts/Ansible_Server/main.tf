resource "aws_instance" "AnsibleServer" {
  ami                    = data.aws_ami.amazonlinux2.id
  instance_type          = var.my_instance_type
  key_name               = var.my_key
  vpc_security_group_ids = [aws_security_group.web-traffic.id]

  tags = {
    "Name" = "Ansible-Serve"
  }
}

output "public_ip" {
  value = aws_instance.AnsibleServer.public_ip
}

# Output the instance ID
output "instance_id" {
  value = aws_instance.AnsibleServer.id
}

# Output SSH connection command
output "ssh_connection" {
  value = "ssh ec2-user@${aws_instance.AnsibleServer.public_ip}"
}