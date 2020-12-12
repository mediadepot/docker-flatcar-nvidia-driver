#!/bin/bash
set -e
# This script must be executed on the flatcar host, not within a container

# TODO: check if we can verify that this is running in the correct context (host vs container)

local DRIVER_NAME=$1
local DRIVER_VERSION=$2
mkdir -p "$MODULUS_INSTALL_DIR"
rm -rf "${MODULUS_INSTALL_DIR:?}"/"$DRIVER_NAME"
ln -s "$MODULUS_CACHE_DIR"/"$DRIVER_NAME"/"$DRIVER_VERSION" "$MODULUS_INSTALL_DIR"/"$DRIVER_NAME"

if [ -d "$MODULUS_INSTALL_DIR"/"$DRIVER_NAME"/lib ] ; then
    mkdir -p "$MODULUS_LD_ROOT"/etc/ld.so.conf.d
    echo "$MODULUS_INSTALL_DIR"/"$DRIVER_NAME"/lib > "$MODULUS_LD_ROOT"/etc/ld.so.conf.d/"$DRIVER_NAME".conf
    ldconfig -r "$MODULUS_LD_ROOT" 2> /dev/null
fi
# shellcheck disable=SC1090
source "$MODULUS_BIN_DIR"/"$DRIVER_NAME"/install


depmod -b "$MODULUS_LD_ROOT"
# This is an NVIDIA dep that is not specified in the module.dep file.
modprobe -d "$MODULUS_LD_ROOT" ipmi_devintf
depmod -b "$MODULUS_INSTALL_DIR/$DRIVER_NAME"
modprobe -d "$MODULUS_INSTALL_DIR/$DRIVER_NAME" nvidia
modprobe -d "$MODULUS_INSTALL_DIR/$DRIVER_NAME" nvidia-uvm
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
