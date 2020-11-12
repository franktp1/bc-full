#!/bin/bash
source ~/config


echo "deploy web frontend"
CURRENT_NS="$(oc project ${NAMESPACE_WEB} -q)"
  if [ "$CURRENT_NS" == "$NAMESPACE_WEB" ]; then
    oc project ${NAMESPACE_WEB}
  else
    echo "*** run setup first !! ***"
    exit -1
  fi


