#!/bin/bash
source ~/config


echo "build catalog"
CURRENT_NS="$(oc project $NAMESPACE_TOOL -q)"
  if [ "$CURRENT_NS" == "$NAMESPACE_TOOL" ]; then
    oc project ${NAMESPACE_TOOL}
  else
    echo "*** run setup first !! ***"
    exit -1
  fi

# once we build the image, it is placed in namespace-tool but is to be pulled from namespace-cat
oc adm policy add-role-to-group system:image-puller system:serviceaccounts:${NAMESPACE_CAT}

#NOTE: use "oc create for a plr that uses a generated name"
oc create -f $HERE/tekton-pipeline-run/catalog-run-auto.yaml
