output "instance_ip" {
  description = "The public ip for ssh access"
  value       = aws_instance.lab-vm.public_ip
}