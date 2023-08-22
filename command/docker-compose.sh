##########################################################################
# Docker Compose
##########################################################################

$ docker compose

# ------------------------------------------------------------

# Show the Docker Compose version information
$ docker compose version

# List running compose projects
$ docker compose ls

# List containers
$ docker compose ps

# Print the public port for a port binding.
$ docker compose port

# Receive real time events from containers.
$ docker compose events

# Display the running processes
$ docker compose top

# View output from containers
$ docker compose logs

# ------------------------------------------------------------

# Build or rebuild services
$ docker compose build

# List images used by the created containers
$ docker compose images

# Pull service images
$ docker compose pull

# Push service images
$ docker compose push

# ------------------------------------------------------------

# Creates containers for a service.
$ docker compose create

# Run a one-off command on a service.
$ docker compose run

# Start services
$ docker compose start

# Stop services
$ docker compose stop

# Restart service containers
$ docker compose restart

# Removes stopped service containers
$ docker compose rm

# Create and start containers
$ docker compose up

$ docker compose up -d

# Stop and remove containers, networks
$ docker compose down

# Force stop service containers.
$ docker compose kill

# Pause services
$ docker compose pause

# Unpause services
$ docker compose unpause

# ------------------------------------------------------------

# Parse, resolve and render compose file in canonical format
$ docker compose config

# Copy files/folders between a service container and the local filesystem
$ docker compose cp

# Execute a command in a running container.
$ docker compose exec
