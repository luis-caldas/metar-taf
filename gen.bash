#!/usr/bin/env bash

# Globals
FILE_NAME="main.bash"
SKELETON_NAME="service.skeleton"
OUTPUT_NAME="metar-tafs.service"

# Find all necessary information
USER_CHOSEN="$(whoami)"
PATH_ALL="$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")"
PATH_SCRIPT="$PATH_ALL/$FILE_NAME"

# Check if we have the needed command to proceed
NEEDED_COMMANDS=( "envsubst" )
# Iterate the command list
commands_array=()
for each_command in "${NEEDED_COMMANDS[@]}"; do
	if ! command -v "$each_command" &> /dev/null; then
		commands_array+=("$each_command")
	fi
done
# If there is anything in the array a command could not be found
if [ "${#commands_array[@]}" != "0" ]; then
	echo "Commands (${commands_array[*]}) could not be found"
	exit 127
fi

# Export the needed vars
export USER_CHOSEN PATH_ALL PATH_SCRIPT

# Substitute the skeleton for the final file
envsubst < "$PATH_ALL/$SKELETON_NAME" > "$PATH_ALL/$OUTPUT_NAME"
