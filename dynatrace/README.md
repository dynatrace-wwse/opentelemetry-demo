# Dynatrace

Optional changes which are required to run both Otel Collector and Dynatrace OneAgent in parallel

## Cart service

- Dynatrace does not currently support [PublishSingleFile](https://learn.microsoft.com/en-us/dotnet/core/deploying/single-file)

## Checkout Service

- Dynatrace Support limited to official, stable Go releases - https://docs.dynatrace.com/docs/ingest-from/technology-support/application-software/go/support/go-known-limitations#go-official-stable-releases
- Applications built with -buildmode=pie option and CGO disabled aren't supported by Dynatrace - https://docs.dynatrace.com/docs/ingest-from/technology-support/application-software/go/support/go-known-limitations#applications-built-with-buildmodepie-option-and-cgo-disabled-arent-supported
- Dynatrace Support for statically linked binaries - https://docs.dynatrace.com/docs/ingest-from/technology-support/application-software/go/support/go-known-limitations#static-monitoring

## Frontend

- Dynatrace list of officially supported version of NodeJS - https://docs.dynatrace.com/docs/ingest-from/technology-support/application-software/nodejs#support-and-desupport

## Frontend Proxy

- Configure Envoy for Dynatrace - https://docs.dynatrace.com/docs/ingest-from/opentelemetry/integrations/envoy

## Imageprovider

- Expose stub_status to allow metrics scraping - https://nginx.org/en/docs/http/ngx_http_stub_status_module.html#stub_status

## Loadgenerator

- Generate only synthetic broswer based traffic

## Payment Service

- Dynatrace list of officially supported version of NodeJS - https://docs.dynatrace.com/docs/ingest-from/technology-support/application-software/nodejs#support-and-desupport

## Productcatalog Service

- Dynatrace Support limited to official, stable Go releases - https://docs.dynatrace.com/docs/ingest-from/technology-support/application-software/go/support/go-known-limitations#go-official-stable-releases
- Applications built with -buildmode=pie option and CGO disabled aren't supported by Dynatrace - https://docs.dynatrace.com/docs/ingest-from/technology-support/application-software/go/support/go-known-limitations#applications-built-with-buildmodepie-option-and-cgo-disabled-arent-supported
- Dynatrace Support for statically linked binaries - https://docs.dynatrace.com/docs/ingest-from/technology-support/application-software/go/support/go-known-limitations#static-monitoring


## Update the local '.env.override' file

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