output "CI_MachineIP" {
  value = aws_instance.CI-Machine.public_ip
}

output "CD_MachineIP" {
  value = aws_instance.CD-Machine.public_ip
}
