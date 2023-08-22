##########################################################################
# Docker Network
##########################################################################

$ docker network

# ------------------------------------------------------------

# List networks
$ docker network ls

# Display detailed information on one or more networks
$ docker network inspect

# ------------------------------------------------------------

# Create a network
$ docker network create

# Remove one or more networks
$ docker network rm

# Remove all unused networks
$ docker network prune

# ------------------------------------------------------------

# Connect a container to a network
$ docker network connect

#! endpoint를 2개 붙일 떄 사용. 붙였다 뗐다 할 수 있음.

# Disconnect a container from a network
$ docker network disconnect
