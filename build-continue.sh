SECONDS=0

touch ./stage0/SKIP ./stage1/SKIP ./stage2/SKIP
touch ./stage2/SKIP_IMAGES

PRESERVE_CONTAINER=1 CONTINUE=1 ./build-docker.sh

echo "$SECONDS seconds elapsed"
