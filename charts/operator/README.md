# Velocity Operator

## Installation

```bash
helm repo add velocity https://helm-charts.velocity.tech
helm repo update

helm upgrade --install operator velocity/operator --version <version> \
  --namespace=velocity-system \
  --create-namespace 
```

In order for the sidecar to work, users must create a secret with the following schema:

```yaml
PGHOST: "velocity-postgres.c748cme8k8yr.eu-central-1.rds.amazonaws.com"
PGPORT: "5432"
PGUSER: "postgres"
PGPASSWORD: "***"
PGSSLMODE: "require"
PGDATABASE: "postgres"
PGSCHEMA: "public"
PGAPPNAME: "telegraf-sidecar"
```

The secret name defaults to the name of the operator (when using this chart).
If you want to use a different secret name, you can set the `sidecar.secretName` value.

### Configuration and Replication

Note that the telegraf configuration and secret must be in the same namespace as the sidecar.
This means that users must recreate the secret and copy-paste the configmap to the correct namespace.
Users can use projects like [Reflector](https://github.com/emberstack/kubernetes-reflector) to automate this process.

#### Manual steps

make sure to relace placholders and check all the values make sense for your setup:

> 💡💡 See [demo-customer.values.yaml](../../demo-customer.values.yaml) for the appropriate values structure.

##### Creating a initial secret

```bash
# we use the clipboard to avoid storing the password in the shell history or a local file
# COPY PASSWORD TO CLIPBOARD, AND THEN:
export PGPASSWORD=$(pbpaste) 

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: velocity-postgres-config
  namespace: velocity-system
stringData:
  PGHOST: "velocity-postgres.c748cme8k8yr.eu-central-1.rds.amazonaws.com"
  PGPORT: "5432"
  PGUSER: "postgres"
  PGPASSWORD: "$PGPASSWORD"
  PGSSLMODE: "require"
  PGDATABASE: "postgres"
  PGSCHEMA: "public"
  PGAPPNAME: "velocity-sensor"
EOF
```

##### Replicate the secret

```bash
export NEW_NAMESPACE=<your-namespace>
kubectl -n velocity-system get secret velocity-postgres-config -o yaml | \
  sed 's/namespace: velocity-system/namespace: '$NEW_NAMESPACE'/' | \
  kubectl apply -f -
```

##### Create an initial configmap

> THIS IS A WAY TO OVERRIDE THE DEFAULT CONFIGMAP. YOU CAN SKIP THIS STEP AND USE THE EXITING ONE.

```bash
export PATH_TO_TELEGRAF_CONF=sidecarsensor/telegraf.conf

# read the note in all caps above before running this command
kubectl -n velocity-system create configmap velocity-config \
  --from-file="telegraf.conf=$PATH_TO_TELEGRAF_CONF" 
```

##### Replicate the configmap

```bash
export NEW_NAMESPACE=<your-namespace>

# adjust the configmap name if you've you're using the default one from the helm installtion
kubectl -n velocity-system get configmap velocity-config -o yaml | \
  sed 's/namespace: velocity-system/namespace: '$NEW_NAMESPACE'/' | \
  kubectl apply -f -
```
