terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.74.0"
    }
  }
  backend "consul" {
    address = "localhost:8500"
    scheme  = "http"
    path    = "jenkins-server"
  }
}