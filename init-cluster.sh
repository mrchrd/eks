#!/bin/bash

export AWS_REGION="$(terraform output aws_region)"
export CLUSTER_NAME="$(terraform output cluster_name)"
export KMS_KEY_ARN="$(terraform output kms_key_arn)"
export KUBECONFIG="${PWD}/kubeconfig"

if [ "$1" == "-d" ]; then
  ACTION="delete"
else
  ACTION="apply"
fi

terraform output kubeconfig > "${KUBECONFIG}"

kubectl delete clusterrolebinding eks:podsecuritypolicy:authenticated
envsubst < assets/pod-security-policies.yaml   | kubectl "${ACTION}" -f-

kubectl delete storageclass gp2
envsubst < assets/ebs-csi.yaml                 | kubectl "${ACTION}" -f-

envsubst < assets/nvidia-device-plugin.yml     | kubectl "${ACTION}" -f-

envsubst < assets/efs-csi.yaml                 | kubectl "${ACTION}" -f-
envsubst < assets/calico.yaml                  | kubectl "${ACTION}" -f-

envsubst < assets/metrics-server.yaml          | kubectl "${ACTION}" -f-
envsubst < assets/cni-metrics-helper.yaml      | kubectl "${ACTION}" -f-
envsubst < assets/cloudwatch.yaml              | kubectl "${ACTION}" -f-

envsubst < assets/cluster-autoscaler.yaml      | kubectl "${ACTION}" -f-
envsubst < assets/vertical-pod-autoscaler.yaml | kubectl "${ACTION}" -f-

envsubst < assets/public-info-viewer.yaml      | kubectl "${ACTION}" -f-
envsubst < assets/default-namespace.yaml       | kubectl "${ACTION}" -f-
