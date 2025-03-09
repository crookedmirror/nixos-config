#!/usr/bin/env sh
export DRI_PRIME=1
export VK_DRIVER_FILES="/run/opengl-driver/share/vulkan/icd.d/nouveau_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/nouveau_icd.i686.json"
exec "$@"
