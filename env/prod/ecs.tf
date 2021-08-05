resource "aws_ecs_cluster" "waiters" {
  name = "Waiters"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_service" "jenkins" {
  name                               = "jenkins"
  cluster                            = aws_ecs_cluster.waiters.id
  task_definition                    = aws_ecs_task_definition.jenkins.arn
  desired_count                      = 1
  health_check_grace_period_seconds  = 300
  launch_type                        = "FARGATE"
  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100

  network_configuration {
    assign_public_ip = true
    subnets          = [aws_subnet.private_1.id, aws_subnet.private_2.id]
    security_groups  = [aws_security_group.jenkins.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.jenkins.arn
    container_name   = "jenkins"
    container_port   = 8080
  }
}

resource "aws_ecs_task_definition" "jenkins" {
  family                   = "serve"
  cpu                      = 512
  memory                   = 1024
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.jenkins_execution_role.arn
  task_role_arn            = aws_iam_role.jenkins_role.arn
  requires_compatibilities = ["FARGATE", "EC2"]

  container_definitions = data.template_file.task_definition.rendered

  volume {
    name = "jenkins_home"

    efs_volume_configuration {
      file_system_id     = aws_efs_file_system.jenkins.id
      transit_encryption = "ENABLED"

      authorization_config {
        access_point_id = aws_efs_access_point.main.id
        iam             = "ENABLED"
      }
    }
  }
}

data template_file task_definition {
  template = file("${path.module}/container_definition.tpl")

  vars = {
    image = var.docker_image
  }
}
