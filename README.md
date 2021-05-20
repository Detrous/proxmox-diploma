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
* ~/scripts/miniconda/env/asgard.sh - install [asgard](#asgard) miniconda environment
    ```bash
    ~/scripts/miniconda/env/asgard.sh
    ```
* ~/scripts/miniconda/env/helheim.sh - install [helheim](#helheim) miniconda environment
    ```bash
    ~/scripts/miniconda/env/helheim.sh
    ```
* ~/scripts/miniconda/env/midgard.sh - install [midgard](#midgard) miniconda environment
    ```bash
    ~/scripts/miniconda/env/midgard.sh
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