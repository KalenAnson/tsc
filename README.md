# tsc
`tsc` is a simple UNIX Timestamp utility for the shell. It can get the current UNIX timestamp, convert a timestamp into localized time and diff timestamps.
## Examples
1. Get current UNIX timestamp: (I realize this is trivial with `date(1)`, but how often have _you_ googled this.)

		$ tsc
		1534947844

2. Convert timestamp to local time:

		$ tsc 1534950044
		1534950044 -> Wed Aug 22 11:00:44 EDT 2018

	`tsc` also accepts input from `stdin` in same format as its arguments (`timestamp timestamp ...`)

		$ echo 1534947844 | tsc
		1534947844 -> Wed Aug 22 10:24:04 EDT 2018

3. Diff timestamps (calculates the duration of the smallest and the greatest arguments):

		$ tsc 1534947844 1534947904
		1534947844 -> Wed Aug 22 10:24:04 EDT 2018
		1534947904 -> Wed Aug 22 10:25:04 EDT 2018
		Duration: 00:01:00

	`tsc` is also a first class utility, so it plays nicely with pipelines. Here we diff a timestamp and 'now', calculating the duration in elapsed time.

		$ tsc 1534947844 | tsc
		1534947844 -> Wed Aug 22 10:24:04 EDT 2018
		1534948588 -> Wed Aug 22 10:36:28 EDT 2018
		Duration: 00:12:24

4. Convert and diff multiple timestamps:

		$ tsc 1534947844 1534947904 1534948588
		1534947844 -> Wed Aug 22 10:24:04 EDT 2018
		1534947904 -> Wed Aug 22 10:25:04 EDT 2018
		1534948588 -> Wed Aug 22 10:36:28 EDT 2018
		Duration: 00:12:24

## Installation
1. Clone this repo in your projects directory. For demonstration purposes, I will be using `~/Development/tsc` in the example commands below.

		git clone https://github.com/kalenanson/tsc ~/Development/

2. If you want to add the `tsc.sh` command to your path could either alias the shell script, copt the script into your path, or create a symbolic link in your path. You have several options. Aliasing will need to make it into your dot files to be permanent, copying the file is the most secure and the symbolic link is the most flexiable as the command will stay updated when you update the repo. I'll demonstrate the obvious options and assume that `/usr/local/bin` is already in your shell's path.

		# Aliasing (simplest), add to your .bashrc as well
		alias tsc=~/Development/tsc/tsc.sh
		# OR
		# Copy into `/usr/local/bin`
		sudo cp tsc.sh /usr/local/bin/tsc
		# OR
		# Create a soft link in /usr/local/bin
		sudo ln -s ~/Development/tsc/tsc.sh /usr/local/bin/tsc

3. If the above worked then you should now be able to invoke `tsc` as follows:

		$ tsc
		1534947844

	If you get an error, check your shell's `$PATH` and verify that you see the `tsc` link / file in the place you put in #2 above. Also verify permissions on the link / file. It should have something like `755`.

## Usage
### Simple Usage
Simple usage is as follows:

	tsc -hv [timestamp ...]

Where `-h` and `-v` are for help and version respectively.

When no arguments are passed to `tsc` it prints the current UNIX timestamp and exits.

When arguments are passed to `tsc` it expects one or more timestamps that are space delineated. For example:

	tsc 1534947844 1534947904 1534948588

When passed a single argument, `tsc` will attempt to convert the value to a date time using `date(1)`. If successful you should see the timestamp followed by a date. For example:

	$ tsc 1534950044
	1534950044 -> Wed Aug 22 11:00:44 EDT 2018

When passed multiple arguments, `tsc` will preform conversions and tally the total duration or difference between the largest and smallest timestamp and also print out a duration. For example:

	$ tsc 1534947844 1534947904
	1534947844 -> Wed Aug 22 10:24:04 EDT 2018
	1534947904 -> Wed Aug 22 10:25:04 EDT 2018
	Duration: 00:01:00

Duration is printed in total hours, minutes, seconds in the format `h:m:s`.

### Advanced Usage
`tsc` is pipeline friendly so here is its expected behavior in a pipeline:

	something | tsc

When reading from `stdin`, `tsc` needs to be invoked without arguments. It will attempt to read a series of space delineated arguments from its `stdin` stream all on the same line (i.e. no newlines present). If arguments are present, `tsc` will ignore `stdin` and process the arguments instead.

	tsc | something

When `tsc` is in front of a pipe, its behavior changes and it will echo its arguments along __adding the current UNIX timestamp as the last value__, delineated by spaces. A contrived example:

	$ echo 1534947844 1534947904 1534948588 | tsc | cat
	1534947844 1534947904 1534948588 1534950177

The advanced behavior of `tsc` was developed for fun and to facilitate some of the following simplified operations:

1. Diff from a timestamp to current time

		$ tsc 1534947844 | tsc
		1534947844 -> Wed Aug 22 10:24:04 EDT 2018
		1534950475 -> Wed Aug 22 11:07:55 EDT 2018
		Duration: 00:43:51

2. Pipeline of fury

		$ tsc 1534947844 | tsc | tsc | tsc | tsc | tsc | tsc | tsc
		1534947844 -> Wed Aug 22 10:24:04 EDT 2018
		1534950565 -> Wed Aug 22 11:09:25 EDT 2018
		1534950565 -> Wed Aug 22 11:09:25 EDT 2018
		1534950565 -> Wed Aug 22 11:09:25 EDT 2018
		1534950565 -> Wed Aug 22 11:09:25 EDT 2018
		1534950565 -> Wed Aug 22 11:09:25 EDT 2018
		1534950565 -> Wed Aug 22 11:09:25 EDT 2018
		1534950565 -> Wed Aug 22 11:09:25 EDT 2018
		Duration: 00:45:21

Hope you enjoy. Pull requests and feature requests are welcome.
