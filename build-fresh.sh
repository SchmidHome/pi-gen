######################################## arguments
# assert arg1 is hostname and config folder exists
config="./configs/$1"
if [ -z "$1" ] || [ ! -d "$config" ]; then
    echo "ERROR: $1 is not a valid hostname"
    echo "       ./configs/$1 does not exist"
    exit 1
fi

cp $config/config config

SECONDS=0

rm -f ./stage0/SKIP ./stage1/SKIP ./stage2/SKIP
rm -f ./stage2/SKIP_IMAGES

sudo docker rm -v pigen_work

PRESERVE_CONTAINER=1 ./build-docker.sh

echo "$SECONDS seconds elapsed"
