# Migration from v2 to v3

This page describe how to upgrade the rasa-x-helm chart from version 2 to version 3.

Key changes:

- Default version for PostgreSQL is 12.8
- The rasa production deployment is disabled by default.
- The default username for Rasa X is "admin".

## Migrate PostgreSQL to 12.8

Before you upgrade the rasa-x-helm chart version, you should migrate PostgreSQL to 12.8. Check [the migration guide](./postgresql_migrate_from_11_12.md) for PostgreSQL to learn how to do this.

Things to keep in mind:

- The migration guide for PostgreSQL works only if you use PostgreSQL deployed by the helm chart.
- Migration of PostgreSQL is required only if you want to use Rasa X >= 1.0, if you want to upgrade only the helm version, then this step is not necessary.

## Upgrade the helm chart version

1. Explicitly define values for parameters that have changed.

If you have a `values.yaml` file that you use for your deployment, all parameters below should be defined explicitly.
If you use the `--reuse-values` flag, this step can be skipped, but it's a good practice to define values explicitly.

```yaml
# values.yaml
ingress:
  # if you don't use Ingress, this step can be skipped.
  enabled: true

rasa:
  versions:
    rasaProduction:
      # enable the rasa-production deployment
      # if you use an external Rasa OSS deployment, this step can be skipped.
      enabled: true
```

2. Update the helm repository.

```text
helm repo update
```

3. Upgrade the helm chart version.

```yaml
helm -n <your-namespace> upgrade -f values.yaml --version <chart-version> <release-name> rasa-x/rasa-x
```
