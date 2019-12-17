output "server_instance_public_ip_addr" {
    value = aws_instance.elk-server.public_ip
}

output "server_instance_private_ip_addr" {
    value = aws_instance.elk-server.private_ip
}

output "client_instance_public_ip_addr" {
    value = aws_instance.elk-client.public_ip
}

output "client_instance_private_ip_addr" {
    value = aws_instance.elk-client.private_ip
}

output "SSH-Login-ELKServer-command" {
    value = "ssh -i ${var.keyname}.pem ${var.user}@${aws_instance.elk-server.public_dns}"
}

output "SSH-Login-client-logs-command" {
    value = "ssh -i ${var.keyname}.pem ${var.user}@${aws_instance.elk-client.public_dns}"
}

output "Kibana-interface" {
    value = "http://${aws_instance.elk-server.public_ip}:5601"
}