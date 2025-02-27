provider "aws" {
  region = "us-east-1"  # Modify with your region
}

# ECS Cluster
resource "aws_ecs_cluster" "capstone_cluster" {
  arn  = "arn:aws:ecs:us-east-1:116981805219:cluster/my-capstone-cluster"
  name = "my-capstone-cluster"
}

# ECS Service
resource "aws_ecs_service" "capstone_service" {
  availability_zone_rebalancing      = "ENABLED"
  cluster                            = aws_ecs_cluster.capstone_cluster.id
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  desired_count                      = 2
  enable_ecs_managed_tags            = true
  enable_execute_command             = false
  health_check_grace_period_seconds  = 0
  iam_role                           = "/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
  launch_type                        = "FARGATE"
  name                               = "my-capstone-service"
  platform_version                   = "LATEST"
  propagate_tags                     = "NONE"
  scheduling_strategy                = "REPLICA"
  task_definition                    = "my-capstone-task-definition:1"

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  deployment_controller {
    type = "ECS"
  }

  load_balancer {
    container_name   = "my-static-web-container"
    container_port   = 80
    target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:116981805219:targetgroup/my-capstone-tg/1f20f8806ce97fed"
  }

  network_configuration {
    assign_public_ip = true
    security_groups  = ["sg-0ffaecdb585361d87"] # This can be kept if using the default security group
    subnets          = [
      "subnet-020cca70f68329e2b",
      "subnet-038cb1f846d91372d",
      "subnet-08693f9128a8cf5e1",
      "subnet-0b047f9a99a9446ed",
      "subnet-0b4f5bf72a0a4b179",
      "subnet-0da792e895ec9bec0"
    ]
  }

  alarms {
    alarm_names = []
    enable      = false
    rollback    = false
  }
}

# ECR Repository
resource "aws_ecr_repository" "capstone_ecr" {
  name = "my-capstone-repo"
}

# Load Balancer
resource "aws_lb" "my_capstone_lb" {
  name               = "my-capstone-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["<your-security-group-id>"]
  subnets            = ["<your-subnet-id-1>", "<your-subnet-id-2>"]
  enable_deletion_protection = false
  idle_timeout {
    timeout_seconds = 60
  }

  tags = {
    Name = "my-capstone-lb"
  }
}

# Target Group for ALB
resource "aws_lb_target_group" "capstone_tg" {
  name     = "my-capstone-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "<your-vpc-id>"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name = "my-capstone-tg"
  }
}

# IAM Role (if applicable)
resource "aws_iam_role" "capstone_role" {
  name = "my-capstone-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Effect    = "Allow"
        Sid       = ""
      }
    ]
  })

  tags = {
    Name = "my-capstone-role"
  }
}
