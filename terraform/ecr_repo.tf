
resource "aws_ecr_repository" "nexus_repo" {
    name = "nexus-api-repo"
    image_tag_mutability = "MUTABLE"
    force_delete = true
    image_scanning_configuration {
      scan_on_push = true
    }
}