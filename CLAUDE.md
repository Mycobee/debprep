# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

debprep is a tool for configuring Debian/Ubuntu servers with secure, production-ready defaults. It runs Ansible playbooks via Docker to set up servers with:
- A deploy user with passwordless SSH
- Fail2ban for intrusion protection
- UFW firewall with configurable rules
- Automatic security updates
- Log rotation
- Docker (optional)

## Commands

Build and run the Docker image:
```bash
docker build -t debprep/debprep:latest .
docker run -v <ssh_key_path>:/root/.ssh/privkey:ro \
    -e DEPLOY_USER_PASSWORD=<password> \
    -e DEPLOY_USER=deploy \
    -it debprep/debprep:latest \
    /debprep/scripts/bootstrap <server_ip>
```

Run individual scripts (from inside container or with ansible installed):
```bash
./scripts/init <server_ip> <ssh_key_path>   # Initial server setup as root
./scripts/configure                          # Configure packages/security as deploy user
./scripts/bootstrap <server_ip>              # Run both init and configure
```

Run Ansible playbooks directly:
```bash
ansible-playbook -i inventory.ini ansible/playbooks/init.yml -e ansible_user=root -e deploy_user=deploy
ansible-playbook -i inventory.ini ansible/playbooks/configure.yml --extra-vars "ansible_become_password=${DEPLOY_USER_PASSWORD}" --extra-vars "deploy_user=deploy"
```

## Architecture

```
debprep/
├── scripts/
│   ├── bootstrap              # Main entry point: runs init then configure
│   ├── init                   # Generates inventory, runs init playbook as root
│   ├── configure              # Runs configure playbook as deploy user
│   └── inventory_template.ini # Template for dynamic inventory generation
├── ansible/
│   ├── playbooks/
│   │   ├── init.yml           # Creates deploy user, configures SSH
│   │   └── configure.yml      # Installs packages, security, firewall, Docker
│   └── roles/
│       ├── init/tasks/
│       │   ├── deploy_user.yml  # Create deploy user with sudo
│       │   └── ssh.yml          # SSH hardening (disable root, passwords)
│       └── configure/tasks/
│           ├── security.yml     # Fail2ban, unattended upgrades, logrotate
│           ├── firewall.yml     # UFW rules
│           ├── apt_packages.yml # Package installation
│           └── docker.yml       # Docker installation
├── vars.yml.example           # Override defaults (mount at /debprep/vars.yml)
├── Dockerfile                 # Debian-based container with Ansible
└── TODO.md                    # Project roadmap (not checked in)
```

## Key Variables

- `DEPLOY_USER` - Environment variable, name of deploy user (default: `deploy`)
- `DEPLOY_USER_PASSWORD` - Environment variable, password for the deploy user
- `deploy_user` - Ansible variable, same as above but used in playbooks

## Configuration

Override defaults by mounting a `vars.yml` file (see `vars.yml.example`):
- `deploy_user` - Name of the deploy user to create
- `apt_packages` - Additional apt packages to install
- `allowed_inbound_tcp_ports`, `allowed_outbound_tcp_ports` - Firewall TCP rules
- `allowed_inbound_udp_ports`, `allowed_outbound_udp_ports` - Firewall UDP rules
- `skip_ufw_config` - Skip firewall setup entirely
- `install_docker` - Set to false to skip Docker installation
