#!/bin/bash
set -e

# This script designed to be used a docker ENTRYPOINT "workaround" missing docker
# feature discussed in docker/docker#7198, allow to have executable in the docker
# container manipulating files in the shared volume owned by the USER_ID:GROUP_ID.
#
# It creates a user named `dkr` with selected USER_ID and GROUP_ID (or
# 1000 if not specified).

# Example:
#
#  docker run -ti -e UID=$(id -u) -e GID=$(id -g) imagename bash
#

# Reasonable defaults if no USER_ID/GROUP_ID environment variables are set.
if [ -z ${USER_ID+x} ]; then USER_ID=1000; fi
if [ -z ${GROUP_ID+x} ]; then GROUP_ID=1000; fi

msg="docker_entrypoint: Creating user UID/GID [$USER_ID/$GROUP_ID]" && echo $msg
groupadd -g $GROUP_ID -r dkr && \
useradd -u $USER_ID --create-home -r -g dkr dkr
echo "$msg - done"

msg="docker_entrypoint: Copying .gitconfig and .ssh/config to new user home" && echo $msg
cp /scripts/gitconfig /home/dkr/.gitconfig && \
chown dkr:dkr /home/dkr/.gitconfig && \
mkdir -p /home/dkr/.ssh && \
cp /scripts/ssh_config /home/dkr/.ssh/config && \
chown dkr:dkr -R /home/dkr/.ssh &&
echo "$msg - done"

echo "dkr ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Default to 'bash' if no arguments are provided
args="$@"
if [ -z "$args" ]; then
  args="/scripts/start.sh"
fi

exec $args
