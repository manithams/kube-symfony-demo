# Symfony Demo Application on Kubernetes (Kind)

This repository contains the configuration files and application code to deploy and run the Symfony demo app on a Kubernetes cluster.

## Overview
The Symfony demo app is a simple Symfony application that showcases various features of the Symfony framework. This repository provides the necessary configuration files and Kubernetes manifests to deploy the Symfony demo app on a Kubernetes cluster.

## Features
- `kind/`: Configuration file for KinD tool to create a  local Kubernetes cluster using Docker.
- `terraform/`: Directory containing terraform scripts to provision kubernetes componenets (ingress-nginx, mysql).
- `kubernetes`: Kubernetes manifests and Helm chart to deploy the demo application
- `demo`: Application folder which contains the source code, Apache config and Dockerfile

## Prerequisites
Ensure you have the following prerequisites installed:
- kind - (v0.22.0 go1.21.7)
- Terraform (version v1.7.4 or later)
- kubectl
- Helm (v3.8.1)
- docker (25.0.3)

## Deployment
1. **Kind**: Navigate to the `kind/` directory and update the `lingoda-config.yaml` accordingly and then execute the following commands:
``````
kind create cluster --config kind/lingoda-config.yaml
``````
2. **Terraform**: Upon creating the cluster navigate to the `terraform/` directory and execute the following commands:
- Note: Makesure to update the terraform state file location. Currently this is configuered to store the terraform state in a remote S3 bucket.
in `terraform/provider.tf`
````
 ...
  backend "s3" {
    bucket = "lingoda-tf-state"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
 ...
```` 
Use following commands 
```
terraform init
terraform plan
terraform apply   
```
3. **Docker**: Navigate to `demo` directory and build the container image.
- Note: A Public repository in Docker Hub already created to push the images 
```
 docker build -t demo-app .
```
Tag the built container.
```
docker tag demo-app manithams/symfony-demo-app:01
```
Push the image to the container registry (Docker hub)
```
docker push manithams/symfony-demo-app:01
```

4. **Deploy to kubernetes**: Navigate to Kubernetes directory and apply the follwoing `helm` command to deploy the application to cluster.
- Note: Makesure you have configuered correct values in the `kubernetes/symfony-demo-app-chart/values.yaml`
```
helm install symfony-demo-app ./symfony-demo-app-chart --set tag=65
```