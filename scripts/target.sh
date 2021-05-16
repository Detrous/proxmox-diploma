export USER_NAME=${1}

echo "Installing target requirements"
cp /root/target_requirements.sh /home/${USER_NAME}/target_requirements.sh
chown ${USER_NAME}:${USER_NAME} /home/${USER_NAME}/target_requirements.sh
su ${USER_NAME} -c 'sh ~/target_requirements.sh'