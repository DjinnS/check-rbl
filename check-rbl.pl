#!/usr/bin/perl
#
# check-rbl
#
# Check if an IP is listed on most famous RBL.
#
# Exit code is 0 if not, 1 if listed.
#
# http://github.com/djinns/check-rbl
#
# Copyright (C) 2012 djinns@chninkel.net
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

####
# LIBS
####
use warnings;
use strict;
use Getopt::Long;
use Net::IP;
use Net::DNS;

####
# RBL
####
my @rbl=('b.barracudacentral.org','cbl.abuseat.org','dnsbl.invaluement.com','http.dnsbl.sorbs.net','misc.dnsbl.sorbs.net','socks.dnsbl.sorbs.net','web.dnsbl.sorbs.net','dnsbl-1.uceprotect.net','dnsbl-3.uceprotect.net','sbl.spamhaus.org','zen.spamhaus.org','psbl.surriel.com','dnsbl.njabl.org','rbl.spamlab.com','ircbl.ahbl.org','noptr.spamrats.com','cbl.anti-spam.org.cn','dnsbl.inps.de','httpbl.abuse.ch','korea.services.net','virus.rbl.jp','wormrbl.imp.ch','rbl.suresupport.com','ips.backscatterer.org','opm.tornevall.org','multi.surbl.org','tor.dan.me.uk','relays.mail-abuse.org','rbl-plus.mail-abuse.org','access.redhawk.org','rbl.interserver.net','bogons.cymru.com','bl.spamcop.net','dnsbl.sorbs.net','dul.dnsbl.sorbs.net','smtp.dnsbl.sorbs.net','spam.dnsbl.sorbs.net','zombie.dnsbl.sorbs.net','dnsbl-2.uceprotect.net','pbl.spamhaus.org','xbl.spamhaus.org','bl.spamcannibal.org','ubl.unsubscore.com','combined.njabl.org','dnsbl.ahbl.org','dyna.spamrats.com','spam.spamrats.com','cdl.anti-spam.org.cn','drone.abuse.ch','dul.ru','short.rbl.jp','spamrbl.imp.ch','virbl.bit.nl','dsn.rfc-ignorant.org','dsn.rfc-ignorant.org','netblock.pedantic.org','ix.dnsbl.manitu.net','rbl.efnetrbl.org','blackholes.mail-abuse.org','dnsbl.dronebl.org','db.wpbl.info','query.senderbase.org');

####
# VARS
####
my ($o_ip,$o_help,$o_quiet);

####
# FUNCTIONS
####

# check_options
sub check_options {
    Getopt::Long::Configure ("bundling");
    GetOptions(
        'i:s'   => \$o_ip,		'ip:s'		=> \$o_ip,
        'q'   	=> \$o_quiet,	'quiet'		=> \$o_quiet,
        'h'     => \$o_help,	'help'		=> \$o_help
    );

    if (!defined($o_ip)||($o_help)) {
        usage();
        exit;
    }
}

# usage
sub usage {
    print <<"EOT";
Usage of $0

Required parameters:
	-i,--ip 	The IP to check
	-q,--quiet	Quiet mode

	-h,--help	Show help

    Report bugs or ask for new options: https://github.com/DjinnS/check-rbl

EOT
}

####
# MAIN
####

check_options();

my $ip= new Net::IP($o_ip);
my $warn=0;

if($ip) {

	$_ = $ip->reverse_ip();

	s/in\-addr\.arpa\.//gi;

	my $reverse = $_;

	foreach(@rbl) {

		my $query = $reverse . $_;

		my $res = Net::DNS::Resolver->new;
		my $set = $res->search($query);

		if ($set) {
			if(!$o_quiet) { print $ip->ip() ." is listed on ". $_ ." !\n"; }
			$warn=1;
		}
	}
} else {
	print "Not a valid IP Address !\n";
}

if(!$warn) {
	if(!$o_quiet) { print $ip->ip() ." isn't listed on any RBL !\n"; }
}

exit($warn);

