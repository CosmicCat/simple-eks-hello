# Simple EKS Cluster

## Purpose

Minimal terraform, helm charts and docker image to run a simple hello world application in 

## Prerequisites

To run the terraform, you need an AWS IAM user with strong permissions against IAM and EKS. A real world application would need a user with more granular permissions specific to this purpose. My user had the following permissions:

* `iam:*` on `*`
* `eks:*` on `*`
* `ec2:*` on `*` - might not be necessary

Otherwise - I used:
* helm `v3.10.1`
* terraform `v1.3.5`
* awscli `2.8.8`

## Contents

* **helm** - home of simple-eks-hello - helm chart for this example
* **terraform** - set of terraform modules to build out EKS and supporting infra
* **image** - docker build for the hello world docker container

## Installation Steps

### Run Terraform

```
# terraforms are located here
cd terraform

# run terraform
terraform init
terraform apply

# back to root when done
cd ..
```

### Point kubectl at Control Plane

```
aws eks --region us-west-1 update-kubeconfig --name example
```

### Build and Push Docker Image (Optional)

Instructions for building and pushing the docker image are in `image`. If you choose not to build and deploy the image, the helm chart will deploy the default, which was built via the steps and code in `image`. 

### Install nginx ingress controller

This could be incorporated into the helm chart.

```
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace
```

### Install Helm Chart

```
# specifiy these
appname=myapp
namespace=myns

# install
helm install -n ${namespace} --create-namespace ${appname} helm/simple-eks-hello

# OR - install with specific image/tag
repo=custom
tag=1.2
helm install --set image.repository=${repo} --set image.tag=${tag} -n ${namespace} --create-namespace ${appname} helm/simple-eks-hello

```

## Testing

If all goes well - the ingress controller will have an endpoint. Pull the endpoint from here: `kubectl -n ${namespace} describe ingress | grep Address`

Point a browser to the endpoint - and you'll see the page.

## Teardown/Uninstall

### Uninstall the app

```
helm uninstall -n ${namespace} ${appname}
```

### Uninstall ingress controller

This is important, as it will clean up things like the load balancer before 
```
helm uninstall ingress-nginx \
  --namespace ingress-nginx
```

### Terraform destroy

```
cd terraform
terraform destroy
```