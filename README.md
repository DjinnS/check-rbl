# check-rbl

Check if an IP is listed on the most used RBL

## Usage of check-rbl.pl

Required parameters:
  * -i,--ip         The IP to check
  * -t,--timeout    Set timeout for request (Default: 10sec)
  * -q,--quiet      Quiet mode
  * -v,--verbose	Verbose mode
  * -h,--help       Show help
	</ul>

<h3>Example:</h3>

	$ perl check-rbl.pl -i 8.8.8.8
	8.8.8.8 isn't listed on any RBL.

Exit code is 0 if not, 1 if listed.

Report bugs or ask for new options: https://github.com/DjinnS/check-rbl

