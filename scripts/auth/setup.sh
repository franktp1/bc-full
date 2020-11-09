#!/bin/bash
source ~/config

echo "setup auth service for OAuth 2.0 authentication"



echo "setup auth in proj ${NAMESPACE_AUTH}"
CURRENT_NS="$(oc project $NAMESPACE_AUTH -q)"
  if [ "$CURRENT_NS" == "$NAMESPACE_AUTH" ]; then
    oc project ${NAMESPACE_AUTH}
  else
    oc new-project ${NAMESPACE_AUTH}
  fi

 
