# Flatcar Container Linux Nvidia Driver

> Note: this repo is a WIP.

docker build \
    --build-arg NVIDIA_DRIVER_VERSION=440.64 \
    --build-arg FLATCAR_VERSION=2605.9.0 .


# References

- https://github.com/kinvolk/coreos-overlay/blob/main/x11-drivers/nvidia-drivers/files/bin/setup-nvidia
- https://raw.githubusercontent.com/kinvolk/manifest/v2605.9.0/main.xml
- https://github.com/BugRoger/coreos-nvidia-driver
- https://docs.flatcar-linux.org/os/kernel-modules/
- https://github.com/paroque28/nvidia-driver/blob/c14c9cec01048936c995e19a705fa967ba1c9a5c/coreos/nvidia-driver





