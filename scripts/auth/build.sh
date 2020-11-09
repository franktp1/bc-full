#!/bin/bash
source ~/config

echo "build auth service for OAuth 2.0 authentication"


CURRENT_NS="$(oc project $NAMESPACE_TOOL -q)"
  if [ "$CURRENT_NS" == "$NAMESPACE_TOOL" ]; then
    oc project ${NAMESPACE_TOOL}
  else
    echo "*** run setup first !! ***"
    exit -1
  fi

# once we build the image, it is placed in namespace-tool but is to be pulled from namespace-ord
oc adm policy add-role-to-group system:image-puller system:serviceaccounts:${NAMESPACE_AUTH}


#oc create -f $HERE/tekton-pipeline-run/orders-run-auto.yaml
oc create -f $HERE/tekton-pipeline-run/auth-ms-openliberty-run-auto.yaml

#Note: for the PipelineRun to generate a name for the pipelinerun, it MUST use oc create/



#NOTE: use "oc create for a plr that uses a generated name"
# ronald: oc create -f $HERE/tekton-pipeline-run/auth-run-auto.yaml
