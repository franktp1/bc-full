#!/bin/bash
source ~/config


echo "building inventory image"
CURRENT_NS="$(oc project -q)"
  if [ "$CURRENT_NS" == "$NAMESPACE_TOOL" ]; then
    oc project ${NAMESPACE_TOOL}
  else
    echo "*** run setup first !! ***"
    exit -1
    #oc new-project ${NAMESPACE_INV}
  fi

# once we build the image, it is placed in namespace-tool but is to be pulled from namespace-inv
oc adm policy add-role-to-group system:image-puller system:serviceaccounts:${NAMESPACE_INV}


#oc apply -f $HERE/tekton-pipeline-run/inventory-run.yaml
oc create -f $HERE/tekton-pipeline-run/inventory-run-auto.yaml

#Note: the inventory-run-auto.yaml will generate a name for the pipelinerun, it MUST use oc create/
