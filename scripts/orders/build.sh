#!/bin/bash
source ~/config


echo "build orders"
CURRENT_NS="$(oc project $NAMESPACE_TOOL -q)"
  if [ "$CURRENT_NS" == "$NAMESPACE_TOOL" ]; then
    oc project ${NAMESPACE_TOOL}
  else
    echo "*** run setup first !! ***"
    exit -1
  fi

# once we build the image, it is placed in namespace-tool but is to be pulled from namespace-ord
oc adm policy add-role-to-group system:image-puller system:serviceaccounts:${NAMESPACE_ORD}


