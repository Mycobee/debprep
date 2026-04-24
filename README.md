# debprep

**Reasonable defaults for Debian and Ubuntu servers**

`debprep` is an Ansible playbook that configures a fresh Debian or Ubuntu server with secure, production-ready defaults. Run it once on a new VPS and you're ready to deploy.

## What it does

- Creates a deploy user with SSH key authentication (configurable name, defaults to `deploy`)
- Disables root SSH login and password authentication
- Installs UFW firewall with default-deny inbound (allows 80/443) and rate-limits SSH
- Sets up Fail2ban for brute-force protection
- Enables automatic security updates with auto-reboot when required
- Installs Docker (optional)

## Requirements

1. A Debian 12+ or Ubuntu server with an IP address
2. SSH access to root (standard with most cloud providers — whatever lets you `ssh root@<ip>` works)
3. Ansible on your local machine

Install Ansible collection dependencies once:

```bash
ansible-galaxy collection install -r requirements.yml
```

## Quick Start

```bash
./debprep <your_server_ip>
```

That's it. Uses your default SSH configuration (`~/.ssh/config`, ssh-agent) — if `ssh root@<ip>` works, so does this.

A 32-character password is generated for the new deploy user and printed at the end. Save it somewhere secure.

### Custom deploy user

To use a different username (e.g., `kamal` for Kamal deployments):

```bash
DEPLOY_USER=kamal ./debprep <your_server_ip>
```

### Supply your own deploy user password

```bash
DEPLOY_USER_PASSWORD=<secure_password> ./debprep <your_server_ip>
```

## Configuration

Extra args pass through to `ansible-playbook`. To override defaults, copy `vars.yml.example` and pass it with `-e`:

```bash
./debprep <your_server_ip> -e @vars.yml
```

### Available options

| Variable | Default | Description |
|----------|---------|-------------|
| `deploy_user` | `deploy` | Name of the deploy user to create |
| `apt_packages` | `[]` | Additional apt packages to install |
| `ssh_port` | `22` | SSH port (rate-limited in UFW) |
| `allowed_inbound_tcp_ports` | `[80, 443]` | Inbound TCP ports to allow |
| `allowed_inbound_udp_ports` | `[]` | Inbound UDP ports to allow |
| `skip_ufw_config` | `false` | Skip firewall configuration |
| `install_docker` | `true` | Install Docker and add deploy user to docker group |

## After setup

SSH into your server with your deploy user:

```bash
ssh deploy@<your_server_ip>
```

If using with Kamal, set in your `deploy.yml`:

```yaml
ssh:
  user: deploy  # or whatever you set DEPLOY_USER to
```

## Disclaimer

This project configures servers with security in mind, but your servers are **your** responsibility. Review the playbooks before running on production systems.

## Contributing

Open an issue before contributing to discuss whether your feature aligns with the project's goals.

## License

GPL-3.0 — see [LICENSE](LICENSE).
