#!/bin/bash -e

# add smarthome service
install -v files/smarthome.service	"${ROOTFS_DIR}/lib/systemd/system/"

on_chroot << EOF
systemctl enable smarthome.service
EOF
