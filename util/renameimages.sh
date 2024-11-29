#!/usr/bin/bash

# Example
# docker tag ghcr.io/open-telemetry/demo:0.32.8-frauddetectionservice shinojosa/astroshop/frauddetectionservice:0.32.8

## declare an array variable
declare -a IMAGES=("accountingservice" "adservice" "cartservice" "checkoutservice" "currencyservice" "emailservice" "frauddetectionservice" "frontend" "frontendproxy" "imageprovider" "kafka" "loadgenerator" "paymentservice" "productcatalogservice" "quoteservice" "recommendationservice" "shippingservice")

OLDSERVER="ghcr.io/open-telemetry/demo"
NEWSERVER="shinojosa/astroshop"
OLDTAG="0.32.8"
NEWTAG="0.32.8"

renameImages() {
   ## now loop through the above array
   for IMAGE in "${IMAGES[@]}"; do
      printf "renaming & tagging: ${OLDSERVER}:${OLDTAG}-${IMAGE} ---> ${NEWSERVER}/${IMAGE}:${NEWTAG} \n"
      docker image tag ${OLDSERVER}:${OLDTAG}-${IMAGE} ${NEWSERVER}/${IMAGE}:${NEWTAG}
   done
}

pushImages() {
   for IMAGE in "${IMAGES[@]}"; do
      printf "pushing image to repo ${NEWSERVER}/${IMAGE}:${NEWTAG} \n"
      docker push ${NEWSERVER}/${IMAGE}:${NEWTAG}
   done
}

export RELEASE_VERSION='1.11.1'
export IMAGE_NAME=shinojosa/astroshop
export DEMO_VERSION='1.11.1'
