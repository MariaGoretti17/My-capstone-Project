variable "aws_region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
  default     = "my-capstone-cluster"
}

variable "service_name" {
  description = "Name of the ECS service"
  type        = string
  default     = "my-capstone-service"
}

variable "repository_name" {
  description = "ECR repository name"
  type        = string
  default     = "my-capstone-ecr"
}

variable "task_family" {
  description = "ECS task definition family name"
  type        = string
  default     = "my-capstone-task"
}

variable "container_name" {
  description = "Container name in the task definition"
  type        = string
  default     = "my-capstone-container"
}

variable "container_port" {
  description = "Port on which the container listens"
  type        = number
  default     = 80
}
