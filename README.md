# flux.pi-k3s.home

## system-upgrade
### label nodes for upgrade manually
```sh
// example: kubectl label node <node-name> k3s-upgrade=true
kubectl label node pi-node01 plan.upgrade.cattle.io/k3s=true
kubectl label node pi-node02 plan.upgrade.cattle.io/k3s=true
kubectl label node pi-node03 plan.upgrade.cattle.io/k3s=true
```

### label node for raspbian upgrade manually
```sh
# // example: kubectl label node <node-name> k3s-upgrade=true
# kubectl label node pi-node01 plan.upgrade.cattle.io/raspbian=true
# kubectl label node pi-node02 plan.upgrade.cattle.io/raspbian=true
# kubectl label node pi-node03 plan.upgrade.cattle.io/raspbian=true
```

### retrieve self-signed trusted ca certs
```sh
openssl req -new -newkey rsa:2048 -keyout k8s-home.key -nodes -subj "/CN=*.k8s.home" |   curl -v -fk --data-binary @- -o k8s-home.crt "https://cubietruck/sign?ns=*.k8s.home"
```

### create cert from files
```sh
kubectl create secret tls -n monitoring k8s-home-cert --key="k8s-home.key" --cert="k8s-home.crt" --dry-run=client -o yaml > k8s-home-cert.yaml
```

### retrieve selaed pub-sealed-secrets.pem
```sh
kubeseal --fetch-cert \
--controller-name=sealed-secrets-controller \
--controller-namespace=secops \
> pub-sealed-secrets.pem
```

### seal secret
```sh
kubeseal --format=yaml --cert=pub-sealed-secrets.pem \
< certificate.yaml > sealed-certificate.yaml
```

### SECOPS
#### Vault auto unseal
https://learn.hashicorp.com/tutorials/vault/autounseal-transit?in=vault/auto-unseal



https://github.com/ricoberger/vault-secrets-operator/issues/104
https://github.com/external-secrets/kubernetes-external-secrets/issues/721
vault write auth/kubernetes/config \
    token_reviewer_jwt="$SA_JWT_TOKEN" \
    kubernetes_host="$K8S_HOST" \
    kubernetes_ca_cert="$SA_CA_CRT" \
    issuer="https://kubernetes.default.svc.cluster.local" \
    disable_iss_validation=false

TODO: create terraform pipeline for vault-secrets-operator
