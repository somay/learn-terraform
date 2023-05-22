output "instance_id" {
  value = aws_instance.example.id
}

output "instance_ip" {
  value = aws_instance.example.public_ip
}

output "instance_role" {
  value = aws_iam_role.instance.arn
}
