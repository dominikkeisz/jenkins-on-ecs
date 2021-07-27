resource "aws_ecr_repository" "jenkins-on-ecs" {
  name = "jenkins-on-ecs"

  image_scanning_configuration {
    scan_on_push = true
  }
}

data "aws_ecr_image" "service_image" {
  repository_name = "jenkins-on-ecs"
  image_tag       = "latest"
}
