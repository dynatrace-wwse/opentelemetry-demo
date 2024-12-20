
helm repo add jetstack https://charts.jetstack.io --force-update  

helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.15.3 --set crds.enabled=true

kubectl apply -f clusterissuers.yaml       


helm install dynatrace-operator oci://public.ecr.aws/dynatrace/dynatrace-operator \
--set "imageRef.repository=gcr.io/dynatrace-marketplace-prod/dynatrace-operator" \
--create-namespace \
--namespace dynatrace \
--atomic



kubectl apply -f dynakube-dev-alpha.yaml       

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml


kubectl create ns staging-astroshop

kubectl label namespace staging-astroshop dynatrace.com/inject="true"
kubectl label namespace ingress-nginx dynatrace.com/inject="true"

 ./agent_do_rollout.sh -e staging -v 1.12.0 -c anyparameter
