# ts
`ts` is a simple UNIX Timestamp utility for the shell. It can get the current UNIX timestamp, convert a timestamp into localized time and diff timestamps.
## Examples
1. Get current UNIX timestamp: (I realize this is trivial with `date`, but how often have _you_ googled this.)

		$ ts
		1534947844

2. Convert timestamp to local time:

		$ ts 1534950044
		1534950044 -> Wed Aug 22 11:00:44 EDT 2018

	`ts` also accepts input from `stdin` in same format as its arguments (`ts ts ...`)

		$ echo 1534947844 | ts
		1534947844 -> Wed Aug 22 10:24:04 EDT 2018

3. Diff timestamps (calculates the duration of the smallest and the greatest arguments):

		$ ts 1534947844 1534947904
		1534947844 -> Wed Aug 22 10:24:04 EDT 2018
		1534947904 -> Wed Aug 22 10:25:04 EDT 2018
		Duration: 00:01:00

	`ts` is also a first class utility, so it plays nicely with pipelines. Here we diff a timestamp and 'now' calculating the duration in elapsed time.

		$ ts 1534947844 | ts
		1534947844 -> Wed Aug 22 10:24:04 EDT 2018
		1534948588 -> Wed Aug 22 10:36:28 EDT 2018
		Duration: 00:12:24

4. Convert and diff multiple timestamps:

		$ ts 1534947844 1534947904 1534948588
		1534947844 -> Wed Aug 22 10:24:04 EDT 2018
		1534947904 -> Wed Aug 22 10:25:04 EDT 2018
		1534948588 -> Wed Aug 22 10:36:28 EDT 2018
		Duration: 00:12:24

	Or with pipelines:

		$ ts | ts | ts | ts
		1534948773 -> Wed Aug 22 10:39:33 EDT 2018
		1534948773 -> Wed Aug 22 10:39:33 EDT 2018
		1534948773 -> Wed Aug 22 10:39:33 EDT 2018
		Duration: 00:00:00

## Installation
1. Clone this repo in your projects `/` development directory. I will demonstrate installation using `~/Development/ts`

		git clone https://github.com/kalenanson/ts ~/Development

2. `ts` needs to be located in your shell's `$PATH`, so you have a couple of options. Either copy the `ts.sh` into a `/bin` directory or create a symbolic link. The first is more secure, the second is more flexible. I'll demonstrate both options and assume that `/usr/local/bin` is already in your shell's path.

		# Copy into `/usr/local/bin`
		sudo cp ts.sh /usr/local/bin/ts
		# OR
		# Create a soft link in /usr/local/bin
		sudo ln -s ~/Development/ts/ts.sh /usr/local/bin/ts

3. If the above worked then you should now be able to invoke `ts` as follows:

		$ ts
		1534947844

	If you get an error, check your shell's `$PATH` and verify that you see the `ts` link / file in the place you put in #2 above. Also verify permissions on the link / file. It should have something like `755`.

## Usage
### Simple Usage
Simple usage is as follows:

	ts -hv [timestamp ...]

Where `-h` and `-v` are for help and version respectively.

When no arguments are passed to `ts` it prints the current UNIX timestamp and exits.

When arguments are passed to `ts` it expects one or more timestamps that are space delineated. For example:

	ts 1534947844 1534947904 1534948588

When passed a single argument, `ts` will attempt to convert the value to a date time using `date(1)`. If successful you should see the timestamp followed by a date. For example:

	$ ts 1534950044
	1534950044 -> Wed Aug 22 11:00:44 EDT 2018

When passed multiple arguments, `ts` will preform conversions and tally the total duration or difference between the largest and smallest timestamp and also print out a duration. For example:

	$ ts 1534947844 1534947904
	1534947844 -> Wed Aug 22 10:24:04 EDT 2018
	1534947904 -> Wed Aug 22 10:25:04 EDT 2018
	Duration: 00:01:00

Duration is printed in total hours, minutes, seconds in the format `h:m:s`.

### Advanced Usage
`ts` is pipeline friendly so here is its expected behavior in a pipeline:

	something | ts

When reading from `stdin`, `ts` needs to be invoked without arguments. It will attempt to read a series of space delineated arguments from its `stdin` stream all on the same line (i.e. no newlines present). If arguments are present, `ts` will ignore `stdin` and process the arguments instead.

	ts | something

When `ts` is in front of a pipe, its behavior changes and it will simply echo its arguments along _and add the current UNIX timestamp as the last value_, delineated by spaces. A contrived example:

	$ echo 1534947844 1534947904 1534948588 | ts | cat
	1534947844 1534947904 1534948588 1534950177

The advanced behavior of `ts` was developed for fun and to facilitate some of the following simplified operations:

1. Diff from a timestamp to current time

		$ ts 1534947844 | ts
		1534947844 -> Wed Aug 22 10:24:04 EDT 2018
		1534950475 -> Wed Aug 22 11:07:55 EDT 2018
		Duration: 00:43:51

2. Pipeline of fury

		$ ts 1534947844 | ts | ts | ts | ts | ts | ts | ts
		1534947844 -> Wed Aug 22 10:24:04 EDT 2018
		1534950565 -> Wed Aug 22 11:09:25 EDT 2018
		1534950565 -> Wed Aug 22 11:09:25 EDT 2018
		1534950565 -> Wed Aug 22 11:09:25 EDT 2018
		1534950565 -> Wed Aug 22 11:09:25 EDT 2018
		1534950565 -> Wed Aug 22 11:09:25 EDT 2018
		1534950565 -> Wed Aug 22 11:09:25 EDT 2018
		1534950565 -> Wed Aug 22 11:09:25 EDT 2018
		Duration: 00:45:21

Hope you enjoy. Pull requests welcome.
