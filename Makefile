SHELL := /bin/bash -o pipefail -o errexit

# Tempalte settings
VMID := 777
# Targets:
#	asgard - python3.6 + tensorflow 1.last
# 	midgard - python3.7 + tensorflow 2.last
# 	helheim - python3.7 + torch last + torchvision last
TARGET := none
BASE_TEMPLATE="/var/lib/vz/template/cache/ubuntu-20.04-standard_20.04-1-base_amd64.tar.gz"
TEMPLATE := "/var/lib/vz/template/cache/ubuntu-20.04-standard_20.04-1-${TARGET}_amd64.tar.gz"
BASE_REQUIREMENTS := "scripts/base.sh"
TARGET_REQUIREMENTS := "scripts/${TARGET}.sh"
TARGET_INSTALLATION := "scripts/target.sh"
USER_NAME := valkyrja
USER_PASSWORD := ""

# Container settings
UBUNTU_TEMPLATE="local:vztmpl/ubuntu-20.04-standard_20.04-1_amd64.tar.gz"
ARCH := amd64
OS_TYPE := ubuntu
ROOTFS_SIZE := 50
CORES := 4
MEMORY := 4096
SWAP := 4096
NET := "name=eth0,bridge=vmbr1,firewall=1,gw=192.168.10.1,ip=192.168.10.123/24,type=veth"
FEATURES := "keyctl=1,nesting=1"
HOSTNAME := lxc-template-creation
ROOT_PASSWORD := "password"


define create_container
	# ${1} - vmid
	# ${2} - name of the template from which the container is created
	pct create ${1} ${2} \
		--arch ${ARCH} \
		--ostype ${OS_TYPE} \
		--cores ${CORES} \
		--memory ${MEMORY} \
		--swap ${SWAP} \
		--net0 ${NET} \
		--features ${FEATURES} \
		--hostname ${HOSTNAME} \
		--rootfs local-lvm:${ROOTFS_SIZE} \
		--password ${ROOT_PASSWORD} \
		--onboot 1 \
		--unprivileged 1 \
		--start
endef

define create_template
	# ${1} - vmid
	# ${2} - template_name

	# Cleanup before backup
	pct stop ${1}
	pct set ${1} --delete net0

	# Create template
	# TODO: stdout is very slow for large templates. Find way to copy the auto-generated backup
	vzdump ${1} --compress gzip --stdout 1 > ${2}
	pct destroy ${1}
	echo "Template ${2} created"
endef

build-base-template:
	$(call create_container,${VMID},${UBUNTU_TEMPLATE})
	pct push ${VMID} ${BASE_REQUIREMENTS} /root/base_requirements.sh 
	pct exec ${VMID} -- sh /root/base_requirements.sh ${USER_NAME} ${USER_PASSWORD}
	$(call create_template,${VMID},${BASE_TEMPLATE})

build-target-template:
	$(call create_container,${VMID},${BASE_TEMPLATE})
	# Install requirements
	pct push ${VMID} ${TARGET_INSTALLATION} /root/target_installation.sh 
	pct push ${VMID} ${TARGET_REQUIREMENTS} /root/target_requirements.sh 
	pct exec ${VMID} -- sh /root/target_installation.sh ${USER_NAME}
	$(call create_template,${VMID},${TEMPLATE})

create-container:
	$(call create_container,${VMID},${TEMPLATE})
