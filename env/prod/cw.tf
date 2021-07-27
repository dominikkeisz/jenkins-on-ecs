resource "aws_cloudwatch_log_group" "jenkins" {
  name              = "jenkins-on-ecs"
  retention_in_days = 14
}
