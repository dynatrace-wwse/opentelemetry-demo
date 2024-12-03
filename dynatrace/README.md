## Update the local '.env.override' file

\# DO NOT PUSH CHANGES OF THIS FILE TO opentelemetry/opentelemetry-demo
\# PLACE YOUR .env ENVIRONMENT VARIABLES OVERRIDES IN THIS FILE
IMAGE_VERSION=1.12.0
IMAGE_NAME=[CUSTOM DOCKER REGISTRY REPOSITORY]
DEMO_VERSION=1.12.0
CART_SERVICE_DOCKERFILE=./dynatrace/Dockerfile.cartservice
CHECKOUT_SERVICE_DOCKERFILE=./dynatrace/Dockerfile.checkoutservice
FRONTEND_DOCKERFILE=./dynatrace/Dockerfile.frontend
FRONTEND_PROXY_DOCKERFILE=./dynatrace/Dockerfile.frontendproxy
PAYMENT_SERVICE_DOCKERFILE=./dynatrace/Dockerfile.paymentservice
PRODUCT_CATALOG_DOCKERFILE=./dynatrace/Dockerfile.productcatalogservice
LOAD_GENERATOR_DOCKERFILE=./dynatrace/Dockerfile.loadgenerator

## Build the opentelemtery-demo docker images
$ make build-and-push