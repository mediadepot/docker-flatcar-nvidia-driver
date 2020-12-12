ARG FLATCAR_VERSION
ARG NVIDIA_DRIVER_VERSION

FROM mediadepot/flatcar-developer:${FLATCAR_VERSION}-sources as BUILD
LABEL maintainer="Jason Kulatunga <jason@thesparktree.com>"

ARG FLATCAR_VERSION
ARG NVIDIA_DRIVER_VERSION

WORKDIR /tmp
COPY compile.sh /compile.sh
COPY install.sh /install.sh
RUN /compile.sh



# Create a clean transport image containing only the driver
FROM busybox
LABEL maintainer="Jason Kulatunga <jason@thesparktree.com>"

COPY --from=BUILD /out/ /out/
