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

touch ./stage0/SKIP ./stage1/SKIP ./stage2/SKIP
touch ./stage2/SKIP_IMAGES

PRESERVE_CONTAINER=1 CONTINUE=1 ./build-docker.sh

echo "$SECONDS seconds elapsed"
