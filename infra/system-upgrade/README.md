# system-upgrade
### label nodes for upgrade manually
```sh
// example: kubectl label node <node-name> k3s-upgrade=true
kubectl label node pi-node01 plan.upgrade.cattle.io/k3s=true
kubectl label node pi-node02 plan.upgrade.cattle.io/k3s=true
kubectl label node pi-node03 plan.upgrade.cattle.io/k3s=true
kubectl label node pi-node04 plan.upgrade.cattle.io/k3s=true
```
