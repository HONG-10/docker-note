##########################################################################
# Docker System
##########################################################################

$ docker version

$ docker system

# ------------------------------------------------------------

# Show docker disk usage
$ docker system df

#* Options
#* --format		    Format output using a custom template: ‘table’: Print output in table format with column headers (default) ‘table TEMPLATE’: Print output in table format using the given Go template ‘json’: Print in JSON format ‘TEMPLATE’: Print output using the given Go template. Refer to https://docs.docker.com/go/formatting/ for more information about formatting output with templates
#* --verbose | -v	Show detailed information on space usage

# ------------------------------------------------------------
# Get real time events from the server
$ docker events
$ docker system events

#* Options
#* --filter | -f	Filter output based on conditions provided
#* --format		    Format the output using the given Go template
#* --since		    Show all events created since timestamp
#* --until		    Stream events until this timestamp

# ------------------------------------------------------------

# Display system-wide information
$ docker info
$ docker system info

#* Options
#* --format | -f	Format the output using the given Go template

$ docker info | grep -i network
$ docker info | grep -i registry

$ docker info | grep "Root"     # /var/lib/docker

# ------------------------------------------------------------

# Remove unused data
$ docker system prune

#* Options
#* --all | -a		Remove all unused images not just dangling ones
#* --filter         Provide filter values (e.g. label=<key>=<value>)
#* --force | -f     Do not prompt for confirmation
#* --volumes        Prune volumes

# ------------------------------------------------------------
