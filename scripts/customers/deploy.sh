#!/bin/bash
source ~/config


CURRENT_NS="$(oc project ${NAMESPACE_CUST} -q)"
  if [ "$CURRENT_NS" == "$NAMESPACE_CUST" ]; then
    oc project ${NAMESPACE_CUST}
  else
    echo "*** run setup first !! ***"
    exit -1
  fi


echo "deploy customers"
source ~/config

#appsody run --docker-options "\
# -e COUCHDB_PORT=5985 \
# -e COUCHDB_HOST=host.docker.internal \
# -e COUCHDB_PROTOCOL=http \
# -e COUCHDB_USERNAME=admin \
# -e COUCHDB_PASSWORD=passw0rd \
# -e COUCHDB_DATABASE=customers 
# -e HS256_KEY=E6526VJkKYhyTFRFMC0pTECpHcZ7TGcq8pKsVVgz9KtESVpheEO284qKzfzg8HpWNBPeHOxNGlyudUHi6i8tFQJXC8PiI48RUpMh23vPDLGD35pCM0417gf58z5xlmRNii56fwRCmIhhV7hDsm3KO2jRv4EBVz7HrYbzFeqI45CaStkMYNipzSm2duuer7zRdMjEKIdqsby0JfpQpykHmC5L6hxkX0BT7XWqztTr6xHCwqst26O0g8r7bXSYjp4a"

oc new-app --name=customer \
 -e COUCHDB_PORT=5984 \
 -e COUCHDB_HOST=customercouchdb \
 -e COUCHDB_PROTOCOL=http \
 -e COUCHDB_USERNAME=${COUCHDB_USER} \
 -e COUCHDB_PASSWORD=${COUCHDB_PASSWORD} \
 -e COUCHDB_DATABASE=customers \
 -e HS256_KEY=${HS256_KEY} \
  --image-stream=${NAMESPACE_TOOL}/customer \
  ${OCNEWAPP_OPTION}

oc expose svc/customer --port=8080
