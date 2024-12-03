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
3. Build and start the containers:
   ```bash
   docker-compose up -d
   ```
4. Access Drupal installation at http://localhost

## Configuration

### Database Settings
- Host: mysql
- Database: drupal6
- Username: drupal
- Password: drupal_password

### Environment Variables
Edit the `.env` file to modify:
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
