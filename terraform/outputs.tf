output "ecr_repo_url" {
  value = aws_ecr_repository.nexus_repo.repository_url
}
output "instance_ip" {
  value = aws_instance.nexus_host.public_ip
}
output "instance_id" {
  value = aws_instance.nexus_host.id
}
output "alb_dns_name" {
  value = aws_alb.nexus_alb.dns_name
}