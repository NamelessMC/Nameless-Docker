# NamelessMC Docker

This is the official Docker image for NamelessMC. Deploy with ease!

## Usage

### Install Docker

You have to manually install Docker first if you don't have it installed on your server. Check out the [official install guide](https://docs.docker.com/engine/installation).

### Automated Deployment

You will need to install [Docker Compose](https://docs.docker.com/compose/) for automated deploying.

```shell
$ apt install docker-compose # debian
```

Download the example file, optionally change the directories, passwords, etc. then run it

```shell
$ git clone https://github.com/NamelessMC/Nameless-Docker.git
$ cd Nameless-Docker
$ vim docker-compose.dev.yaml
$ docker-compose up -d
```

When the containers are up, visit the website in a browser to start the installer. By default it listens on any interface, port 80.

When the database configuration page shows up, fill in `db` for the *database address*. For database username, password and database name, fill `nameless` for all of them, if you used default database credentials.
