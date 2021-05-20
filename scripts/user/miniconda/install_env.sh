export SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
export ENV_FILE=${SCRIPT_DIR}/envs/$1.yml

if [ -f "${ENV_FILE}" ]; then
    conda env create -f ${ENV_FILE}
else 
    echo "${1} environemnt does not exist."
fi