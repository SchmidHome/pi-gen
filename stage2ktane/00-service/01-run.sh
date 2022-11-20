#!/bin/bash -e

# add startup service
install -v files/startup.service	"${ROOTFS_DIR}/lib/systemd/system/"

on_chroot << EOF
systemctl enable startup.service
EOF
