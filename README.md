# Description

[Traefik](https://docs.traefik.io/) is a modern HTTP reverse proxy and load balancer that makes deploying microservices easy. Traefik integrates with with multiples infrastructure components (Docker, Kubernetes, ...) and configures itself automatically and dynamically. 

This project focuses on the steps needed to setup a local Traefik environment.


**Note:** This guide asumes that you already have [Docker](https://docs.docker.com/engine/install/) and [Docker Compose](https://docs.docker.com/compose/install/) installed on your system.

## Getting and running traefik

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

5. Start traefik and verify that [`http://localhost.traefik.com/dashboard/`](https://localhost.traefik.com/dashboard/) works. **The final `/` is mandatory**.

    ```bash
    docker-compose up -d
    ```

## Generating an SSL certificate
I like to run all my apps locally using `HTTPS` for multiple reasons, and the easiest way for me to accomplish that is supporting all the apps and services domain that I need in a single certificate by using a [`Multi-Domain (SAN) Certificate`](https://www.digicert.com/subject-alternative-name.htm).

1. Edit the `openssl.conf`.
    
    1.1. Replace the `distinguished name (dn)` section with your informacion. You can read more about these values [`here`](https://www.ibm.com/support/knowledgecenter/en/SSFKSJ_7.5.0/com.ibm.mq.sec.doc/q009860_.htm).

    ```conf
    [dn]
    C=Country
    ST=State or Province name
    L=Locality name
    CN=Common Name
    O=Organization name
    OU=Organizational Unit name
    emailAddress=Email address
    ```

    1.2. Add all the domain names you need in the `alt_names` section.
    ```conf
    [alt_names]
    DNS.1=localhost.traefik.com
    DNS.2=localhost.site.com
    DNS.3=my-domain.com
    .
    .
    .
    ```
2. Generate the certificate by executing the `generate-ssl.sh` script located in the `scripts` directory. You will notice that a `cert.crt` and `cert.key` files were created.
    ```bash
    cd scripts && ./generate-ssl.sh
    ```

## Adding SSL Certificates to traefik
Now that you bought or generate a certificate, add it to traefik is really easy. 

1. Place your certificate files (generally a `.crt` and a `.key` files) inside the `certs` directory.

2. Rename the `tlsOptions.toml.sample` file place in the `dynamic` directory to `tlsOptions.toml`.
    ```bash
    mv tlsOptions.toml.sample tlsOptions.toml
    ```

3. Edit the `tlsOptions.toml` file content with your certificate file information using the configuration that best suits your needs. Read more [`here`](https://docs.traefik.io/https/tls/)

## Testing

1. Create this `docker-composer.yml` file and run `docker-compose up`.
    ```yml
    version: "3.3"

    networks:
    docker_default:
        external: true

    services:
    nginx:
        image: nginx:latest
        networks:
        - docker_default
        labels:
        - traefik.enable=true
        - traefik.docker.network=docker_default
        - traefik.http.routers.nginx.entryPoints=https
        - traefik.http.routers.nginx.rule=Host(`localhost.nginx.com`)
        - traefik.http.routers.nginx.tls=true
    ```
2. Open your favorite web browser and go to [`localhost.nginx.com`](https://localhost.nginx.com).

# Contributions
There's always room for improvements, please submit a issue or a pull request if you have the time.
