#!/bin/bash
set -e
# This script must be executed on the flatcar host, not within a container

export FORKLIFT_LD_ROOT=${FORKLIFT_LD_ROOT:-/}

depmod -b "$FORKLIFT_LD_ROOT"
# This is an NVIDIA dep that is not specified in the module.dep file.
modprobe -d "$FORKLIFT_LD_ROOT" ipmi_devintf
depmod -b "${FORKLIFT_INSTALL_DIR}/${FORKLIFT_DRIVER_NAME}"
modprobe -d "${FORKLIFT_INSTALL_DIR}/${FORKLIFT_DRIVER_NAME}" nvidia
modprobe -d "${FORKLIFT_INSTALL_DIR}/${FORKLIFT_DRIVER_NAME}" nvidia-uvm
if [ ! -e /dev/nvidia0 ] ; then
    NVDEVS=$(lspci | grep -i NVIDIA)
    N3D=$(echo "$NVDEVS" | grep -c "3D controller") || true
    NVGA=$(echo "$NVDEVS" | grep -c "VGA compatible controller") || true
    N=$((N3D + NVGA - 1)) || true
    for i in $(seq 0 $N); do mknod -m 666 /dev/nvidia"$i" c 195 "$i"; done
fi
if [ ! -e /dev/nvidiactl ] ; then
    mknod -m 666 /dev/nvidiactl c 195 255
fi
if [ ! -e /dev/nvidia-uvm ] ; then
    D=$(grep nvidia-uvm /proc/devices | cut -d " " -f 1)
    mknod -m 666 /dev/nvidia-uvm c "$D" 0
fi
