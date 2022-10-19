# helm-charts
# Velocity Helm Charts
## How to use this repo
- Add this repo to your helm repos:
```bash
helm repo add charts https://helm-charts.velocity.tech
```
- Update the helm repository listing:
```bash
helm repo update
```
- Install the chart:
```bash
helm install <chart-name> charts/<chart-name>
```

## Available charts
- [veloperator](https://github.com/techvelocity/helm-charts/tree/main/charts/veloperator) - Spin up fully isolated, ephemeral environments in seconds.  
  Develop code on your local machine and test it on a production-like environment.