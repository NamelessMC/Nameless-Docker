# NamelessMC Docker

This is the official Docker image for NamelessMC. Deploy with ease!

## Usage

### Install Docker

You have to manually install Docker first if you don't have it installed on your server. Check out the [official install guide](https://docs.docker.com/engine/installation).

### Automated Deployment

You will need to install [Docker Compose](https://docs.docker.com/compose/) for automated deploying.

```bash
sudo apt install docker-compose
```

Download [docker-compose.yml](https://github.com/NamelessMC/Nameless-Docker/raw/master/docker-compose.yml), optionally change some settings, then run `docker-compose up -d`. The default restart policy is `always` so your website will start back up after a reboot.

When the containers are up, visit the website in a browser to start the installer. By default it listens on any interface, port 80.

When the database configuration page shows up, fill in `db` for *database address*. For database username, password and database name, fill `nameless` for all of them, if you used default database credentials.


## Development

If you want to use Docker for developing NamelessMC, please see the [docker compose file in the main repo](https://github.com/NamelessMC/Nameless/blob/v2/docker-compose.yaml).

## Available tags
| Tag | NamelessMC version | PHP version
| --- | ------------------ | -----------
pr7 | v2.0.0-pr7 | 7.4
pr8 | v2.0.0-pr8 | 7.4
pr9dev | v2 development (unstable) | 7.4
pr9dev-php8 | v2 development (unstable) | 8.0
