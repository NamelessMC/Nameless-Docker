# NamelessMC Docker

This is the official Docker image for NamelessMC. Deploy with ease!

## Usage

### Install Docker

You have to manually install Docker first if you don't have it installed on your server. Check out the [official install guide](https://docs.docker.com/engine/installation).

### Automated Deployment

You will need to install [Docker Compose](https://docs.docker.com/compose/) for automated deployment.

For Debian/Ubuntu:
```bash
sudo apt install docker-compose-plugin
```

Download the [latest docker-compose.yml](https://github.com/NamelessMC/Nameless-Docker/blob/master/docker-compose.yaml) or [experimental development docker-compose.yml](https://github.com/NamelessMC/Nameless-Docker/blob/dev/docker-compose.yaml), optionally change some settings like setting `user` to your user (otherwise it will run as `www-data`). Uncomment `restart: always` to have the containers start on system boot.

Create a directory on the host with correct permissions. By default the containers use `www-data` user id 33, so:
```
mkdir web
chown 33:33 web
```

Then run `docker compose up -d`.

When the containers are up, visit the website in a browser to start the installer. By default it listens on any interface, port 80.

When the database configuration page shows up, fill in `db` for *database address*. For database username, password and database name, fill `nameless` for all of them, if you used default database credentials.

## Troubleshooting
Check container logs using `docker compose logs`.

## Development

If you want to use Docker for developing NamelessMC, please see the [docker compose file in the main repository](https://github.com/NamelessMC/Nameless/blob/v2/docker-compose.yaml).

## Updating
First, follow regular update instructions on the website (uploading files etc). After the upgrade is complete and your website is back up, change the image tag to the new version (e.g. change from `v2.0` to `v2.1`) to get the newest PHP library versions.

## Available tags

### Supported tags
| Tag | NamelessMC version | PHP version | Receives updates\* | Notes
| --- | ------------------ | ----------- | ---------------- | -----
v2.1 | Latest v2.1.x release (currently 2.1.2) | 8.2 | Yes | Recommended tag
v2.1.2 | v2.1.2 | 8.2 | Yes
dev | v2 development | 8.2 | Yes | For development only. Downloads latest source code and includes composer and npm.

### Legacy tags

| Tag | NamelessMC version | PHP version | Receives updates\* | Notes
| --- | ------------------ | ----------- | ---------------- | -----
v2-pr7 | v2.0.0-pr7 | 7.4 | No |
v2-pr8 | v2.0.0-pr8 | 7.4 | No |
v2-pr9 | v2.0.0-pr9 | 7.4 | No |
v2-pr9-php8 | v2.0.0-pr9 | 8.0 | No | Experimental
v2-pr10 | v2.0.0-pr10 | 8.0 | No | Use PHP 7.4 for compatibility
v2-pr10-php74 | v2.0.0-pr10 | 7.4 | No |
v2-pr11 | v2.0.0-pr11 | 8.0 | No |
v2-pr11-php74 | v2.0.0-pr11 | 7.4 | No | For compatibility with legacy modules
v2-pr12 | v2.0.0-pr12 | 8.0 | No |
v2-pr12-php74 | v2.0.0-pr12 | 7.4 | No | For compatibility with legacy modules
v2-pr13 | v2.0.0-pr13 | 8.2 (8.1 before 2022-12-12) | Yes |
v2.0.0 | v2.0.0 | 8.2 (8.1 before 2022-12-12) | Yes |
v2.0.1 | v2.0.1 | 8.2 (8.1 before 2022-12-12)  | Yes |
v2.0.2 | v2.0.2 | 8.2 (8.1 before 2022-12-12) | Yes |
v2.0 | Latest v2.0.x release (currently 2.0.3) | 8.2 (8.1 before 2022-12-12) | Yes |
v2.0.3 | v2.0.3 | 8.2 | Yes |
v2.1.0 | v2.1.0 | 8.2 | Yes |
v2.1.1 | v2.1.1 | 8.2 | Yes |
dev-php8 | v2 development | 8.0 | No | Use `:dev` instead, it now uses PHP 8

\* Image updates, not NamelessMC updates. Only the latest NamelessMC version is supported.
