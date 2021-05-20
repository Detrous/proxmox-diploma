apt update
locale-gen "en_US.UTF-8"

echo "Installing docker, git, nvidia drivers, C++"
apt install -y apt-transport-https ca-certificates curl software-properties-common git nvidia-driver-460 g++ libopencv-dev gpustat
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
apt install -y docker-ce
systemctl enable docker

apt clean

rm ~/requirements.sh