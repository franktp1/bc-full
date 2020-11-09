#!/bin/bash
source ~/config


CURRENT_NS="$(oc project $NAMESPACE_INV -q)"
  if [ "$CURRENT_NS" == "$NAMESPACE_INV" ]; then
    oc project ${NAMESPACE_INV}
  else
    echo "*** run setup first !! ***"
    exit -1
  fi


echo "deploying inventory microservice ... the openshift way"

oc create cm inventory \
  --from-literal MYSQL_HOST=inventorymysql \
  --from-literal MYSQL_PORT=3306 \
  --from-literal MYSQL_DATABASE=inventorydb \
  --from-literal MYSQL_USER=dbuser \
  --from-literal MYSQL_PASSWORD=password


# Deploy the inventory service
oc new-app \
 --name=inventory \
 ${OCNEWAPP_OPTION} \
 --image-stream=${NAMESPACE_TOOL}/inventory
# --docker-image=quay.io/kitty_catt/inventory:latest
# -e MYSQL_HOST=inventorymysql \
# -e MYSQL_PORT=3306 \
# -e MYSQL_DATABASE=inventorydb \
# -e MYSQL_USER=dbuser \
# -e MYSQL_PASSWORD=password

oc set env dc/inventory --from=cm/inventory

oc expose svc/inventory
