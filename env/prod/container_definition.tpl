[
    {
        "name": "jenkins",
        "image": "${image}",
        "essential": true,
        "portMappings": [
            {
                "containerPort": 8080
            }
        ],
        "mountPoints": [
            {
                "sourceVolume": "jenkins_home",
                "containerPath": "/var/jenkins_home"
            }
        ],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "jenkins-on-ecs",
                "awslogs-region": "us-east-1",
                "awslogs-stream-prefix": "jenkins"
            }
        }
    }
]