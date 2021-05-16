SHELL := /bin/bash -o pipefail -o errexit

# Tempalte settings
VMID := 777
# Targets:
#	loki - python3.6 + tensorflow 1.last
# 	odin - python3.7 + tensorflow 2.last
# 	thor - python3.7 + torch last + torchvision last
TARGET := none
TEMPLATE := "/var/lib/vz/template/cache/ubuntu-20.04-standard_20.04-1-${TARGET}_amd64.tar.gz"
BASE_REQUIREMENTS := "requirements/requirements_base.sh"
TARGET_REQUIREMENTS := "requirements/requirements_${TARGET}.sh"

# Container settings
BASE_TEMPLATE="local:vztmpl/ubuntu-20.04-standard_20.04-1_amd64.tar.gz"
ARCH := amd64
OS_TYPE := ubuntu
ROOTFS_SIZE := 50
CORES := 4
MEMORY := 4096
SWAP := 4096
NET := "name=eth0,bridge=vmbr1,firewall=1,gw=192.168.10.1,ip=192.168.10.123/24,type=veth"
FEATURES := "keyctl=1,nesting=1"
HOSTNAME := lxc-template-creation-${TARGET}


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
		--onboot 1 \
		--unprivileged 1
	pct start ${1}
endef

define create_template
	# ${1} - vmid
	# ${2} - template_name

	# Cleanup before backup
	pct stop ${1}
	pct set ${1} --delete net0

	# Create template
	vzdump ${1} --compress gzip --stdout 1 > ${2}
	pct destroy ${1}
	echo "Template ${2} created"
endef

define install_requirements
	# ${1} - vmid
	# ${2} - path to requirements script

	# Install requirements
	pct push ${1} ${2} /install_requirements.sh
	pct exec ${1} -- sh install_requirements.sh 
	pct exec ${1} -- rm install_requirements.sh
endef

build-template:
	$(call create_container,${VMID},${BASE_TEMPLATE})
	$(call install_requirements,${VMID},${BASE_REQUIREMENTS})
	$(call install_requirements,${VMID},${TARGET_REQUIREMENTS})
	$(call create_template,${VMID},${TEMPLATE})

create-container:
	$(call create_container,${VMID},${TEMPLATE})
