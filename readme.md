Here's the English translation of the provided text:

# OpenSIPS Load Balancer (SIP) - Dockerized

This project sets up a **SIP load balancer** with [OpenSIPS](https://www.opensips.org/) in a **Docker** environment. It is designed to balance SIP call (INVITE) loads across multiple backend SIP servers, while enabling centralized monitoring and management via a MySQL database.

---

## 🧱 Architecture

- `opensips`: SIP server based on OpenSIPS with load balancing configuration
- `mysql`: Database for OpenSIPS modules (`dialog`, `load_balancer`, etc.)
- `phpmyadmin`: Web interface for managing MySQL (optional, for debugging)
- `sipserver`: SIP server to which OpenSIPS distributes calls

---

## ⚙️ Features

- SIP load balancing via the `load_balancer` module
- Session persistence and tracking via `dialog`
- Monitoring via `opensips-cli` and HTTP MI interface
- Automated startup with database initialization

---

## 📁 Project Structure

```
.
├── docker-compose.yml
├── .env
├── opensips_config/
│   ├── opensips.cfg       # OpenSIPS configuration file
│   └── startup.sh         # Startup script (init DB + launch)
├── docker_entrypoint_mysql
│   ├── init-opensips-user.sql # SQL script executed on first MySQL startup
├── db_data/               # Persistent MySQL data
├── sip_servers_scripts/
│   ├── sip_server_startup.sh      # Startup script for each SIP server
│   └── insert_in_load_balancer.sql # SQL script to insert a server into the load_balancer table

```

---

## 🚀 Quick Start

### 1. Build the image and start the containers

```bash
docker build -t custom-opensips .
```

```bash
docker compose up
```

### 2. Access phpMyAdmin (optional)

- http://localhost:8080
- User: `opensips`
- Password: `opensipsrw`

---

## 📦 Configuration

### Test variables in `.env`

```ini
MYSQL_ROOT_PASSWORD=root
MYSQL_DATABASE=opensips
MYSQL_USER=opensips
MYSQL_PASSWORD=opensipsrw

SIP_DISTANT_SERVER_URI=distant-domain.net
KEYYO_PHONE_NUMBER=331XXXXXXXX
KEYYO_SIP_PASSWORD=password
OPENSIPS_PUBLIC_IP=X.X.X.X
```

### `startup.sh`

This script:
- Waits for MySQL to be ready
- Initializes the database if needed (`opensips-cli -x database create`)
- Adds the distant registrar to the database if it's not present
- Starts OpenSIPS in foreground mode

---

### `sip_server_startup.sh`

This script should be executed at the startup of each SIP server to which OpenSIPS needs to distribute calls.
Here are the steps it performs:
- Registers the server in the OpenSIPS database
- Reloads the OpenSIPS configuration to take the new server into account

## 📚 Useful Resources

- [OpenSIPS documentation](https://opensips.org/Resources/DocsCookbooks)
- [Load Balancer Module](https://opensips.org/html/docs/modules/3.4.x/load_balancer.html)
- [opensips-cli GitHub](https://github.com/OpenSIPS/opensips-cli)

---