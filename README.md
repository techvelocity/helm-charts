# helm-charts

## Installation
```bash
helm repo add velocity https://helm-charts.velocity.tech
helm repo update

helm install <name> velocity/<chart> --version <version>
```

## Upgrading dependencies
Dependency changes are done in `Chart.yaml`.    
After your change, run `helm dependency update` to update the `requirements.lock` file.     
In case you update AWS ACK controller, You will also need to do the following:
1. Open the downloaded chart inside the `charts` folder
2. Compare the CRDs located in `crds` folder inside the chart, to the `templates/crds` folder in our chart - make sure there aren't any API breaking changes (for example, a new CRD API version)
3. Copy and overwrite the CRDs located in `crds` folder inside the chart, to the `templates/crds` folder in our chart.
4. Make sure to keep the "if cloud resources" condition if exists

## Contribution
### Uploading new chart version
There's already a CD flow configured for the repository.  
It automatically detects version changes in the charts inside `charts/` directory.  
If a new version is detected, it will upload the chart to the [GitHub Pages](https://helm-charts.velocity.tech/).
Don't forget to bump the version in `Chart.yaml` file.  
The version should follow [semver](https://semver.org/) format.  

### Installing chart on current context
To install a chart for testing on the current context, run:  
```bash
helm install <name> ./charts/<chart-name> [--set <key>=<value>]
```
