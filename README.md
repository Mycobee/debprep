# debprep

**Reasonable defaults for Debian and Ubuntu servers**

`debprep` is an Ansible playbook that configures a fresh Debian or Ubuntu server with secure, production-ready defaults. Run it once on a new VPS and you're ready to deploy.

## What it does

- Creates a deploy user with SSH key authentication (configurable name, defaults to `deploy`)
- Disables root SSH login and password authentication
- Installs and configures UFW firewall with sensible defaults
- Sets up Fail2ban for brute-force protection
- Enables automatic security updates (unattended-upgrades)
- Configures log rotation
- Installs Docker (optional)

## Requirements

1. A Debian or Ubuntu server with an IP address
2. Root access via SSH (standard with most cloud providers)
3. Ansible on your local machine

Install Ansible collection dependencies once:

```bash
ansible-galaxy collection install -r requirements.yml
```

## Quick Start

```bash
DEPLOY_USER_PASSWORD=<your_secure_password> \
    ./scripts/bootstrap <your_server_ip> ~/.ssh/id_ed25519
```

Replace `~/.ssh/id_ed25519` with your SSH private key path, choose a secure password, and provide your server's IP.

### Custom deploy user

To use a different username (e.g., `kamal` for Kamal deployments):

```bash
DEPLOY_USER=kamal \
DEPLOY_USER_PASSWORD=<password> \
    ./scripts/bootstrap <your_server_ip> ~/.ssh/id_ed25519
```

## Configuration

Create a `vars.yml` file based on `vars.yml.example` in the repo root — `scripts/configure` picks it up automatically if present.

### Available options

| Variable | Default | Description |
|----------|---------|-------------|
| `deploy_user` | `deploy` | Name of the deploy user to create |
| `apt_packages` | `[]` | Additional apt packages to install |
| `allowed_inbound_tcp_ports` | `[22, 80, 443]` | Inbound TCP ports to allow |
| `allowed_outbound_tcp_ports` | `[80, 443, 587, 465]` | Outbound TCP ports to allow |
| `allowed_inbound_udp_ports` | `[]` | Inbound UDP ports to allow |
| `allowed_outbound_udp_ports` | `[53, 123]` | Outbound UDP ports (DNS, NTP) |
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
