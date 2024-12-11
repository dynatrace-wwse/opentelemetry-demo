#!/bin/bash

# Instructions to get the AstroShop in the ACE Box running

# git clone ssh://git@bitbucket.lab.dynatrace.org/cloude/opentelemetry-demo-additions.git 
# cd opentelemetry-demo-additions/opentelemetry-demo-k8s

helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
helm repo update

#helm upgrade --install -f ./install/bring-your-own-observability-helm-values.yaml \
#astroshop \
#open-telemetry/opentelemetry-demo \
#--namespace astroshop \
#--set default.image.repository=geaksoteldemo.azurecr.io/oteldemo \
#--set default.image.tag=1.11.1 \
#--create-namespace \
#--version 0.32.8
# TODO to change for shinojosa (org in Docker)

helm upgrade --install -f ./install/bring-your-own-observability-helm-values.yaml \
astroshop \
open-telemetry/opentelemetry-demo \
--namespace astroshop \
--set default.image.repository=ghcr.io/open-telemetry/demo \
--set default.image.tag=1.11.1 \
--create-namespace \
--version 0.32.8

# https://github.com/keyoke/opentelemetry-demo/
# TODO: Different version as ACE, in ACE 1.3.2
helm upgrade --install dynatrace-operator oci://public.ecr.aws/dynatrace/dynatrace-operator \
--create-namespace \
--namespace dynatrace \
--atomic \
--version 1.3.2 \


kubectl apply -f dynakube-alpha.yml --namespace dynatrace

helm repo add fluent https://fluent.github.io/helm-charts

helm repo update


# Opentelemetry

helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts

helm repo update

helm upgrade --install -f ./install/bring-your-own-observability-helm-values.yaml astroshop open-telemetry/opentelemetry-demo \
--namespace astroshop \
--set default.image.repository=ghcr.io/open-telemetry/demo \
--set default.image.tag=1.11.1 \
--create-namespace \
--version 0.32.8 


# Build the opentelemtery-demo application
git clone https://github.com/keyoke/opentelemetry-demo/tree/features/dynatrace-demo
export RELEASE_VERSION='1.11.1'
export IMAGE_NAME=shinojosa/oteldemo
export DEMO_VERSION='1.11.1'


# Make sure we label the k8s namespace for OA injection
kubectl label namespace astroshop dynatrace.com/inject=true

# Patch the astroshop deployments

bash patch.sh

#kubectl delete deployment astroshop-frontendproxy --namespace astroshop
#kubectl delete service astroshop-frontendproxy --namespace astroshop


# Install openteöemetry 

helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
helm repo update

helm install opentelemetry-operator open-telemetry/opentelemetry-operator --set "manager.collectorImage.repository=hcr.io/dynatrace/dynatrace-otel-collector/dynatrace-otel-collector:0.14.0" --create-namespace --namespace opentelemetry-operator-system --version 0.67.0

kubectl create secret generic dynatrace-otelcol-dt-api-credentials --from-literal=DT_ENDPOINT=https://sro97894.live.dynatrace.com/api/v2/otlp --from-literal=DT_API_TOKEN=dt0c01.4IM3DHAT2JIT5OFNLEHHDIML.xxx --namespace astroshop

kubectl apply -f otel_collector_gateway.yaml --namespace astroshop
kubectl apply -f otel_k8s_enrichment.yaml
