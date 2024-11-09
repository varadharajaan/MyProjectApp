resource "aws_instance" "AnsibleServer" {
  ami                    = data.aws_ami.amazonlinux2.id
  instance_type          = var.my_instance_type
  key_name               = var.my_key
  vpc_security_group_ids = [aws_security_group.web-traffic.id]

  tags = {
    "Name" = "Ansible-Server"
  }
}

output "name" {
  # display public ip of Jenkins Server
  value = aws_instance.AnsibleServer.public_ip
  
}