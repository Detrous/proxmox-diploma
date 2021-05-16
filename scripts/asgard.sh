export ENV_NAME="valhalla"

echo "Creating python3.6 environment"
. ~/miniconda/bin/activate
conda create -y -n ${ENV_NAME} python=3.6 anaconda
conda activate ${ENV_NAME}
conda install -c anaconda -y cudatoolkit=10.0 cudnn
conda install -c conda-forge -y pandas pillow opencv matplotlib jupyter jupyterlab wandb tensorboard numpy tensorflow-gpu==1.14.0