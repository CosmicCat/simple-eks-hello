# Simple EKS Cluster

## Purpose

Minimal terraform, helm charts and docker image to run a simple hello world application in EKS.

## Requirements

To run the terraform, you need an AWS IAM user with strong permissions against IAM and EKS. A real world application would need a user with more granular permissions specific to this purpose. My user had the following permissions:

* `iam:*` on `*`
* `eks:*` on `*`
* `rds:*` on `*`
* `ec2:*` on `*`

Additionally - I used:
* helm `v3.10.1`
* terraform `v1.3.5`
* awscli `2.8.8`

## Contents

* **helm** - home of simple-eks-hello - helm chart for this example
* **terraform** - set of terraform modules to build out EKS and supporting infra
* **image** - docker build for the hello world docker container

## Installation Steps

### Run Terraform

Important: by default, we use the `us-west-1` region. If you want to run elsewhere, you must override the `region` and `availability_zones` variables. You may even need to override the `availability_zones` anyway, as I believe zone names are arbitrary across AWS accounts, and not all zones are equipped with the necessary things.

Takes 5-10 minutes.

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

TODO - allow the cluster to be named something other than `cluster` in the terraforms.

```
aws eks --region us-west-1 update-kubeconfig --name cluster
```

You should now be able to use `kubectl` - test that the single node has been added to the cluster: `kubectl get nodes`

### Build and Push Docker Image (Optional)

Instructions for building and pushing the docker image are in `image`. If you choose not to build and deploy the image, the helm chart will deploy the default, which was built via the steps and code in `image`. 

### Install nginx Ingress Controller

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

It might take a few minutes for the ingress controller to create a load balancer. When it does, the address will populate here:

```
kubectl -n ${namespace} describe ingress | grep Address
```

Point a browser to the endpoint - and you'll see the page.


### Test Connectivity to RDS

Get the RDS endpoint from the terraform outputs for later use.

```
cd terraform
terraform output
```

Create a temporary ubuntu pod and open a prompt inside.
```
kubectl run my-shell --rm -i --tty --image ubuntu -- bash
```

Now inside the cluster in that pod, run the following:
```
# get the postgres client
apt update
apt install postgresql-client

# connect to the database
# - substitute with the appropriate endpoint - be sure to strip the port
# - password is: supersecure
psql -h terraform-20221215014358338100000001.czcypyjzm8qi.us-west-1.rds.amazonaws.com -U fred postgres
```


## Teardown/Uninstall

Important - Perform all of the steps - or `terraform destroy` might not complete successfully.

### Uninstall the app

```
helm uninstall -n ${namespace} ${appname}
```

### Uninstall Ingress Controller

This is important, as it will clean up dangling things like the load balancer - preventing `terraform destroy` from completing successfully.
```
helm uninstall ingress-nginx \
  --namespace ingress-nginx
```

### Terraform destroy

Takes 5-10 minutes.

```
cd terraform
terraform destroy
```