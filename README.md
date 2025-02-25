# Generic IOC ioc-generic

## Description
A 'generic' generic IOC that provides a quick to launch IOC devcontainer. e.g. for developing new support modules.

## Template Info
This repository was generated by
[ioc-template](https://github.com/epics-containers/ioc-template)

To update to the latest version of the template:

```bash
# activate a python virtual environment

pip install copier
cd ioc-generic
copier update -a --trust .
```

## Developer Container

This repository includes a developer container configuration for Visual Studio Code. This allows you to run the Generic IOC locally and debug it. See https://epics-containers.github.io/main/tutorials/dev_container.html.

## Channel Access

The vscode developer container auto forwards the channel access ports on the loopback interface. If you have channel access clients running on the host machine, you can connect to the IOC by setting the `EPICS_CA_NAME_SERVERS` environment variable as follows:

```bash
export EPICS_CA_NAME_SERVERS=127.0.0.1:5064
caget IOCNAME:PVNAME
```
