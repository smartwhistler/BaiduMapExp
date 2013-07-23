#!/usr/bin/perl
use warnings;
use strict;
use 5.010;
use LWP::Simple;

binmode(STDOUT, ":utf8");

my $URL = "http://api.map.baidu.com/location/ip?"
		."ak=F454f8a5efe5e577997931cc01de3974";
#		."&ip=202.198.16.3&coor=bd09ll";
my $rlt = get($URL);
die "Couldn't get it!" unless defined $rlt;
say $rlt;
