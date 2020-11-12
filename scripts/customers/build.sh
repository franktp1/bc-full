#!/bin/bash
source ~/config

echo "build customer microservice"
echo "building is done in tools ns. if we try to put this pipelinerun in its own ns it can not find the pipeline itself"
echo " ++ can we tell the pilelinerun to find the pipeline in a particular ns? ++"
sleep 3
CURRENT_NS="$(oc project -q)"
  if [ "$CURRENT_NS" == "$NAMESPACE_TOOL" ]; then
    oc project ${NAMESPACE_TOOL}
  else
    echo "*** run setup first !! ***"
    exit -1
  fi


# once we build the image, it is placed in namespace-tool but is to be pulled from namespace-cust
oc adm policy add-role-to-group system:image-puller system:serviceaccounts:${NAMESPACE_CUST}


#NOTE: use "oc create for a plr that uses a generated name"
oc create -f $HERE/tekton-pipeline-run/customer-run-auto.yaml
