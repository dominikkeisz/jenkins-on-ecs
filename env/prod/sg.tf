resource "aws_security_group" "loadbalancer" {
  name        = "jenkins-loadbalancer-sg"
  description = "Security group for load balancer"
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group" "jenkins" {
  name        = "jenkins-sg"
  description = "Security group for Jenkins"
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group" "efs" {
  name        = "jenkins-efs-sg"
  description = "Enable EFS access via port 2049"
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group_rule" "ingress_tls" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.loadbalancer.id
}

resource "aws_security_group_rule" "egress_http" {
  type              = "egress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  security_group_id = aws_security_group.loadbalancer.id
  source_security_group_id = aws_security_group.jenkins.id
}

resource "aws_security_group_rule" "ingress_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  security_group_id = aws_security_group.jenkins.id
  source_security_group_id = aws_security_group.loadbalancer.id
}

resource "aws_security_group_rule" "ingress_nfs" {
  type              = "ingress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  security_group_id = aws_security_group.efs.id
  source_security_group_id = aws_security_group.jenkins.id
}