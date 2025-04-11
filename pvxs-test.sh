#!/bin/bash

podman run -p5064:5064/udp -p5064:5064/tcp -p5076:5076/udp -p5075:5075/tcp \
       -itv /scratch/hgv27681/work/:/workspaces \
       -v /scratch/hgv27681/work/example-services/services/bl01t-ea-test-01/config/:/epics/ioc/config \
       --rm ghcr.io/epics-containers/ioc-generic-developer:2025.4.2b1 \
       /epics/ioc/start.sh