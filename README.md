This repo contains scripts to create various templates for proxmox LXC with pre-installed packages.

## Template targets
Username for all templates - `valkyrja`

Miniconda environment name for all templates - `base`. Active by default
## Build template

### Configuration 
* `TARGET` - required variable. Based on this variable, a specific set of packages will be installed.
* `ROOT_PASSWROD` - required variable for security purposes.
* Also you can set up container variables (can be found in [Makefile](./Makefile) in `# Container settings` section)

### Building 
```bash
make build-template TARGET=loki|odin|thor ROOT_PASSWROD=securepassword
```
