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

```bash
helm upgrade <your release name> rasa-x/rasa-x
```

## Uninstalling

```bash
helm delete <your release name>
```

## Configuration

All configurable values are documented in `values.yaml`. For a quick installation we
recommend to set at least these values:

| Parameter                            | Description                                                                                  | Default            |
|--------------------------------------|----------------------------------------------------------------------------------------------|--------------------|
| `rasax.passwordSalt`                   | Password salt which Rasa X uses for the user passwords.                                    | `passwordSalt`     |
| `rasax.token`                          | Token which the Rasa X pod uses to authenticate requests from other pods.                  | `rasaXToken`       |
| `rasax.command`                        | Override the default command to run in the container.                                      | `[]`               |
| `rasax.args`                           | Override the default arguments to run in the container.                                    | `[]`               |
| `rasax.jwtSecret`                      | Secret which is used to sign JWT tokens of Rasa X users.                                   | `jwtSecret`        |
| `rasax.initialUser.username`           | **Only for Rasa Enterprise**. A name of the user that will be created immediately after the first launch (`rasax.initialUser.password` should be specified). | `admin`            |
| `rasax.initialUser.password`           | Password for the initial user. If you use Rasa Enterprise and leave it empty, no users will be created. If you use Rasa CE and leave it empty, the password will be generated automatically. | `""`               |
| `rasa.token`                           | Token which the Rasa pods use to authenticate requests from other pods.                    | `rasaToken`        |
| `rasa.command`                         | Override the default command to run in the container.                                      | `[]`               |
| `rasa.args`                            | Override the default arguments to run in the container.                                    | `[]`               |
| `rasa.extraArgs`                       | Additional rasa arguments.                                                                 | `[]`               |
| `rabbitmq.rabbitmq.password`           | Password for RabbitMq.                                                                     | `test`             |
| `global.postgresql.postgresqlPassword` | Password for the Postgresql database.                                                      | `password`         |
| `global.redis.password`                | Password for redis.                                                                        | `password`         |
| `rasax.tag`                            | Version of Rasa X which you want to use.                                                   | `0.29.1`           |
| `rasa.version`                         | Version of Rasa Open Source which you want to use.                                         | `2.0.3`            |
| `rasa.tag`                             | Image tag which should be used for Rasa Open Source. Uses `rasa.version` if empty.         | ``                 |
| `app.name`                             | Name of your action server image.                                                          | `rasa/rasa-x-demo` |
| `app.tag`                              | Tag of your action server image.                                                           | `0.29.1`           |
| `app.command`                          | Override the default command to run in the container.                                      | `[]`               |
| `app.args`                             | Override the default arguments to run in the container.                                    | `[]`               |
| `eventService.command`                 | Override the default command to run in the container.                                      | `[]`               |
| `eventService.args`                    | Override the default arguments to run in the container.                                    | `[]`               |
| `nginx.command`                        | Override the default command to run in the container.                                      | `[]`               |
| `nginx.args`                           | Override the default arguments to run in the container.                                    | `[]`               |
| `duckling.command`                     | Override the default command to run in the container.                                      | `[]`               |
| `duckling.args`                        | Override the default arguments to run in the container.                                    | `[]`               |
| `global.progressDeadlineSeconds`       | Specifies the number of seconds you want to wait for your Deployment to progress before the system reports back that the Deployment has failed progressing. | `600` |

## Where to get help

* If you encounter bugs or have suggestions for this Helm chart, please create an issue in this repository.
* If you have general questions about usage, please create a thread in the [Rasa Forum](https://forum.rasa.com/).

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
2. Run `helm lint --strict charts/rasa-x`
3. Increase the chart `version` in `charts/rasa-x/Chart.yaml`

### Changelog

[generate-changelog-action](https://github.com/scottbrenner/generate-changelog-action) is used to capture changelogs from commit messages. This means there is a special format for commit messages if you want them to appear in release change logs.

The format is as following:
```
type: description [flags]
```
where `type` is the category of the change, `description` is a short sentence to describe the change, and `flags` is an optional comma-separated list of one or more of the following (must be surrounded in square brackets):

`breaking`: alters `type` to be a breaking change

`type` can be
- feature
- fix
- build
- other
- perf
- refactor
- style
- test
- doc
- ...

For more information, please see [here](https://github.com/lob/generate-changelog#usage).

## License

Licensed under the Apache License, Version 2.0.
Copyright 2020 Rasa Technologies GmbH. [Copy of the license](LICENSE.txt).
