#!/usr/bin/env bash

# Create TPM state directory if needed
mkdir -p ./testvm-tpm

# Start swtpm (software TPM emulator) in background
swtpm socket --tpmstate dir=./testvm-tpm \
  --ctrl type=unixio,path=./testvm-swtpm.sock \
  --tpm2 \
  --log level=20 &

SWTPM_PID=$!

# Trap to cleanup swtpm on exit
trap "kill $SWTPM_PID 2>/dev/null" EXIT

# Give swtpm time to start
sleep 1

qemu-system-x86_64 \
  -enable-kvm \
  -M q35 \
  -m 8G \
  -smp 4 \
  -cpu host \
  -boot order=d,menu=on \
  -drive if=pflash,format=raw,readonly=on,file=/usr/share/OVMF/OVMF_CODE_4M.fd \
  -drive if=pflash,format=raw,file=./testvm-OVMF_VARS.fd \
  -drive file=testvm.qcow2,if=none,id=drive0,format=qcow2 \
  -device virtio-blk-pci,drive=drive0,serial=testvm-main \
  -drive file=/home/jarvis/nixos-config/nixos-minimal.iso,media=cdrom,readonly=on \
  -device virtio-net,netdev=nic \
  -netdev user,hostfwd=tcp::2224-:22,hostname=testvm,id=nic \
  -chardev socket,id=chrtpm,path=./testvm-swtpm.sock \
  -tpmdev emulator,id=tpm0,chardev=chrtpm \
  -device tpm-tis,tpmdev=tpm0 \
  -display gtk

# Cleanup swtpm after QEMU exits
kill $SWTPM_PID 2>/dev/null
