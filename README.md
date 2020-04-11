# Description

[Traefik](https://docs.traefik.io/) is a modern HTTP reverse proxy and load balancer that makes deploying microservices easy. Traefik integrates with with multiples infrastructure components (Docker, Kubernetes, ...) and configures itself automatically and dynamically. 

This project focuses on the steps needed to setup a local Traefik environment.

## Instructions

**Note:** This guide asumes that you already have [Docker](https://docs.docker.com/engine/install/) and [Docker Compose](https://docs.docker.com/compose/install/) installed on your system.

1. Add all the domains you need to your `/etc/hosts` file.
    ```bash
    127.0.0.1   localhost.traefik.com
    127.0.0.1   localhost.site.com
    ```
2. Create an external Docker network, it will be used to connect traefik to other services. 

    ```bash
    docker network create docker_default
    ```

3. Clone this repository

    ```bash
    git clone https://github.com/ealcantara22/traefik.git
    cd traefik
    ```

4. Copy the `.env.sample` file as `.env` and fill it with the information you used in steps 1 and 2.
    
    ```bash
    cp .env.sample .env
    ```

5. Start traefik and verify that [`http://localhost.traefik.com/dashboard/`](https://traefik.test/dashboard/) works. **The final `/` is mandatory**.

    ```bash
    docker-compose up -d
    ```

## To-do

- [ ] Documentation for generate, add and configure a SSL Certificate.
- [ ] Documentation on how to test this project configuration.