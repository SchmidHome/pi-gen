rm -f ./stage0/SKIP ./stage1/SKIP ./stage2/SKIP
rm -f ./stage2/SKIP_IMAGES

sudo docker rm -v pigen_work

PRESERVE_CONTAINER=1 ./build-docker.sh
