# helm-charts

# Velocity Helm Charts

## How to use this repo

- Add this repo to your helm repos:

```bash
helm repo add velocity https://helm-charts.velocity.tech
```

- Update the helm repository listing:

```bash
helm repo update
```

- Install the chart:

```bash
helm install <chart-name> velocity/<chart-name>
```

## Available charts

- [operator](https://github.com/techvelocity/helm-charts/tree/main/charts/operator) - A Helm chart for deploying the Velocity Operator
