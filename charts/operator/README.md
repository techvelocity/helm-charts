# Velocity Operator

## Installation

```bash
helm repo add velocity https://helm-charts.velocity.tech
helm repo update

helm upgrade --install operator velocity/operator --version <version> \
  --namespace=velocity-system \
  --create-namespace 
```
