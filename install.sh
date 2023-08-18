#! /bin/bash

OC_NAMESPACE=cloudbees-core
CONTROLLER_NAMESPACE=cloudbees-controller
kubectl delete ns $CONTROLLER_NAMESPACE || true
kubectl create ns $CONTROLLER_NAMESPACE || true
kubens $CONTROLLER_NAMESPACE

cat << EOF > values.yaml
OperationsCenter:
    Enabled: false
Master:
    Enabled: true
    #If the operations center is located in another cluster, it can be set to the same value as the current namespace, then an operations center service account must be created for authentication.
    OperationsCenterNamespace: $OC_NAMESPACE
Agents:
    Enabled: true
EOF

helm repo update
helm upgrade -i \
 $CONTROLLER_NAMESPACE cloudbees/cloudbees-core \
 --namespace $CONTROLLER_NAMESPACE -f values.yaml
 #CREATE MC CONTROLLER
 # We apply the cjoc-controller-items.yaml to cjoc. Cjoc will create a new MC for us using our $GEN_DIR/${CONTROLLER_NAME}.yaml
# echo "------------------  CREATING MANAGED CONTROLLER ------------------"
# curl -XPOST \
#    --user $TOKEN \
#    "${CJOC_URL}/casc-items/create-items" \
#     -H "Content-Type:text/yaml" \
#    --data-binary @$GEN_DIR/${CONTROLLER_NAME}.yaml