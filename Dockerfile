ARG FLATCAR_VERSION
ARG NVIDIA_DRIVER_VERSION

FROM mediadepot/flatcar-developer:${FLATCAR_VERSION}-sources as BUILD
LABEL maintainer="Jason Kulatunga <jason@thesparktree.com>"

ARG FLATCAR_VERSION
ARG NVIDIA_DRIVER_VERSION

WORKDIR /tmp
COPY compile.sh /compile.sh
RUN /compile.sh



#
#RUN grep "ERROR: Unable to load the kernel module 'nvidia.ko'" ${PWD}/nvidia-installer.log
#
## We copy the created binaries, shared libraries and kernel modules to a clean
## folder.
#
#RUN mkdir -p /opt/nvidia/${NVIDIA_DRIVER_VERSION}/${COREOS_VERSION}/bin
#RUN mkdir -p /opt/nvidia/${NVIDIA_DRIVER_VERSION}/${COREOS_VERSION}/lib64/modules/$(ls /usr/lib64/modules)/kernel/drivers/video/nvidia
#RUN find /build        -maxdepth 1 -name "nvidia-*" -executable -exec cp {} /opt/nvidia/${NVIDIA_DRIVER_VERSION}/${COREOS_VERSION}/bin \;
#RUN find /build        -maxdepth 1 -name "*.so.*"               -exec cp {} /opt/nvidia/${NVIDIA_DRIVER_VERSION}/${COREOS_VERSION}/lib64 \;
#RUN find /build/kernel -maxdepth 1 -name "*.ko"                 -exec cp {} /opt/nvidia/${NVIDIA_DRIVER_VERSION}/${COREOS_VERSION}/lib64/modules/$(ls /usr/lib64/modules)/kernel/drivers/video/nvidia \;
#
#
## Create a clean transport image containing only the driver
#
#FROM ubuntu
#LABEL maintainer "Michael Schmidt <michael.j.schmidt@gmail.com>"
#
#ARG COREOS_VERSION
#ARG NVIDIA_DRIVER_VERSION
#ARG NVIDIA_PRODUCT_TYPE
#
#ENV NVIDIA_DRIVER_COREOS_VERSION $COREOS_VERSION
#ENV NVIDIA_DRIVER_VERSION $NVIDIA_DRIVER_VERSION
#ENV NVIDIA_PRODUCT_TYPE $NVIDIA_PRODUCT_TYPE
#
#RUN apt-get update -qq && \
#    apt-get install -y kmod && \
#    rm -rf /var/lib/apt/lists/*
#
#COPY --from=BUILD /opt/nvidia /opt/nvidia
#COPY install.sh /
#
#ENTRYPOINT ["/install.sh"]
