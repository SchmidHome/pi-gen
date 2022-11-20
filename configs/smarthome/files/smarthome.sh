set -euo pipefail

######################################## docker
if ! command -v docker &>/dev/null; then
    echo "[Docker] is not installed, installing..."
    trap "echo '[Docker] failed to install'; exit 1" ERR

    sudo apt-get update
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    rm get-docker.sh
    sudo usermod -aG docker pi
    echo "[Docker] is installed"
else
    echo "[Docker] is already installed"
fi

######################################## docker-compose
# if ! command -v docker-compose &>/dev/null; then
#     echo "[Docker Compose] is not installed, installing..."
#     trap "echo '[Docker Compose] failed to install'; exit 1" ERR

#     # install new rust
#     curl -fsSL https://sh.rustup.rs -o rustup.sh
#     sudo sh rustup.sh -y
#     rm rustup.sh
#     # install packages
#     sudo apt-get update
#     sudo apt-get install -y libffi-dev libssl-dev python3-dev python3 python3-pip
#     # install docker-compose
#     pip3 install docker-compose
#     systemctl enable docker
#     echo "[Docker Compose] is installed"
# else
#     echo "[Docker Compose] is already installed"
# fi

######################################## home assistant
# check if docker homeassistant is running
# if ! docker ps | grep homeassistant &>/dev/null; then
#     echo "[Home Assistant] is not running, starting..."
#     trap "echo '[Home Assistant] failed to start'; exit 1" ERR

#     #todo load config and backup
#     mkdir -p /home/pi/homeassistant

#     # https://www.home-assistant.io/installation/raspberrypi
#     docker run -d \
#         --name homeassistant \
#         --privileged \
#         --restart=unless-stopped \
#         -e TZ=Europe/Berlin \
#         -v /home/pi/homeassistant:/config \
#         --network=host \
#         ghcr.io/home-assistant/home-assistant:stable

#     echo "[Home Assistant] installing HACS..."
#     trap "echo '[Home Assistant] failed to install HACS'; exit 1" ERR
#     sleep 5
#     docker exec -it homeassistant bash -c "wget -q -O - https://install.hacs.xyz | bash -"
#     docker restart homeassistant

#     echo "[Home Assistant] is running"
# else
#     echo "[Home Assistant] is already running"
# fi
