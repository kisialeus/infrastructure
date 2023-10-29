/terraform

Contains all the code for deploying a Kubernetes cluster in  AWS.
You must have the AWS CLI installed and configured, as well as an S3 bucket for storing Terraform state files.
```bash
 terraform init 
 terraform apply -var-file=vars.tfvars
```

/manifests

### install nginx-ingress
```bash
```bash
kubectl create namespace ingress-nginx
kubectl apply -f ingress-nginx.yaml 
```
proxy-real-ip-cidr should be same as VPC CIDR
service.beta.kubernetes.io/aws-load-balancer-ssl-cert - arn of wildcard certificate for domain

### Install external dns 
Auto provisioning route53 hostedzone records based on ingress
```bash
kubectl apply -f external-dns.yaml
```
### install metric server - for HPA
```bash
kubectl apply -f metric-server.yaml
```
### install cluster autoscaler 
Scaling up/down eks managed nodegroups
```bash
kubectl apply -f cluster-autoscaler.yaml
```
### install ARGO CD

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

#patch argocd cm to allow http (ssl termination will be in NLB)
kubectl apply -f argocd-cm-patch.yaml -n argocd
kubectl rollout restart deploy argocd-server -n argocd
kubectl apply -f argo-ingress.yaml -n argocd

# create argocd project
kubectl apply -f argocd-project.yaml -n argocd

# add argocd image updater and patch it
helm repo add argo https://argoproj.github.io/argo-helm
helm install argocd-image-updater argo/argocd-image-updater -n argocd -f image-updater-values.yaml
kubectl rollout restart deploy argocd-image-updater -n argocd 

#get initial pass for argo admin 
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```
## Connect repositories and ArgoCD 
Generate ssh keys and add private key to argdocd and public to github
