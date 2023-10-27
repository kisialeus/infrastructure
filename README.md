/terraform

Contains all the code for deploying a Kubernetes cluster in  AWS.
You must have the AWS CLI installed and configured, as well as an S3 bucket for storing Terraform state files.

 terraform init 
 terraform apply -var-file=vars.tfvars


/manifests

### install nginx-ingress
kubectl apply -f ingress-nginx.yaml 

proxy-real-ip-cidr should be same as VPC CIDR
service.beta.kubernetes.io/aws-load-balancer-ssl-cert - arn of wildcard certificate for domain

### Install external dns 
Auto provisioning route53 hostedzone records based on ingress

kubectl apply -f external-dns.yaml

### install metric server - for HPA
kubectl apply -f metric-server.yaml

### install cluster autoscaler 
Scaling up/down eks managed nodegroups

kubectl apply -f cluster-autoscaler.yaml

### install ARGO CD

kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

patch argocd cm to allow http (ssl termination will be in NLB)

kubectl apply -f argocd-cm-patch.yaml -n argocd
kubectl apply -f argo-ingress.yaml -n argocd

