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
