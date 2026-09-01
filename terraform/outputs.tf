output "ecr_repo_url" {
  value = aws_ecr_repository.nexus_repo.repository_url
}