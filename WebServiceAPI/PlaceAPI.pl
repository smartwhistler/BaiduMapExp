#!/usr/bin/perl
use warnings;
use strict;
use 5.010;
use LWP::Simple;

binmode(STDOUT, ":utf8");

my $URL = "http://api.map.baidu.com/place/v2/".
		"search?&q=饭店&region=北京&output=json&".
		"ak=273dab0494b269c25bfce69526f0316d&".
		"page_size=15&page_num=0&scope=2";
my $rlt = get($URL);
die "Couldn't get it!" unless defined $rlt;
say $rlt;
