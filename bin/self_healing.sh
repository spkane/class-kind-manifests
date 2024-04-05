#!/bin/bash

set -e
set -u

export primary_manager_ip="127.0.0.1"

curl -s -o /dev/null -w "%{http_code}" http://${primary_manager_ip}:80/
echo; echo
kubectl get pods -l app=outyet
echo
curl -s -o /dev/null -w "%{http_code}" http://${primary_manager_ip}:80/
echo
POD="$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}'  | head -n 1)"
echo -e "\n[INFO] Deleting pod (${POD})...\n"
kubectl delete pod "${POD}"
echo
curl -s -o /dev/null -w "%{http_code}" http://${primary_manager_ip}:80/
echo; echo
kubectl get pods -l app=outyet
echo
# shellcheck disable=SC2034
for i in {1..2}; do
  sleep 1
  curl -s -o /dev/null -w "%{http_code}" http://${primary_manager_ip}:80/
  echo; echo
  kubectl get pods -l app=outyet
  echo
done

exit 0
