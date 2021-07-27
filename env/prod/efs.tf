resource "aws_efs_file_system" "jenkins" {
  creation_token = "jenkins-home"
  encrypted      = true

  tags = {
    Name = "EFS - Jenkins"
  }
}
