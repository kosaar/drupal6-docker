# Dockerized Drupal 6 Project

This project provides a Docker setup for running a Drupal 6 website using Debian 11, PHP 5.6, and MySQL 5.7.

## Prerequisites

- Docker
- Docker Compose

## Project Structure

```
drupal6-docker/
├── Dockerfile           # PHP-Apache container configuration
├── docker-compose.yml   # Docker services configuration
├── php.ini             # PHP configuration
├── drupal.conf         # Apache virtual host configuration
├── .env                # Environment variables
└── README.md           # This file
```

## Quick Start

1. Clone this repository
2. Configure your environment variables in `.env` file
3. **Generate SSL Certificates:**
   For local development, a script is provided to generate self-signed certificates. Run the following command from the root of the project:
   ```bash
   ./certs/gen_certs.sh
   ```
   This will create `cert.pem` and `key.pem` in the `certs` directory.
4. Build and start the containers:
   ```bash
   docker-compose up -d
   ```
5. Access Drupal installation at https://localhost

## Configuration

### HTTPS / SSL

This setup uses an Nginx reverse proxy to handle HTTPS. By default, it uses self-signed certificates which are suitable for local development.

- **Using Self-Signed Certificates:** The `gen_certs.sh` script in the `certs` directory can be used to generate self-signed certificates. These are not trusted by browsers, so you will see a warning.
- **Using Custom Certificates:** For production, you should use valid SSL certificates. To do so, replace the `cert.pem` and `key.pem` files in the `certs` directory with your own certificate and private key. Then, restart the Nginx container: `docker-compose restart nginx`.


### Database Settings
- Host: mysql
- Database: drupal6
- Username: drupal
- Password: drupal_password

### Environment Variables
Edit the `.env` file to modify:
- `DRUPAL_BASE_URL`: The base URL of the Drupal site, e.g., `https://example.com`. Defaults to `https://localhost`.
- Database credentials
- PHP settings
- Other environment-specific configurations

## Maintenance

### Backup Database
```bash
docker-compose exec mysql mysqldump -u root -p drupal6 > backup.sql
```

### Restore Database
```bash
docker-compose exec -T mysql mysql -u root -p drupal6 < backup.sql
```

## Troubleshooting

1. Check container logs:
   ```bash
   docker-compose logs
   ```

2. Access container shell:
   ```bash
   docker-compose exec drupal bash
   ```

## Security Notes

- Change all default passwords in production
- Regularly update base images and dependencies
- Follow Drupal security best practices
