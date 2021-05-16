This repo contains scripts to create various templates for proxmox LXC with pre-installed packages.

## Template targets
Username for all templates - `valkyrja`

Miniconda3 environment name for all templates - `valhalla`
### asgard
* python3.6
    * Pandas, Pillow, opencv, matplotlib, jupyter, jupyterlab, wandb, tensorboard, numpy, tensorflow==1.14.0
* CUDA 10.0, cudnn
## Build template

### Configuration 
* `TARGET` - required variable for `build-target-template`. Based on this variable, a specific set of packages will be installed.
* `ROOT_PASSWROD` - required variable for security purposes.
* Also you can set up container variables (can be found in [Makefile](./Makefile) in `# Container settings` section)

### Building 
#### Build base template
Contains docker, git, nvidia drivers, C++, opencv (for C++), `valkyrja` user with miniconda3. Needed for target tempaltes
```bash
make build-base-template ROOT_PASSWROD=securepassword
```

#### Build target template
```bash
make build-target-template TARGET=asgard ROOT_PASSWROD=securepassword
```
