#!/bin/bash

source ~/config

echo "setup web frontend in proj ${NAMESPACE_WEB}"
oc new-project ${NAMESPACE_WEB}
oc project ${NAMESPACE_WEB}

