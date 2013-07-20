#!/usr/bin/perl
use 5.010;
use strict;
use warnings;

if(defined($ARGV[0])) {
	open(CITY_CODE, "<".$ARGV[0]);
} else {
	open(CITY_CODE, "<"."BaiduMap_cityCode.txt");
}
my @citycode_lines = <CITY_CODE>;
chomp (@citycode_lines);
my $citycode_oneline = join("", @citycode_lines);
close (CITY_CODE);

my @citycodes = split(",", $citycode_oneline);
my %city_code_hash;
foreach(@citycodes) {
	my $city;
	my $code;
	($city, $code) = split(/\|/, $_);
	${city_code_hash}{$city} = $code;
}

foreach(keys(%city_code_hash)) {
	say $_."_".$city_code_hash{$_};
}
