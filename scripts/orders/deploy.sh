#!/bin/bash
source ~/config


CURRENT_NS="$(oc project $NAMESPACE_ORD -q)"
  if [ "$CURRENT_NS" == "$NAMESPACE_ORD" ]; then
    oc project ${NAMESPACE_ORD}
  else
    echo "*** run setup first !! ***"
    exit -1
  fi


echo "deploy orders"

# --as-deployment-config \
oc new-app \
 --name=orders \
<<<<<<< HEAD
 ${OCNEWAPP_OPTION} \
=======
>>>>>>> pipeline genkey
 --image-stream=${NAMESPACE_TOOL}/orders
#

oc expose svc/orders


exit 0






#the template for mysql generated: 
#secret/ordersmysql
#data:
#  database-name: 
#  database-password: 
#  database-root-password: 
#  database-user: 


oc create cm  \
  --from-literal MYSQL_HOST=inventorymysql \
  --from-literal MYSQL_PORT=3306 \
  --from-literal MYSQL_DATABASE=inventorydb \
  --from-literal MYSQL_USER=dbuser \
  --from-literal MYSQL_PASSWORD=password


# Deploy the orders service
oc new-app \
 --name=inventory \
 --as-deployment-config \
 --image-stream=${NAMESPACE_TOOL}/inventory
# --docker-image=quay.io/kitty_catt/inventory:latest
# -e MYSQL_HOST=inventorymysql \
# -e MYSQL_PORT=3306 \
# -e MYSQL_DATABASE=inventorydb \
# -e MYSQL_USER=dbuser \
# -e MYSQL_PASSWORD=password

oc set env dc/inventory --from=cm/inventory

oc expose svc/inventory
 
