ARG IMAGE_EXT

ARG REGISTRY=ghcr.io/epics-containers
ARG RUNTIME=${REGISTRY}/epics-base${IMAGE_EXT}-runtime:7.0.9ec5
# base this image on the standard set of support modules including asyn
ARG DEVELOPER=${REGISTRY}/ioc-asyn${IMAGE_EXT}-developer:4.45ec2

##### build stage ##############################################################
FROM  ${DEVELOPER} AS developer

# The devcontainer mounts the project root to /epics/generic-source
# Using the same location here makes devcontainer/runtime differences transparent.
ENV SOURCE_FOLDER=/epics/generic-source
# connect ioc source folder to its know location
RUN ln -s ${SOURCE_FOLDER}/ioc ${IOC}

# # Get an updated version of ibek if needed
# COPY requirements.txt requirements.txt
# RUN uv pip install --upgrade -r requirements.txt

##### Additional support modules would go here##################################

# e.g.
# COPY ibek-support/MySupportModule/ MySupportModule/
# RUN ansible.sh MySupportModule


##### Get and build the IOC source #############################################
COPY ioc ${SOURCE_FOLDER}/ioc
RUN ansible.sh ioc

##### runtime preparation stage ################################################
FROM developer AS runtime_prep

# get the products from the build stage and reduce to runtime assets only
# /python is created by uv and is needed in the runtime target
RUN ibek ioc extract-runtime-assets /assets /python

##### runtime stage ############################################################
FROM ${RUNTIME} AS runtime

# get runtime assets from the preparation stage
COPY --from=runtime_prep /assets /

# install runtime system dependencies, collected from install.sh scripts
RUN ibek support apt-install-runtime-packages

# launch the startup script with stdio-expose to allow console connections
CMD ["bash", "-c", "${IOC}/start.sh"]
