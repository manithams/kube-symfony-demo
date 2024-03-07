# Symfony Demo Application on Kubernetes (Kind)

This repository provides a guide and configuration files to deploy the Symfony Demo application on a Kubernetes cluster running in KIND (Kubernetes IN Docker) using Terraform for infrastructure provisioning and Helm for application deployment.

## Features
- `kind/`: Configuration file for KinD tool to create a  local Kubernetes cluster using Docker.
- `terraform/`: Directory containing terraform scripts to provision kubernetes componenets (ingress-nginx, mysql, metrics-server).
- `kubernetes`: Kubernetes manifests and Helm chart to deploy the demo application
- `demo`: Application folder which contains the source code, Apache config and Dockerfile

## Prerequisites
Ensure you have the following prerequisites installed:
- [kind](https://kind.sigs.k8s.io/docs/user/quick-start/#installation) - (v0.22.0 go1.21.7)
- [Terraform](https://developer.hashicorp.com/terraform/install?product_intent=terraform) (version v1.7.4 or later)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Helm](https://helm.sh/docs/helm/helm_install/) (v3.8.1)
- [docker](https://docs.docker.com/engine/install/) (25.0.3)

## Provision Infrastructure with KinD & Terraform
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
## Build docker images (Optional)
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
## Deploy Symfony Demo App with Helm
1. **Deploy to kubernetes**: Navigate to Kubernetes directory and apply the follwoing `helm` command to deploy the application to cluster.
- Note: If you are not using the MYSQL server not provisioned by terraform here, then makesure you have configuered correct values in the `kubernetes/symfony-demo-app-chart/values.yaml` and 
```
helm install symfony-demo-app ./symfony-demo-app-chart -n demo
```
## Access Symfony Demo App
Update your local `/etc/hosts` file to map the service URL to the Ingress IP address. Open the `/etc/hosts` file in a text editor and add the following line:
```
127.0.0.1       localhost my-symfony-app.com
```
Access the Symfony Demo app using my-symfony-app.com in your browser.

