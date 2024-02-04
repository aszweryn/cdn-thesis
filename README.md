# Dockerized CDN Simulation

## Description

This repository is part of a Bachelor's Degree thesis project at the Warsaw University of Technology.

It serves as a simulation of a CDN network, demonstrating its key characteristics and capabilities.

## Dependencies

To run the CDN simulation on a Linux machine, the following dependencies are required:

- [Docker](https://www.docker.com/): for deploying containerized applications.
- [Docker Compose](https://docs.docker.com/compose/): for orchestrating apps consisting of multiple containers.
- [Nginx](https://www.nginx.com/): a popular, open-source webserver. This includes:
    - A comprehensive virtual host traffic status module - [nginx-module-vts](https://github.com/vozlt/nginx-module-vts).
    - The module allowing for extending webserver capabilities by [adding Lua code](https://github.com/openresty/lua-nginx-module).
- [Lua](https://www.lua.org/): a powerful, modern scripting language used for extending Nginx server capabilities.
- [Prometheus](https://prometheus.io/): a monitoring and alerting toolkit.
- [Grafana](https://grafana.com/): tooling used for metric and log visualization.
- [Wrk](https://github.com/wg/wrk): a benchmarking tool with a great deal of useful settings.

## How to Use

After cloning the repository proceed with:

1. Start the CDN simulation using Docker Compose:

    ```bash
    docker compose up [-d]
    ```
    
    You may use the `-d` flag that stands for "detached mode". When you run Docker Compose with the `-d` flag, it starts the services in the background and prints their container IDs. This allows you to continue using your terminal for other tasks while the CDN simulation runs in the background. If you omit the `-d` flag, Docker Compose will start the services in the foreground, and their logs will be displayed in your terminal.

2. Once the containers are up and running, you can access the following components:

   - **Nginx Servers**: The Nginx servers are accessible at `http://localhost:8080`, `http://localhost:8081`, etc.
   - **Prometheus**: Prometheus is accessible at `http://localhost:9090`.
   - **Grafana**: Grafana is accessible at `http://localhost:9091`. Log in with the default credentials (username: `admin`, password: `admin`), and configure Prometheus as a data source to start visualizing metrics.

3. To stop the CDN simulation, run:

    ```bash
    docker compose down
    ```

   This command will stop and remove the Docker containers created by Docker Compose.
   
## Configuration

You can customize the Nginx server configurations, Prometheus settings, and Grafana dashboards by modifying the respective configuration files in the `config` directory.

Additionally, the databases of Prometheus and Grafana are located in the `data` folder, located in the root repository directory. If not present, it will appear after running the simulation. Any data generated or collected by Prometheus and Grafana, including metrics and dashboards you create, will be stored in this folder. You can access and manage these databases to maintain and customize your monitoring and visualization settings.
