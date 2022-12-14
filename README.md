# Simple EKS Cluster

## Prerequisites

To run the terraform, you need an AWS IAM user with strong permissions against IAM and EKS. For the purposes of this project, my user had the following permissions:

* `iam:*` on `*`
* `eks:*` on `*`
* `ec2:*` on `*` - might not be necessary

These are obviously too generous for any real-world AWS environment and would need to be scaled back.

Tested with helm `v3.10.1`

## Steps

### Run Terraform

FIXME

### Point kubectl at Control Plane

`aws eks --region us-west-1 update-kubeconfig --name example`

### Install nginx ingress controller

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

