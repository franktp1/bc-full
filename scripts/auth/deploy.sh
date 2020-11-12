#!/bin/bash

source ~/config
echo "deploy auth service for OAuth 2.0 authentication"


CURRENT_NS="$(oc project ${NAMESPACE_AUTH} -q)"
  if [ "$CURRENT_NS" == "$NAMESPACE_AUTH" ]; then
    oc project ${NAMESPACE_AUTH}
  else
    echo "*** run setup first !! ***"
    exit -1
  fi
# generate the key files
oc create -f ../../tekton-pipeline-run/genkey-run-auto.yaml
echo "---- key files are being generated, taking half a minute ----"
sleep 25

# --as-deployment-config \
oc new-app \
 --name=auth \
 ${OCNEWAPP_OPTION} \
 -e HS256_KEY=${HS256_KEY} \
 --image-stream=${NAMESPACE_TOOL}/auth
#

oc expose svc/auth --port=8080
