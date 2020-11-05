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
