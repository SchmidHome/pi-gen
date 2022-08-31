https://opensource.com/article/21/7/custom-raspberry-pi-image

# check installation states
- use Linux/WSL with docker installed

# use pi-gen to generate base image
- check "config" file: **(remove all comments!)**
    ```bash
    IMG_NAME=<Name>
    WPA_ESSID=<WIFI SSID>
    WPA_PASSWORD=<WIFI PASSWORD>
    FIRST_USER_PASS=<password>
    PUBKEY_SSH_FIRST_USER="<id-rsa key for first user>" #one key needs to be here, although others can be added later
    FIRST_USER_NAME=pi #name of first user, do not change as it is not configurable everywhere
    TARGET_HOSTNAME=HostnameNotChanged #do not change, the actual name will be set later
    TIMEZONE_DEFAULT="Europe/Berlin"
    DISABLE_FIRST_BOOT_USER_RENAME=1
    WPA_COUNTRY=EU
    ENABLE_SSH=1
    PUBKEY_ONLY_SSH=1
    STAGE_LIST="stage0 stage1 stage2 stage2smarthome"
    ```
- execute ´./build-fresh.sh´

# chage image with manual script
- check for the image file in ´deploy´ folder
- create id_rsa and id_rsa.pub files in ´files/.ssh/´ for the system
- add more authorized keys to ´files/.ssh/authorized_keys´
- execute ´./build-finish.sh deploy/imagename.zip hostname´

# now the image is ready to be flashed to the SD card
- check for the image file in ´deploy/hostimages/´ folder - it should be named by the current date and the hostname
- use balenaEtcher to flash the image to the SD card
