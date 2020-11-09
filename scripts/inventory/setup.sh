#!/bin/bash

source ~/config

echo "setting up inventory microservice in proj ${NAMESPACE_INV}"
oc new-project ${NAMESPACE_INV}
oc project ${NAMESPACE_INV}



# Use OCP's capability to deploy the MySQL database
echo " building DB ${INVENTORY_DATABASE} with user ${INVENTORY_USER}"
oc new-app \
  --name inventorymysql \
  ${OCNEWAPP_OPTION} \
  --template openshift/mysql-persistent \
-p DATABASE_SERVICE_NAME=${INVENTORY_SERVICE_NAME} \
-p MYSQL_ROOT_PASSWORD=${INVENTORY_ROOT_PASSWORD} \
-p MYSQL_USER=${INVENTORY_USER} \
-p MYSQL_PASSWORD=${INVENTORY_PASSWORD} \
-p MYSQL_DATABASE=${INVENTORY_DATABASE} \
-p MYSQL_VERSION=8.0 

# populate the DB
curl https://raw.githubusercontent.com/kitty-catt/inventory-ms-spring/master/scripts/mysql_data.sql  -o /tmp/$WORKSPACE/mysql_data.sql

opt=nope
while [  "$opt" != "happy" ] ; do
    POD=$(oc get po | grep -v deploy| grep inventorymysql | awk '{print $1}')
    echo "found pod: $POD"
    #oc rsh $POD mysql -udbuser -ppassword inventorydb < /tmp/$WORKSPACE/mysql_data.sql 2>/dev/null
    oc rsh $POD mysql -u${INVENTORY_USER} -p${INVENTORY_PASSWORD} ${INVENTORY_DATABASE} < /tmp/$WORKSPACE/mysql_data.sql 2>/dev/null
    if [ 0 -eq $? ]; then
        echo "database initialized succesfully"
        opt="happy"
    else
        NOW=$(date +%H:%M:%S)
        echo "$NOW - database not initialized yet, retry"
        sleep 5
    fi
done

## Must deploy from image build by appsody.

## Deploy the inventory service
#oc new-app \
# --name=inventory \
# --as-deployment-config \
# --docker-image=TBD
# -e MYSQL_HOST=inventorymysql \
# -e MYSQL_PORT=3306 \
# -e MYSQL_DATABASE=inventorydb \
# -e MYSQL_USER=dbuser \
# -e MYSQL_PASSWORD=password
