resource "aws_efs_file_system" "jenkins" {
  creation_token = "jenkins-home"
  encrypted      = true

  tags = {
    Name = "EFS - Jenkins"
  }
}

resource "aws_efs_mount_target" "target_1" {
  file_system_id  = aws_efs_file_system.jenkins.id
  subnet_id       = aws_subnet.private_1.id
  security_groups = [aws_security_group.efs.id]
}

resource "aws_efs_mount_target" "target_2" {
  file_system_id  = aws_efs_file_system.jenkins.id
  subnet_id       = aws_subnet.private_2.id
  security_groups = [aws_security_group.efs.id]
}

resource "aws_efs_access_point" "main" {
  file_system_id = aws_efs_file_system.jenkins.id

  posix_user {
    uid = 1000
    gid = 1000
  }

  root_directory {
    path = "/jenkins-home"

    creation_info {
      owner_uid   = 1000
      owner_gid   = 1000
      permissions = 755
    }
  }
}
