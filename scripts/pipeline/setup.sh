#!/bin/bash

#source $HERE/scripts/config
source ~/config
echo "Setting up generic openshift pipeline in proj ${NAMESPACE_TOOL}"
CURRENT_NS="$(oc project $NAMESPACE_TOOL -q)"
  if [ "$CURRENT_NS" == "$NAMESPACE_TOOL" ]; then
    oc project ${NAMESPACE_TOOL}
  else
    oc new-project ${NAMESPACE_TOOL}
  fi


oc apply -f $HERE/tekton-pipelines/pipeline.yaml 
oc apply -f $HERE/tekton-tasks/appsody-build-push.yaml 

oc create sa appsody-sa

# Note: the sleep will give OCP time to create the service account, and that is necessary for allocating the role binding.
sleep 15
oc policy add-role-to-user admin system:serviceaccount:$NAMESPACE_TOOL:appsody-sa
oc policy add-role-to-user admin system:serviceaccount:$NAMESPACE_TOOL:pipeline

oc create secret docker-registry quay-cred \
    --docker-server=quay.io \
    --docker-username=${QUAY_USER} \
    --docker-password=${QUAY_PWD} \
    --docker-email=${QUAY_EMAIL}

oc secrets link appsody-sa quay-cred
#oc describe sa appsody-sa

oc secrets link default quay-cred  --for=pull
#oc describe sa default


###################################################################################
#                                                                                 #
#   to my feeling a more loosely couple structure would be accomplished when we   #
#   move below script to the setup.sh of the particular microservice              #
#                                                                                 #
###################################################################################
#oc apply -f $HERE/tekton-resources/inventory-resources.yaml
#oc apply -f $HERE/tekton-resources/catalog-resources.yaml
#oc apply -f $HERE/tekton-resources/customer-resources.yaml

cat $HERE/tekton-resources/inventory-resources.yaml \
| sed  "s/--QUAY_USER--/${QUAY_USER}/g" \
| sed  "s/--NAMESPACE_TOOL--/${NAMESPACE_TOOL}/g" \
| oc apply -f -

cat $HERE/tekton-resources/catalog-resources.yaml \
| sed  "s/--QUAY_USER--/${QUAY_USER}/g" \
| sed  "s/--NAMESPACE_TOOL--/${NAMESPACE_TOOL}/g" \
| oc apply -f -

cat $HERE/tekton-resources/customer-resources.yaml \
| sed  "s/--QUAY_USER--/${QUAY_USER}/g" \
| sed  "s/--NAMESPACE_TOOL--/${NAMESPACE_TOOL}/g" \
| oc apply -f -

#cat $HERE/tekton-resources/orders-resources.yaml \
#| sed  "s/--QUAY_USER--/${QUAY_USER}/g" \
#| sed  "s/--NAMESPACE_TOOL--/${NAMESPACE_TOOL}/g" \
#| oc apply -f -

#auth-ms-openliberty
cat $HERE/tekton-resources/auth-ms-openliberty-resources.yaml \
| sed  "s/--QUAY_USER--/${QUAY_USER}/g" \
| sed  "s/--NAMESPACE_TOOL--/${NAMESPACE_TOOL}/g" \
| oc apply -f -

