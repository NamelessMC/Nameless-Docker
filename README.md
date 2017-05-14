# NamelessMC Docker [![](https://images.microbadger.com/badges/image/birkhofflee/namelessmc-docker.svg)](https://microbadger.com/images/birkhofflee/namelessmc-docker)
This is the official Docker image for NamelessMC. Deploy with ease!

# Usage

## # Install Docker
Obviously, if you wanna use Docker for deployment, you need to install Docker.

You have to manually install Docker first if you don't have it installed on your server. Check out the official install guide here: https://docs.docker.com/engine/installation.

If you want to specify the version of NamelessMC you want, head to https://github.com/NamelessMC/Nameless-Docker#manually-run-commands.

## # Automated Deployment
You will need to install [Docker Compose](https://docs.docker.com/compose/) for automated deploying. If you don't have it installed, run the following:

```bash
$ curl -L "https://github.com/docker/compose/releases/download/1.11.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
$ chmod +x /usr/local/bin/docker-compose
```

> If you got a “Permission denied” error while running the commands above, add `sudo` at the beginning of each of them and run again. This will require sudo access.

When you're done, clone this repository and run! (`-d` means detach mode, e.g. run in background)

```bash
$ git clone https://github.com/NamelessMC/Nameless-Docker
$ cd NamelessMC-docker
$ docker-compose up -d
```

When the container is up, follow the guide at https://github.com/NamelessMC/Nameless-Docker#namelessmc-installation.

## # Manual Deployment
If you more like to run the containers by yourself or using them with other containers like [jwilder/nginx-proxy](https://github.com/jwilder/nginx-proxy), you may want to do it yourself.

First, clone the repository:

```bash
$ git clone https://github.com/NamelessMC/Nameless-Docker
$ cd Nameless-Docker
```

Next, build the image.

```bash
$ docker build -t namelessmc .
```

If you want to specify the version:

```bash
$ docker build --build-arg NAMELESSMC_VERSION=1.0.16 -t namelessmc .
```

The version number **MUST BE** listed [here](https://github.com/NamelessMC/Nameless/releases) and it's **not guranteed** to work.

Next, run the image we just built and a MySQL container as well.

```bash
$ docker run -d -e "MYSQL_ROOT_PASSWORD=nameless" -e "MYSQL_USER=nameless" -e "MYSQL_PASSWORD=nameless" -e "MYSQL_DATABASE=nameless" --name nameless_db mysql
$ docker run -d -p 80:80 --link nameless_db --name nameless namelessmc
```

That's it!

# Installation
After deploying the containers, open up the corresponding URL in your web browser to get started with NamelessMC.

By default, the web server will be available at `0.0.0.0:80`, means if you deployed it on you own computer, the URL is gonna be `http://localhost`. Instead, if you did it on a remote server, the URL would be `http://<your-server-ip-addr>`.

Follow the install instructions. When the database configuration page shows up, fill in `nameless_db` for the *database address*. For database username, password and database name, fill `nameless` for all of them, if you used default database credentials.

When you're done, submit and follow the rest of installation.

# About
This repository was moved from [Birkhoff Lee](https://github.com/BirkhoffLee), and the original repository is here: https://github.com/BirkhoffLee/namelessmc-docker, carefully made in Taiwan. :heart:
