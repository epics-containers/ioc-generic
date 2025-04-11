#!/bin/bash

# a script to run inside ioc-generic to enable testing of dev versions of
# pvxs and p4p

set -xe

# remove existing pvxs and p4p directories
rm -fr /epics/support/pvxs /epics/support/p4p

# pull in the dev versions of pvxs and p4p
ln -sf /workspaces/pvxs-dev /epics/support/pvxs
ln -sf /workspaces/p4p /epics/support/p4p
ln -sf /epics/support/configure/RELEASE  /epics/support/pvxs/configure/RELEASE.local
ln -sf /epics/support/configure/RELEASE  /epics/support/p4p/configure/RELEASE.local

# setup basic test IOC config
ln -s /workspaces/example-services/services/bl01t-ea-test-01/config /epics/ioc/config