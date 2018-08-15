#!/bin/bash
# ø
# Timestamp helper
#
# Seconds conversion helper
convertsecs() {
	((h=${1}/3600))
	((m=${1}%3600/60))
	((s=${1}%60))
	printf "%02d:%02d:%02d\n" $h $m $s
}
# If there are no args passed on the command line either read from stdin or
# print the current timestamp and exit
if [[ -z "$1" ]]; then
	# Read from pipe
    if [[ -p /dev/stdin ]]; then
        IFS=' ' read -ra stamps
    else
		date +%s
        exit
    fi
else
	stamps=""
fi
# Process variables if stdin is not a pipe
if [[ -z "$stamps" ]]; then
	stamps=$@
fi
# Read each timestamp and calculate the max duration
start=0
end_t=0
for var in "${stamps[@]}"
do
	# Check start time
	if [[ "$start" -eq 0 ]]; then
		start="$var"
	elif [[ "$start" -gt "$var" ]]; then
		if [[ "$start" -gt "$end_t" ]]; then
			end_t="$start"
		fi
		start="$var"
	elif [[ "$end_t" -lt "$var" ]]; then
		end_t="$var"
	fi
	# Convert the timestamp to human format
	if [[ $OSTYPE == "linux-gnu" ]]; then
		dt=$(date -d @"$var")
	else
		dt=$(date -r "$var")
	fi
	# If stdout is a pipe just echo each timestamp
	if [[ -p /dev/stdout ]]; then
		# This goes to stdout
		printf "$var "
	else
		echo "$var -> $dt"
	fi
done
# For fun, if stdout is a pipe, add the current timestamp otherwise
# show the duration if there were more than 2 dissimilar times
if [[ -p /dev/stdout ]]; then
	date +%s
else
	if [[ "$start" -ne 0 && "$end_t" -ne 0 ]]; then
		duration=$(($end_t - $start))
		durHuman=$(convertsecs $duration)
		echo "Duration: $durHuman" >&2
	fi
fi
