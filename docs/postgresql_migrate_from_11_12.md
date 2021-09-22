# Migration from PostgreSQL 11 to 12

This document describes how to migrate from PostgreSQL 11 that was used for charts < 3.0.0 to PostgreSQL 12.

***Note*** The procedure describes below causes downtime of your service.

## Create a backup

1. Create a persistent volume claim that will be used to store backup.

  ```text
  kubectl -n <your-namespace> create -f examples/backup-pvc.yaml
  ```

2. Mount an extra volume to the postgresql deployment using the following values.

```yaml
# values.yaml

# postgresql specific settings (https://hub.helm.sh/charts/bitnami/postgresql/8.6.13)
postgresql:
  master:
    extraVolumes:
      - name: backup
        persistentVolumeClaim:
          claimName: backup-rasa-x-postgresql-0
    extraVolumeMounts:
      - mountPath: /backup
        name: backup
```

3. Upgrade the deployment.

```yaml
helm -n <your-namespace> upgrade -f values.yaml --reuse-values <release-name> rasa-x/rasa-x
```

4. Create a backup

```text
kubectl -n tczekajlo-test exec <release-name>-postgresql-0 -- /bin/bash -c 'PGPASSWORD=${POSTGRES_PASSWORD} pg_dump -U postgres --format=c --file=/backup/dump_backup.bak rasa'
```

## Restore backup

1. Update the chart repository.

```text
helm repo update
```

2. Change PostgreSQL data directory and mount the backup volume.

```yaml
# values.yaml
postgresql:
  image:
    # tag of PostgreSQL Image
    tag: "12.8.0"

  extraEnv:
    - name: PGDATA
      value: /bitnami/postgresql/data_12

  # Mount the volume with the backup
  master:
    extraVolumes:
      - name: backup
        persistentVolumeClaim:
          claimName: backup-rasa-x-postgresql-0
    extraVolumeMounts:
      - mountPath: /backup
        name: backup
```

Apply the values:

```yaml
helm -n <your-namespace> upgrade -f values.yaml <release-name> --version <helm-chart-version> rasa-x/rasa-x
```

Helm chart version can be checked by executing the `helm -n <namespace> list`.

3. Restore the backup

```text
kubectl -n <your-namespace> exec rasa-x-postgresql-0 -- /bin/bash -c 'PGPASSWORD=${POSTGRES_PASSWORD} pg_restore --format=c -U postgres --dbname=rasa --exit-on-error --no-acl --no-owner --role=postgres /backup/dump_backup.bak'
```

The backup volume is not needed anymore and can be removed from the deployment.
