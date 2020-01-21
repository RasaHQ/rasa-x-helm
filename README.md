# Rasa X Helm Chart

[![Join the chat on Rasa Community Forum](https://img.shields.io/badge/forum-join%20discussions-brightgreen.svg)](https://forum.rasa.com/?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](https://github.com/orgs/RasaHQ/projects/23)

[Rasa X](https://rasa.com/docs/rasa-x/) is a toolset that helps you leverage 
conversations to improve your [Rasa](https://rasa.com/docs/rasa) assistant.
This Helm chart provides a quick, production-ready deployment of Rasa X in your cluster.

> **_NOTE:_** Please see the [Rasa X documentation](https://rasa.com/docs/rasa-x/installation-and-setup/openshift-kubernetes/) for a detailed guide on usage and configuration of this chart.

## Installation

```bash
helm repo add rasa-x https://rasahq.github.io/rasa-x-helm
helm install --name <your release name> rasa-x-helm/rasa-x
```

## Upgrading
```
helm uprade --name <your release name> rasa-x-helm/rasa-x
```

## Uninstalling

```
helm delete <your release name>
```

## Prerequisites

* Kubernetes 1.12+
* [Helm](https://helm.sh/) 2.11+ or 3
* PV provisioner support in the underlying infrastructure

## Configuration

All configurable values are documented in `values.yaml`. For a quick installation we
recommend to set at least these values:

| Parameter                            | Description                                                                                | Default            |
|--------------------------------------|--------------------------------------------------------------------------------------------|--------------------|
| rasax.passwordSalt                   | Password salt which Rasa X uses for the user passwords.                                    | `passwordSalt`     |
| rasax.token                          | Token which the Rasa X pod uses to authenticate requests from other pods.                  | `rasaXToken`       |
| rasax.jwtSecret                      | Secret which is used to sign the JWT tokens.                                               | `jwtSecret`        |
| rasa.token                           | Token which the Rasa pods use to authenticate requests from other pods.                    | `rasaToken`        |
| rabbitmq.rabbitmq.password           | Password for RabbitMq.                                                                     | `test`             |
| global.postgresql.postgresqlPassword | Password for the Postgresql database.                                                      | `password`         |
| global.redis.password                | Password for redis.                                                                        | `password`         |
| securityContext.fsGroup              | fsGroup for the volume mounts. Should be `0` in case the  chart is deployed on Kubernetes. | `""`               |
| Chart.appVersion                     | Version of Rasa X which you want to use.                                                   | `0.24.1`           |
| rasa.tag                             | Version of Rasa OSS which you want to use.                                                 | `1.6.1`            |
| app.name                             | Name of your action server image.                                                          | `rasa/rasa-x-demo` |
| app.tag                              | Tag of your action server image.                                                           | `0.24.0`           |

## Where to get help

- If you are having bugs or suggestions for this Helm chart, please create an issue in this repository.
- If you have general questions about the usage, please create a thread in the [Rasa Forum](https://forum.rasa.com/).

## How to contribute

We are very happy to receive and merge your contributions. You can
find more information about how to contribute to Rasa (in lots of
different ways!) [here](http://rasa.com/community/contribute).

To contribute via pull request, follow these steps:

1. Create an issue describing the feature you want to work on.
2. Create a pull request describing your changes

## License
Licensed under the Apache License, Version 2.0.
Copyright 2020 Rasa Technologies GmbH. [Copy of the license](LICENSE.txt).
