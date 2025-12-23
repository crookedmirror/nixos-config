# Installation

## Installation on QEMU vm

1. create qcow drive

```bash
qemu-img create -f qcow2 nixos.qcow2 100G
```

2.  start the vm

```bash
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
  -display gtk
```

3. Set the password for nixos user so it is accessible from host via ssh

```bash
passwd
```

4. From host ssh into guest using password from point 3

```bash
ssh -p 2224 nixos@localhost
```

5. Install testvm host from ssh session on guest

```bash
git clone https://github.com/crookedmirror/nixos-config
sudo -i
nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /home/nixos/nixos-config/hosts/testvm/disko.nix
nixos-install --flake /home/nixos/nixos-config#testvm \
  --option 'extra-substituters' 'https://cache.garnix.io https://attic.xuyh0120.win/lantian' \
  --option 'extra-trusted-public-keys' 'cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g= lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc='

cp -r /home/nixos/nixos-config /mnt/var/persistent

reboot
```
