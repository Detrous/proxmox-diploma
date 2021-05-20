SHELL := /bin/bash -o pipefail -o errexit

# Container settings
ARCH := amd64
OS_TYPE := ubuntu
ROOTFS_SIZE := 50
CORES := 4
MEMORY := 4096
SWAP := 4096
NET := "name=eth0,bridge=vmbr1,firewall=1,gw=192.168.10.1,ip=192.168.10.123/24,type=veth"
HOSTNAME := lxc-template-creation
ROOT_PASSWORD := "password"
ZFS_POOL := fpool
HOME_VOLUME_SIZE=100G
HOME_VOLUME_NAME=valhalla_home
ADDITIONAL_CONFIG := "lxc/container.conf"

# Tempalte settings
VMID := 777
TEMPLATES_FOLDER := /var/lib/vz/template/cache
BASE_TEMPLATE := "${OS_TYPE}-20.04-standard_20.04-1_${ARCH}.tar.gz"
TEMPLATE := "${OS_TYPE}-20.04-standard_20.04-1-valhalla_${ARCH}.tar.gz"
TEMPLATE_REQUIREMENTS := "lxc/requirements.sh"
SCRIPTS_FOLDER := "scripts"

define create_template
	# "${1}" - vmid
	# "${2}" - template_name

	# Cleanup before backup
	pct stop ${1}
	pct set ${1} --delete net0

	# Create template
	# TODO: stdout is very slow for large templates. Find way to copy the auto-generated backup
	vzdump ${1} --compress gzip --stdout 1 > ${TEMPLATES_FOLDER}/${2}
	pct destroy ${1}
	echo "Template ${2} created"
endef

build-template:
	pct create ${VMID} ${TEMPLATES_FOLDER}/${BASE_TEMPLATE} \
		--arch ${ARCH} \
		--ostype ${OS_TYPE} \
		--cores ${CORES} \
		--memory ${MEMORY} \
		--swap ${SWAP} \
		--net0 ${NET} \
		--hostname ${HOSTNAME} \
		--rootfs local-lvm:${ROOTFS_SIZE} \
		--password ${ROOT_PASSWORD} \
		--onboot 1 \
		--unprivileged 1 \
		--start
	find scripts -type d -exec pct exec ${VMID} mkdir /root/{} \;
	find scripts -type f -exec pct push ${VMID} {} /root/{} \;
	pct exec ${VMID} -- find /root/scripts -type f -exec chmod +x {} \;
	pct push ${VMID} ${TEMPLATE_REQUIREMENTS} /root/requirements.sh 
	pct exec ${VMID} -- sh /root/requirements.sh
	$(call create_template,${VMID},${TEMPLATE})

create-container: VMID=333
create-container: HOSTNAME=valhalla
create-container: NET="name=eth0,bridge=vmbr1,firewall=1,gw=192.168.10.1,ip=dhcp,type=veth"
create-container:
	if [ -f "/etc/pve/lxc/${VMID}.conf" ]; then \
		read -p "Container with vmid ${VMID} already exists. Delete it ? (y/n): " -n 1 -r; \
		echo; \
		if [[ $${REPLY} =~ ^[Yy]$$ ]]; then \
			pct destroy ${VMID} --force; \
		else \
			exit 1; \
		fi; \
	fi

	if [ ! -d "/${ZFS_POOL}/${HOME_VOLUME_NAME}" ]; then \
		zfs create -o quota=${HOME_VOLUME_SIZE} -o compression=on ${ZFS_POOL}/${HOME_VOLUME_NAME}; \
		mkdir /${ZFS_POOL}/${HOME_VOLUME_NAME}/home; \
		chown 100000:100000 /${ZFS_POOL}/${HOME_VOLUME_NAME}/home; \
		pvesm add zfspool ${HOME_VOLUME_NAME} -pool ${ZFS_POOL}/${HOME_VOLUME_NAME}; \
	fi 
	pct create ${VMID} ${TEMPLATES_FOLDER}/${TEMPLATE} \
		--arch ${ARCH} \
		--ostype ${OS_TYPE} \
		--cores ${CORES} \
		--memory ${MEMORY} \
		--swap ${SWAP} \
		--net0 ${NET} \
		--hostname ${HOSTNAME} \
		--rootfs local-lvm:${ROOTFS_SIZE} \
		--password ${ROOT_PASSWORD} \
		--onboot 1 \
		--unprivileged 1 \
		--mp0 /${ZFS_POOL}/${HOME_VOLUME_NAME}/home,mp=/home
	cat ${ADDITIONAL_CONFIG} >> /etc/pve/lxc/${VMID}.conf
	pct start ${VMID}