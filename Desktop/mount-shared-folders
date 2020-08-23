#!/bin/sh
vmware-hgfsclient | while read folder; do
  vmwpath="/mnt/hgfs/${folder}"
  echo "[i] Mounting ${folder}   (${vmwpath})"
  sudo mkdir -p "${vmwpath}"
  sudo umount -f "${vmwpath}" 2>/dev/null
  sudo vmhgfs-fuse -o allow_other -o auto_unmount ".host:/${folder}" "${vmwpath}"
done
sleep 2s
