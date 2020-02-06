# Rasa X Helm Chart

[![Join the chat on our Rasa Community Forum](https://img.shields.io/badge/forum-join%20discussions-brightgreen.svg)](https://forum.rasa.com/?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](https://github.com/orgs/RasaHQ/projects/23)

[Rasa X](https://rasa.com/docs/rasa-x/) is a toolset that helps you leverage 
conversations to improve your [Rasa](https://rasa.com/docs/rasa) assistant.
This Helm chart provides a quick, production-ready deployment of Rasa X in your cluster.

> **_NOTE:_** Please see the [Rasa X documentation](https://rasa.com/docs/rasa-x/installation-and-setup/openshift-kubernetes/) for a detailed guide on usage and configuration of this chart.

## Prerequisites

* [Kubernetes](https://kubernetes.io/docs/setup/) 1.12+
* [Helm](https://helm.sh/) 2.11+ or 3
* Persistent Volume provisioner support in the underlying infrastructure

## Installation

```bash
helm repo add rasa-x https://rasahq.github.io/rasa-x-helm
helm install <your release name> rasa-x/rasa-x
```

## Upgrading the deployment
```
helm upgrade <your release name> rasa-x/rasa-x
```

## Uninstalling

```
helm delete <your release name>
```

## Configuration

All configurable values are documented in `values.yaml`. For a quick installation we
recommend to set at least these values:

| Parameter                            | Description                                                                                | Default            |
|--------------------------------------|--------------------------------------------------------------------------------------------|--------------------|
| rasax.passwordSalt                   | Password salt which Rasa X uses for the user passwords.                                    | `passwordSalt`     |
| rasax.token                          | Token which the Rasa X pod uses to authenticate requests from other pods.                  | `rasaXToken`       |
| rasax.jwtSecret                      | Secret which is used to sign JWT tokens of Rasa X users.                           | `jwtSecret`        |
| rasax.initialUser.username           | **Only for Rasa Enterprise**. A name of the user that will be created immediately after the first launch (`rasax.initialUser.password` should be specified) | `admin`            |
| rasax.initialUser.password           | Password for the initial user. If you use Rasa Enterprise and leave it empty, no users will be created. If you use Rasa CE and leave it empty, the password will be generated automatically. | `""`               |
| rasa.token                           | Token which the Rasa pods use to authenticate requests from other pods.                    | `rasaToken`        |
| rabbitmq.rabbitmq.password           | Password for RabbitMq.                                                                     | `test`             |
| global.postgresql.postgresqlPassword | Password for the Postgresql database.                                                      | `password`         |
| global.redis.password                | Password for redis.                                                                        | `password`         |
| securityContext.runAsUser            | The UID to run the entrypoint of container processes                                       | `1000`             |
| securityContext.fsGroup              | A special supplemental group that applies to all containers in a pod                       | `1000`             |
| securityContext.runAsNonRoot         | Indicates that the container must run as a non-root user                                   | `true`             |
| Chart.appVersion                     | Version of Rasa X which you want to use.                                                   | `0.25.0`           |
| rasa.tag                             | Version of Rasa OSS which you want to use.                                                 | `1.7.0`            |
| app.name                             | Name of your action server image.                                                          | `rasa/rasa-x-demo` |
| app.tag                              | Tag of your action server image.                                                           | `0.25.0`           |

## Where to get help

- If you encounter bugs or have suggestions for this Helm chart, please create an issue in this repository.
- If you have general questions about usage, please create a thread in the [Rasa Forum](https://forum.rasa.com/).

## How to contribute

We are very happy to receive and merge your contributions. You can
find more information about how to contribute to Rasa (in lots of
different ways!) [here](http://rasa.com/community/contribute).

To contribute via pull request, follow these steps:

1. Create an issue describing the feature you want to work on
2. Create a pull request describing your changes


## Development Internals
### Releasing a new version of this chart

This repository automatically release a new version of the Helm chart once new changes
are merged. The only required steps are:

1. Make the changes to the chart
2. Increase the chart `version` in `charts/rasa-x/Chart.yaml`

## License
Licensed under the Apache License, Version 2.0.
Copyright 2020 Rasa Technologies GmbH. [Copy of the license](LICENSE.txt).
