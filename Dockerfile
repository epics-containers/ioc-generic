ARG IMAGE_EXT

ARG BASE=7.0.9ec3
ARG REGISTRY=ghcr.io/epics-containers
ARG RUNTIME=${REGISTRY}/epics-base${IMAGE_EXT}-runtime:${BASE}
ARG DEVELOPER=${REGISTRY}/epics-base${IMAGE_EXT}-developer:${BASE}

##### build stage ##############################################################
FROM  ${DEVELOPER} AS developer

# useful for debugging
RUN apt-get update && apt-get install -y \
    net-tools \
    iputils-ping \
    less \
    && rm -rf /var/lib/apt/lists/*
COPY bin /root/bin
ENV PATH=/root/bin:${PATH}

# The devcontainer mounts the project root to /epics/generic-source
# Using the same location here makes devcontainer/runtime differences transparent.
ENV SOURCE_FOLDER=/epics/generic-source
# connect ioc source folder to its know location
RUN ln -s ${SOURCE_FOLDER}/ioc ${IOC}

# Get the current version of ibek
COPY requirements.txt requirements.txt
RUN pip install --upgrade -r requirements.txt

WORKDIR ${SOURCE_FOLDER}/ibek-support

# copy the global ibek files
COPY ibek-support/_global/ _global

COPY ibek-support/iocStats/ iocStats
RUN iocStats/install.sh 3.2.0

COPY ibek-support/sequencer/ sequencer
RUN sequencer/install.sh R2-2-5

COPY ibek-support/asyn/ asyn/
RUN asyn/install.sh R4-42

COPY ibek-support/std/ std
RUN std/install.sh R3-6-4

COPY ibek-support/busy/ busy/
RUN busy/install.sh R1-7-3

COPY ibek-support/sscan/ sscan/
RUN sscan/install.sh R2-11-6

COPY ibek-support/calc/ calc/
RUN calc/install.sh R3-7-5

COPY ibek-support/autosave/ autosave/
RUN autosave/install.sh R5-11

################################################################################
#  TODO - Add further support module installations here
################################################################################

# get the ioc source and build it
COPY ioc ${SOURCE_FOLDER}/ioc
RUN cd ${IOC} && ./install.sh && make

# install runtime proxy for non-native builds
RUN bash ${IOC}/install_proxy.sh

##### runtime preparation stage ################################################
FROM developer AS runtime_prep

# get the products from the build stage and reduce to runtime assets only
RUN ibek ioc extract-runtime-assets /assets

##### runtime stage ############################################################
FROM ${RUNTIME} AS runtime

# get runtime assets from the preparation stage
COPY --from=runtime_prep /assets /

# install runtime system dependencies, collected from install.sh scripts
RUN ibek support apt-install-runtime-packages --skip-non-native

CMD ["bash", "-c", "${IOC}/start.sh"]
