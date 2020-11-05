source ~/config

oc project ${NAMESPACE_TOOL}

mkdir -p /tmp/full-bc/tekton-resources

#oc apply -f << \
#cat $HERE/tekton-resources/inventory-resources.yaml
#echo "SED"
#cat $HERE/tekton-resources/inventory-resources.yaml \
#| sed  "s/--QUAY_USER--/${QUAY_USER}/g" \
#| sed  "s/--NAMESPACE_TOOL--/${NAMESPACE_TOOL}/g" \
#> /tmp/full-bc/tkt-resources/tekton-resources/inventory-resources.yaml
#echo FILE:
#cat /tmp/full-bc/tkt-resources/tekton-resources/inventory-resources.yaml

cat $HERE/tekton-resources/inventory-resources.yaml \
| sed  "s/--QUAY_USER--/${QUAY_USER}/g" \
| sed  "s/--NAMESPACE_TOOL--/${NAMESPACE_TOOL}/g" \
| oc apply -f -
#\ sed  "s/--NAMESPACE_TOOL--/${NAMESPACE_TOOL}/g" << \
# sed  "s/--QUAY_USER--/${QUAY_USER}/g" $HERE/tekton-resources/inventory-resources.yaml


