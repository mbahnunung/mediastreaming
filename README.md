# Rave Party Radio

Community Radio Station for Dance Music DJs.

## Introduction

This project is the source of the [Rave Party Radio](ravepartyradio.org) website and the scripts that run the servers behind it.

## Prerequisites

To run the servers locally all you will need is docker and docker-compose. If you're on a Mac or Windows use 
[Docker Desktop](https://www.docker.com/products/docker-desktop) and it will keep both up to date. If you're on linux
use your package manager.

## The services

The services are defined in the `docker-compose.yml` file, and consist of an icecast server, fed streams by two liquidsoap 
containers, each with its own config file in the `config` directory. There is also a php container, which serves the 
website.

### Configuring the services

Create a `.env` file to store the passwords, assigning values to each of the following environment variables:

```bash
HARBOR_PASSWORD=
ICECAST_SOURCE_PASSWORD=
ICECAST_ADMIN_PASSWORD=
ICECAST_PASSWORD=
ICECAST_RELAY_PASSWORD=
LIVE_PASSWORD=
GUEST_PASSWORD=
LETSENCRYPT_EMAIL=
```

### Starting/stopping the services

In the project foler, to start the services:

```bash
docker-compose up -d
```
The first time you run this it may take a while as it downloads all the required images.

To stop them:

```bash
docker-compose kill
```

To delete the containers:

```bash
docker-compose rm -f
```

You can combine these commands in a handy one liner to restart everything cleanly:

```bash
docker-compose kill && docker-compose rm -f && docker-compose up -d
```

### Website links

Once the services are started, the website should be available at http://localhost

If everything is working the mixes in the `playlists\shows` will start playing when the play button is pressed in the 
player (after a short pause).

If not check the logs in the `logs` directory or use:

```bash
docker-compose logs [container-name]
```