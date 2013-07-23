#!/usr/bin/perl
use warnings;
use strict;
use 5.010;
use LWP::Simple;
use Encode qw/encode/;

my $URL = "http://api.map.baidu.com/geocoder/v2/?address=百度大厦&".
		"output=json&ak=273dab0494b269c25bfce69526f0316d";
my $rlt = get($URL);
$rlt = encode("utf8", $rlt);	# 可恶的编码转换
die "Couldn't get it!" unless defined $rlt;
say $rlt;
