#!/usr/bin/env sh
# https://github.com/PedroHLC/system-setup/blob/94e7a325bbf760c56fa2ae47608c2a2f41e4fb81/packages/scripts/nvidia-offload.sh
# Run stuff in the NVIDIA GPU in a prime-offload setup.

if [ -e /sys/module/nvidia ]; then
  export __GLX_VENDOR_LIBRARY_NAME="nvidia"
  export __NV_PRIME_RENDER_OFFLOAD=1
  export __NV_PRIME_RENDER_OFFLOAD_PROVIDER="NVIDIA-G0"
  export __VK_LAYER_NV_optimus="NVIDIA_only"
  export VK_DRIVER_FILES="/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/nvidia_icd.i686.json"
  export LIBVA_DRIVER_NAME="nvidia"
else
  export DRI_PRIME=1
  export VK_DRIVER_FILES="/run/opengl-driver/share/vulkan/icd.d/nouveau_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/nouveau_icd.i686.json"
  #export LIBVA_DRIVER_NAME="nouveau"
fi

exec "$@"
