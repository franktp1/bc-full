#!/bin/bash

source ~/config

echo "setup orders in proj ${NAMESPACE_ORD}"
CURRENT_NS="$(oc project $NAMESPACE_ORD -q)"
  if [ "$CURRENT_NS" == "$NAMESPACE_ORD" ]; then
    oc project ${NAMESPACE_ORD}
  else
    oc new-project ${NAMESPACE_ORD}
  fi

echo " building orders DB ${ORDER_DATABASE} with user ${ORDER_USER}"

oc new-app \
  --name=ordersmysql \
  --as-deployment-config \
  --template openshift/mariadb-persistent \
-p DATABASE_SERVICE_NAME=${ORDER_SERVICE_NAME} \
-p MYSQL_ROOT_PASSWORD=${ORDER_ROOT_PASSWORD} \
-p MYSQL_USER=${ORDER_USER} \
-p MYSQL_PASSWORD=${ORDER_PASSWORD} \
-p MYSQL_DATABASE=${ORDER_DATABASE} \
-p MARIADB_VERSION=10.2 \
-p VOLUME_CAPACITY=1Gi



