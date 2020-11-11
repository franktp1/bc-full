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
 ${OCNEWAPP_OPTION} \
 --image-stream=${NAMESPACE_TOOL}/orders \
 -e jdbcURL=jdbc:mysql://ordersmysql:3307/ordersdb?useSSL=true
 
oc set env db/orders 
# -e dbuser=<database user name> -e dbpassword=<database password> -e jwksIssuer="https://localhost:9444/oidc/endpoint/OP"
#

oc set volume dc/orders --add --name secretsvol1 \
 -m src/main/liberty/config/resources/security/BCKeyStoreFile.p12 \
 --sub-path=KeyStoreFile.p12 \
 --type secret \
 --secret-name ${NAMESPACE_TOOL}/genkey-secret-files
oc set volume dc/orders --add --name secretsvol2 \
 -m src/main/liberty/config/resources/security/client.cer \
 --sub-path=client.cer \
 --type secret \
 --secret-name ${NAMESPACE_TOOL}/genkey-secret-files
oc set volume dc/orders --add --name secretsvol3 \
 -m src/main/liberty/config/resources/security/truststore.p12 \
 --sub-path=truststore.p12 \
 --type secret \
 --secret-name ${NAMESPACE_TOOL}/genkey-secret-files

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
 
