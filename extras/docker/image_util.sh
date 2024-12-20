#!/usr/bin/bash

# Example
# docker tag ghcr.io/open-telemetry/demo:0.32.8-frauddetectionservice shinojosa/astroshop/frauddetectionservice:0.32.8

## declare an array variable
#declare -a IMAGES=("accountingservice" "adservice" "cartservice" "checkoutservice" "currencyservice" "emailservice" "frauddetectionservice" "frontend" "frontendproxy" "imageprovider" "kafka" "loadgenerator" "paymentservice" "productcatalogservice" "quoteservice" "recommendationservice" "shippingservice")
declare -a IMAGES=("adservice")

OLDSERVER="shinojosa/astroshop"
NEWSERVER="shinojosa/astroshop"
OLDTAG="1.12.0-CPU"
NEWTAG="1.12.0-GC"

retagImages() {
   ## now loop through the above array
   for IMAGE in "${IMAGES[@]}"; do
      printf "retaging: ${OLDSERVER}:${OLDTAG}-${IMAGE} ---> ${NEWSERVER}:${NEWTAG}-${IMAGE} \n"
      docker image tag ${OLDSERVER}:${OLDTAG}-${IMAGE} ${NEWSERVER}:${NEWTAG}-${IMAGE}
   done
}

pushImages() {
   for IMAGE in "${IMAGES[@]}"; do
      printf "pushing image to repo ${NEWSERVER}/${IMAGE}:${NEWTAG} \n"
      docker push ${NEWSERVER}/${IMAGE}:${NEWTAG}
   done
}

renameImages() {
   ## now loop through the above array
   for IMAGE in "${IMAGES[@]}"; do
      printf "renaming: ${OLDSERVER}:${OLDTAG}-${IMAGE} ---> ${NEWSERVER}/${IMAGE}:${NEWTAG} \n"
      docker image tag ${OLDSERVER}:${OLDTAG}-${IMAGE} ${NEWSERVER}/${IMAGE}:${NEWTAG}
   done
}

pushImagesBadNaming() {
   ## now loop through the above array
   for IMAGE in "${IMAGES[@]}"; do
      printf "pushing image: ${NEWSERVER}:${NEWTAG}-${IMAGE} \n"
      docker push ${NEWSERVER}:${NEWTAG}-${IMAGE}
   done
}

pushImages() {
   ## now loop through the above arrayoush
   for IMAGE in "${IMAGES[@]}"; do
      printf "pushing image: ${NEWSERVER}/${IMAGE}:${NEWTAG} \n"
      docker push ${NEWSERVER}/${IMAGE}:${NEWTAG}
   done
}

forCompiling() {
   # Needed on MAC for crosscompiling
   export DOCKER_DEFAULT_PLATFORM=linux/amd64
   # somehow are not overwritten hence..
   export IMAGE_NAME=shinojosa/astroshop
   export RELEASE_VERSION='1.11.1'
   export DEMO_VERSION='1.11.1'

}








# - 0
#   productcatalogservice
#   emailservice
#   imageprovider
#   kafka
#   frontendproxy
#   frauddetectionservice
#   adservice
#   frontend
#   currencyservice
#   accountingservice
#   checkoutservice
#   recommendationservice
#   loadgenerator
#   cartservice
#   quoteservice
#   flagdui
#   paymentservice