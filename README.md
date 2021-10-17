# flux.pi-k3s.home

## system-upgrade
### label nodes for upgrade manually
```sh
// example: kubectl label node <node-name> k3s-upgrade=true
kubectl label node pi-node01 k3s-upgrade=true
kubectl label node pi-node02 k3s-upgrade=true
kubectl label node pi-node03 k3s-upgrade=true
```