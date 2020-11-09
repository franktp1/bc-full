#!/bin/bash

source ~/config
echo "deploy auth service for OAuth 2.0 authentication"


CURRENT_NS="$(oc project $NAMESPACE_AUTH -q)"
  if [ "$CURRENT_NS" == "$NAMESPACE_AUTH" ]; then
    oc project ${NAMESPACE_AUTH}
  else
    echo "*** run setup first !! ***"
    exit -1
  fi


oc new-app \
 --name=auth \
 ${OCNEWAPP_OPTION} \
 -e HS256_KEY=${HS256_KEY} \
 --image-stream=${NAMESPACE_TOOL}/auth
#



#oc new-app --name=auth \
# -e HS256_KEY=${HS256_KEY} \
#  --image-stream=auth 

oc expose svc/auth --port=8080
