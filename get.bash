#!/usr/bin/env bash

# Main locations to get the information
AIRPORTS=( "EICK" )

# The replacement string
REPLACE_STRING="%%{REPLACE}%%"

# The separation char
SEP_CHAR="-"

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

# Main function
main() {

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

# Call main
main "$@"