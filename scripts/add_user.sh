export USER_NAME=${1}
export USER_PASSWORD=${2}

echo "Creating new user ${USER_NAME}"
useradd -m -p "${USER_PASSWORD}" -s /bin/bash ${USER_NAME}

cp -r ~/scripts/user /home/${USER_NAME}/scripts
chown ${USER_NAME}:${USER_NAME} -R /home/${USER_NAME}/scripts

echo "Installing miniconda3 for ${USER_NAME}"
su ${USER_NAME} -c 'cd && wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && bash ~/Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda && source miniconda/bin/activate && conda init'