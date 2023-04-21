#CMD="microk8s kubectl"
CMD="kubectl"
$CMD delete -f th-secret.yaml
$CMD delete -f ingress.yaml
$CMD delete -f ws-svc.yaml
#$CMD delete -f ws.yaml
#$CMD delete -f dataNetworks.yaml
#$CMD delete -f ns-cyan.yaml
$CMD delete -f tkc.yaml