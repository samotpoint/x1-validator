output "command_to_connect_to_ec2_instance" {
  value       = "ssh -i ./${var.ssh_key_pair_path}/${var.namespace}-${var.environment}-${var.service_name} ubuntu@${aws_instance.go_x1_instance.public_ip}"
  description = "Command to connect to EC2 instance"
}
