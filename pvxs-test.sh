#!/bin/bash

# start ioc-generic-developer with the dev version of pvxs
# mount in a demo IOC config
# also forward ports for pva and p4p
# also set the EPICS_PVA_SERVER_PORT

podman run -e EPICS_PVA_SERVER_PORT=5085 \
    -p5064:5064/udp -p5064:5064/tcp -p172.23.245.116:5076:5076/udp -p5085:5085/tcp \
    -itv /scratch/hgv27681/work/:/workspaces \
    -v /scratch/hgv27681/work/pvxs-dev:/epics/support/pvxs \
    -v /scratch/hgv27681/work/example-services/services/bl01t-ea-test-01/config/:/epics/ioc/config \
    --rm ghcr.io/epics-containers/ioc-generic-developer:2025.4.2b1 \
    /epics/ioc/start.sh
