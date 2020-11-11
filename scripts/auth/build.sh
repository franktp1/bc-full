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


oc create -f $HERE/tekton-pipeline-run/auth-ms-openliberty-run-auto.yaml
#Note: for the PipelineRun to generate a name for the pipelinerun, it MUST use oc create/

#The secret key-generator pipeline-Task uses this built image to generate the secret key files
# the Task will store the files in a secret.
# To be able to use this image by the pipeline, assign the serviceaccount 'pipeline' the proper rights on this image
oc adm policy add-role-to-user system:image-puller system:serviceaccount:${NAMESPACE_TOOL}:pipeline --rolebinding-name=image-pull-pipelineSA
oc adm policy add-role-to-user system:registryn system:serviceaccount:${NAMESPACE_TOOL}:pipeline --rolebinding-name=registry-pipelineSA



#NOTE: use "oc create for a plr that uses a generated name"
# ronald: oc create -f $HERE/tekton-pipeline-run/auth-run-auto.yaml
