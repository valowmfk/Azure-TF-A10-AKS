#!/bin/bash
#CMD="microk8s kubectl"
CMD="kubectl"
#./add-VS-with-Template.sh
$CMD create -f ns-cyan.yaml
$CMD create -f rbac.yaml
$CMD create -f th-secret.yaml
# #$CMD create -f ws.yaml
$CMD create -f ws-svc.yaml
$CMD create -f ingress.yaml
$CMD create -f tkc.yaml