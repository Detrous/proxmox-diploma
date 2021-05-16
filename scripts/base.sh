export USER_NAME=${1}
export USER_PASSWORD=${2}

apt update
locale-gen "en_US.UTF-8"

echo "Creating new user ${USER_NAME}"
useradd -m -p "${USER_PASSWORD}" -s /bin/bash ${USER_NAME}

echo "Installing docker, git, nvidia drivers, C++"
apt install -y apt-transport-https ca-certificates curl software-properties-common git nvidia-driver-460 g++ libopencv-dev
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
apt install -y docker-ce
systemctl enable docker
usermod -aG docker ${USER_NAME}

echo "Installing miniconda3 for ${USER_NAME}"
su ${USER_NAME} -c 'cd && wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && bash ~/Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda && source miniconda/bin/activate && conda init'

apt clean
