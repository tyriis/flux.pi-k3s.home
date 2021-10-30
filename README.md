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
// example: kubectl label node <node-name> k3s-upgrade=true
kubectl label node pi-node01 plan.upgrade.cattle.io/raspbian=true
kubectl label node pi-node02 plan.upgrade.cattle.io/raspbian=true
kubectl label node pi-node03 plan.upgrade.cattle.io/raspbian=true
```

### retrieve self-signed trusted cs certs
```sh
openssl req -new -newkey rsa:2048 -keyout .k8s.home_host_key.pem -nodes -subj "/CN=*.k8s.home" |   curl -v -fk --data-binary @- -o k8s.home_host.pem "https://cubietruck/sign?ns=*.k8s.home"
```

### create cert from files
```sh
kubectl create secret -n gitlab tls k8s-home-cert --key=".k8s.home_host_key.pem" --cert="k8s.home_host.pem" --dry-run=client -o yaml > k8s-home-cert.yaml
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
< certificate.yaml > certificate.yaml
```

### create gitlab runner certs
```sh
kubectl create secret generic gitlab-runner-certs -n gitlab  --from-file=gitlab.k8s.home.crt="k8s.home_host.pem" --from-file=registry.k8s.home.crt="k8s.home_host.pem"  --from-file=minio.k8s.home.crt="k8s.home_host.pem" --dry-run=client -o yaml > gitlab-runner-certs.yaml
```
and seal
```sh
kubectl create secret generic gitlab-runner-certs -n gitlab  --from-file=gitlab.k8s.home.crt="k8s.home_host.pem" --from-file=registry.k8s.home.crt="k8s.home_host.pem"  --from-file=minio.k8s.home.crt="k8s.home_host.pem" --dry-run=client -o yaml > gitlab-runner-certs.yaml
```
