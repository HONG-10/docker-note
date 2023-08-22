##########################################################################
# Docker Volume
##########################################################################

# ------------------------------------------------------------

# List volumes
$ docker volume ls

# Display detailed information on one or more volumes
$ docker volume inspect

# ------------------------------------------------------------

# Create a volume
$ docker volume create

# Remove one or more volumes
$ docker volume rm

# Remove all unused local volumes
$ docker volume prune

# ------------------------------------------------------------

# Update a volume (cluster volumes only) | docker-swarm, K8s
$ docker volume update
