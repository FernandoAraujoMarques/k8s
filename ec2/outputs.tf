output "public_ip" {
  value       = element(concat(aws_instance.k8s.*.public_ip,[""]), 0)
}