# Flatcar Container Linux Nvidia Driver

> Note: this repo is a WIP.

```
# Prepare Environment
source /usr/share/coreos/release
export FORKLIFT_DRIVER_NAME=nvidia
export FORKLIFT_INSTALL_DIR=${FORKLIFT_INSTALL_DIR:-/opt/drivers}
export FORKLIFT_CACHE_DIR="${FORKLIFT_INSTALL_DIR}/archive/${FORKLIFT_DRIVER_NAME}"

# Prepare Filesystem
mkdir -p "$FORKLIFT_INSTALL_DIR"
mkdir -p "$FORKLIFT_CACHE_DIR"
rm -rf "${FORKLIFT_INSTALL_DIR:?}/${FORKLIFT_DRIVER_NAME}"

# Extract Drivers From Docker Image
docker run --rm -v ${FORKLIFT_CACHE_DIR}/${FLATCAR_RELEASE_VERSION}:/out mediadepot/flatcar-nvidia-driver:flatcar_${FLATCAR_RELEASE_VERSION}-nvidia_latest

# setup symlink from cache directory to "install" directory
ln -s "${FORKLIFT_CACHE_DIR}/${FLATCAR_RELEASE_VERSION}" "${FORKLIFT_INSTALL_DIR}/${FORKLIFT_DRIVER_NAME}"


if [ -d "${FORKLIFT_INSTALL_DIR}/${FORKLIFT_DRIVER_NAME}/lib" ] ; then
    mkdir -p "${FORKLIFT_LD_ROOT}/etc/ld.so.conf.d"
    echo "${FORKLIFT_INSTALL_DIR}/${FORKLIFT_DRIVER_NAME}/lib" > "${FORKLIFT_LD_ROOT}/etc/ld.so.conf.d/${FORKLIFT_DRIVER_NAME}.conf"
    ldconfig -r "${FORKLIFT_LD_ROOT}" 2> /dev/null
fi
# shellcheck disable=SC1090
source "${FORKLIFT_INSTALL_DIR}/${FORKLIFT_DRIVER_NAME}/install.sh"

```


docker build \
    --build-arg NVIDIA_DRIVER_VERSION=440.64 \
    --build-arg FLATCAR_VERSION=2605.9.0 .


# References

- https://github.com/kinvolk/coreos-overlay/blob/main/x11-drivers/nvidia-drivers/files/bin/setup-nvidia
- https://raw.githubusercontent.com/kinvolk/manifest/v2605.9.0/main.xml
- https://github.com/BugRoger/coreos-nvidia-driver
- https://docs.flatcar-linux.org/os/kernel-modules/
- https://github.com/paroque28/nvidia-driver/blob/c14c9cec01048936c995e19a705fa967ba1c9a5c/coreos/nvidia-driver





