#!/bin/bash
set -e

echo "Compiling NVIDIA modules"
mkdir -p /tmp/nvidia
pushd /tmp/nvidia
curl -Ls "http://us.download.nvidia.com/XFree86/Linux-x86_64/$NVIDIA_DRIVER_VERSION/NVIDIA-Linux-x86_64-$NVIDIA_DRIVER_VERSION.run" -o nvidia.run
chmod +x nvidia.run
./nvidia.run -x -s
pushd "./NVIDIA-Linux-x86_64-$NVIDIA_DRIVER_VERSION"
export IGNORE_MISSING_MODULE_SYMVERS=1
export KERNEL_VERSION=$(cat /usr/src/linux/include/config/kernel.release || ls /lib/modules) # see https://superuser.com/questions/504684/is-the-version-of-the-linux-kernel-listed-in-the-source-some-where
# see https://github.com/NVIDIA/nvidia-installer/blob/eef089de55aeabe537c67a17e1f71db99aa23be6/option_table.h for a full list of options/flags
./nvidia-installer -s -n \
  --kernel-name="${KERNEL_VERSION}" \
  --kernel-source-path=/usr/src/linux \
  --no-check-for-alternate-installs \
  --no-opengl-files \
  --no-distro-scripts \
  --kernel-install-path="/$PWD" \
  --log-file-name="$PWD"/nvidia-installer.log || true

# Ok, so the installer always fails. It tries to load the built kernel module. That
# doesn't work in the Docker container at this time. We usually don't have a GPU or
# permissions to do so.

if [ -e kernel/nvidia.ko ] ; then echo "Successfully compiled NVIDIA modules" ; else echo "Failed to compile NVIDIA modules" && cat "$PWD"/nvidia-installer.log && exit 1 ; fi

echo "Archiving assets"
mkdir -p /out/lib/modules/"$KERNEL_VERSION" /out/bin
cp ./*.so* /out/lib
cp kernel/*.ko /out/lib/modules/"$KERNEL_VERSION"
for b in nvidia-debugdump nvidia-cuda-mps-control nvidia-xconfig nvidia-modprobe nvidia-smi nvidia-cuda-mps-server nvidia-persistenced nvidia-settings; do cp "$b" /out/bin/; done
cp /install.sh /out/install.sh
chmod +x /out/install.sh
