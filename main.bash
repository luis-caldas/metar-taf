#!/usr/bin/env bash

# Main locations to get the information
AIRPORTS=( "EICK" )

# The replacement string
REPLACE_STRING="%%{REPLACE}%%"

# The separation char
SEP_CHAR="-"

# Execution time
EXECUTE_TIME="0700"

# Sleep interval
SLEEP_INTERVAL=10

# Websites to get the information
METAR="https://tgftp.nws.noaa.gov/data/observations/metar/stations/${REPLACE_STRING}.TXT"
TAFS="https://tgftp.nws.noaa.gov/data/forecasts/taf/stations/${REPLACE_STRING}.TXT"

replace_metar_location() {
	echo "${METAR//${REPLACE_STRING}/${1}}"
}
replace_taf_location() {
	echo "${TAFS//${REPLACE_STRING}/${1}}"
}

get_info() {
	curl -s "${1}"
}

# Print all the information neatly
format() {

	# Iterate on all the locations
	for each_location in "${AIRPORTS[@]}"; do

		# Generate URLs
		metar_url="$(replace_metar_location "${each_location}")"
		tafs_url="$(replace_taf_location "${each_location}")"

		# Get them
		metar_data="$(get_info "$metar_url")"
		tafs_data="$(get_info "$tafs_url")"

		# All verbose
		length_location="${#each_location}"
		printf "%${length_location}s\n" | tr " " "$SEP_CHAR"
		echo "$each_location"
		printf "%${length_location}s\n" | tr " " "$SEP_CHAR"

		echo
		echo "$metar_data"
		echo
		echo "$tafs_data"
		echo

	done

}

# Print the information out
print_out() {
	# echo "$1" | lpr -
	true
}

# Main loop to print info
main() {

	previous_date="01011970"

	while true; do

		# Date full
		date="$(date +"%d%m%Y")"
		# Get current time
		time="$(date +"%H%M")"

		# Create time stamp
		timestamp="[$(date +"%Y/%m/%d %H:%M:%S")] -"

		# Date and time checking
		# Check the date for variance
		if [ "$date" != "$previous_date" ]; then

			# Execute script it the times are matching or more
			if [ "$time" -ge "$EXECUTE_TIME" ]; then

				# Get data
				all_data="$(format)"

				# Print it out to printer
				print_out "$all_data"

				# Verbose
				echo "$timestamp Printed info for $date @ $time"

				# Update the previous date
				previous_date="$date"

			else

				# Info to user
				echo "$timestamp Time $time is still not $EXECUTE_TIME @ $date"

			fi

		else

			# A bit of verbose
			echo "$timestamp Already run today @ $date"

		fi

		# Sleep
		sleep "$SLEEP_INTERVAL"

	done
}


# Call main
main "$@"
