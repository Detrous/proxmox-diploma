This repo contains scripts to create and manage proxmox LXC container for using neural networks.

# Template
Contains docker, git, nvidia drivers, C++, opencv (for C++), contains scripts to make life easier.
## Configuration 
* `ROOT_PASSWROD` - required variable for security purposes.
* Also you can set up container variables (can be found in [Makefile](./Makefile) in `# Container settings` section)

## Building 
### Build template
```bash
make build-template ROOT_PASSWROD=securepassword
```
## Template content
Root user in home directory has the following scripts:
### ~/scripts/add_user.sh
Creates new user with the specified password, installs miniconda and adds scripts to the user's home directory(for miniconda environment installation)
```bash
~/scripts/add_user.sh "username" "password"
```
### User scripts
* ~/scripts/miniconda/env/install_env.sh <env_name> - install selected miniconda environment
    ```bash
    ~/scripts/miniconda/install_env.sh asgard

    ~/scripts/miniconda/install_env.sh helheim

    ~/scripts/miniconda/install_env.sh midgard
    ```

# Miniconda environments
## asgard
* python3.6
    * Pandas, Pillow, opencv, matplotlib, jupyter, jupyterlab, wandb, tensorboard, numpy, tensorflow==1.14.0
* CUDA 10.0, cudnn

## helheim
TBD;
## midgard
TBD;