# helm-charts

## Uploading new chart version
There's already a CD flow configured for the repository.  
It automatically detects version changes in the charts inside `charts/` directory.  
If a new version is detected, it will upload the chart to the [GitHub Pages](https://helm-charts.velocity.tech/).
Don't forget to bump the version in `Chart.yaml` file.  
The version should follow [semver](https://semver.org/) format.  

## Installing chart on current context
To install the chart on the current context, run:  
```bash
helm install <name> charts/<chart-name>"
```

## Available charts
- [veloperator](https://github.com/techvelocity/veloperator)
