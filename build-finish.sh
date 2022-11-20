#!/bin/bash
set -euo pipefail
trap "echo ''; echo '[ABORT]';sudo umount /mnt/rasp-img 2>/dev/null; exit 2" SIGHUP SIGINT SIGTERM
trap "echo ''; echo '[ERROR]';sudo umount /mnt/rasp-img 2>/dev/null; exit 1" ERR

######################################## arguments
# assert arg1 is valid file
if [ ! -f "$1" ]; then
    echo "ERROR: $1 is not a valid file"
    exit 1
fi

# assert arg2 is hostname and config folder exists
if [ ! -d "./configs/$2" ]; then
    echo "ERROR: $2 is not a valid hostname"
    echo "       ./configs/$2 does not exist"
    exit 1
fi

DELETE_OLD=1
# if argument count is > 2
if [ "$#" -gt 2 ]; then
    # if arg3 is not empty, it must be -r or --reuse
    if [ -n "$3" ] && [ "$3" != "-r" ] && [ "$3" != "--reuse" ]; then
        echo "ERROR: $3 is not a valid argument"
        exit 1
    fi
    # if arg3 is -r or --reuse, set DELETE_OLD to 0
    if [ "$3" == "-r" ] || [ "$3" == "--reuse" ]; then
        DELETE_OLD=0
    fi
fi

######################################## variables
# DATE=$(date +%Y-%m-%d)

IN_ZIP="$1"
IN_BASE="$(basename $IN_ZIP)"
IN_TEMP="${IN_BASE:6}"
IN_IMG=${IN_TEMP/.zip/.img}
IN_NAME=${IN_TEMP/.zip/}

CFG="./configs/$2"

OUT_NAME="$2"
OUT_ZIP="$OUT_NAME-$IN_NAME.zip"
OUT_IMG="$OUT_NAME-$IN_NAME.img"


######################################## programs
# check zip is installed
if ! command -v zip &>/dev/null; then
    echo "[zip ] is not installed, installing..."
    sudo apt-get install -y zip
else
    echo "[zip ] is already installed"
fi

########################################

# if DELETE_OLD is 1, delete old image
if [ "$DELETE_OLD" == 1 ]; then
    echo "[INIT] Deleting old tmp folder"
    rm -rf deploy/tmp
fi

mkdir -p deploy/tmp

######################################## extract IN_ZIP to OUT_IMG
if [ -f "deploy/tmp/$OUT_IMG" ]; then
    echo "[#   ] OUT_IMG already exists"
else
    # check if file tmp/$IN_IMG exists
    if [ -f "deploy/tmp/$IN_IMG" ]; then
        echo "[    ] already extracted IN_ZIP"
    else
        # check if IN_ZIP exists
        if [ -f "$IN_ZIP" ]; then
            echo "[    ] extracting IN_ZIP"
            # extract
            unzip -q "$IN_ZIP" -d deploy/tmp
        else
            echo "[ ER ] Input file $IN_ZIP not found"
            exit 1
        fi
    fi
    echo "[#   ] moving IN_IMG to OUT_IMG"
    mv "deploy/tmp/$IN_IMG" "deploy/tmp/$OUT_IMG"
fi

######################################## edit OUT_IMG
# get volume info
echo "[##  ] editing OUT_IMG"
echo "       getting volume info"
# fat32: boot partition, ext4: root partition
str=$(sudo parted deploy/tmp/$OUT_IMG unit s print | grep ext4)
readarray -t arr < <(grep -E -o '[0-9]+' <<<"$str")
boot_start=${arr[1]}
boot_size=${arr[3]}
# mount boot volume
echo "       mounting boot volume"
sudo mkdir -p /mnt/rasp-img
sudo mount -o loop,offset=$(($boot_start * 512)),sizelimit=$(($boot_size * 512)) deploy/tmp/$OUT_IMG /mnt/rasp-img
# applying changes
echo "       applying changees"

#################### change hostname
sudo sh -c "echo $2 > /mnt/rasp-img/etc/hostname"
sudo sed -i "s/127.0.1.1		.*$/127.0.1.1		$2/g" /mnt/rasp-img/etc/hosts

#################### change keyboard layout
sudo sed -i 's/XKBLAYOUT=".*"/XKBLAYOUT="de"/g' /mnt/rasp-img/etc/default/keyboard

#################### add own and other ssh keys
sudo sed -i '/^#\?UsePAM /s/.*$/UsePAM no/' /mnt/rasp-img/etc/ssh/sshd_config
sudo sed -i '/^#\?HostKey \/etc\/ssh\/ssh_host_rsa_key/s/.*$/HostKey \/home\/pi\/.ssh\/id_rsa/' /mnt/rasp-img/etc/ssh/sshd_config

sudo cp -r $CFG/files/ /mnt/rasp-img/home/pi

sudo chmod 600 /mnt/rasp-img/home/pi/.ssh/id_rsa
sudo chmod 644 /mnt/rasp-img/home/pi/.ssh/id_rsa.pub
sudo chmod 644 /mnt/rasp-img/home/pi/.ssh/authorized_keys
sudo chown -R pi:pi /mnt/rasp-img/home/pi/.ssh

# unmount
echo "       unmounting volume"
sudo umount /mnt/rasp-img

######################################## create ZIP
echo "[### ] creating OUT_ZIP"
mkdir -p deploy/hostimages
cd deploy/tmp
zip -q ../hostimages/$OUT_ZIP $OUT_IMG
cd ../..

######################################## DONE
echo "[####] DONE"
echo "$OUT_ZIP created"
