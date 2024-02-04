# Dockerized CDN Simulation

## Description

This repository provides a Dockerized simulation of a Content Delivery Network (CDN) environment. The simulation includes components such as Nginx servers, Prometheus for monitoring, and Grafana for visualization.

## Dependencies

To run the CDN simulation, you need to have the following dependencies installed on your system:

- Docker: Make sure you have Docker installed and running on your machine. You can download and install Docker from the [official Docker website](https://www.docker.com/get-started).
- Docker Compose: Docker Compose is used to manage multi-container Docker applications. Ensure that Docker Compose is installed along with Docker.

## How to Use

Follow these steps to set up and run the CDN simulation:

1. Clone the repository to your local machine:

    ```bash
    git clone https://github.com/your-username/cdn-simulation.git
    ```

2. Navigate to the project directory:

    ```bash
    cd cdn-simulation
    ```

3. Start the CDN simulation using Docker Compose:

    ```bash
    docker-compose up -d
    ```

   This command will start the CDN components defined in the `docker-compose.yml` file in detached mode.

4. Once the containers are up and running, you can access the following components:

   - **Nginx Servers**: The Nginx servers are accessible at `http://localhost:8080`, `http://localhost:8081`, etc.
   - **Prometheus**: Prometheus is accessible at `http://localhost:9090`.
   - **Grafana**: Grafana is accessible at `http://localhost:3000`. Log in with the default credentials (username: `admin`, password: `admin`), and configure Prometheus as a data source to start visualizing metrics.

5. To stop the CDN simulation, run:

    ```bash
    docker-compose down
    ```

   This command will stop and remove the Docker containers created by Docker Compose.

## Configuration

You can customize the Nginx server configurations, Prometheus settings, and Grafana dashboards by modifying the respective configuration files in the `config` directory.

## Contributing

Contributions are welcome! If you find any issues or have suggestions for improvement, please feel free to open an issue or create a pull request.

## License

This project is licensed under the [MIT License](LICENSE).

