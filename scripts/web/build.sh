#!/bin/bash
source ~/config


echo "build web frontend"
CURRENT_NS="$(oc project $NAMESPACE_WEB -q)"
  if [ "$CURRENT_NS" == "$NAMESPACE_WEB" ]; then
    oc project ${NAMESPACE_WEB}
  else
    echo "*** run setup first !! ***"
    exit -1
  fi

# once we build the image, it is placed in namespace-tool but is to be pulled from namespace-web
oc adm policy add-role-to-group system:image-puller system:serviceaccounts:${NAMESPACE_WEB}


