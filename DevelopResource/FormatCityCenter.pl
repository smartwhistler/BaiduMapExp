#!/usr/bin/perl
use 5.010;
use strict;
use warnings;
use JSON -support_by_pp;

if(defined($ARGV[0])) {
	open(JSON_IN, "<".$ARGV[0]);
} else {
	open(JSON_IN, "<"."BaiduMap_cityCenter.txt");
}
my @json_lines = <JSON_IN>;
chomp(@json_lines);
my $json_oneline = join("", @json_lines);
close(JSON_IN);

# Print It Formatted.
my $json_obj = JSON->new->allow_nonref;
$json_obj->allow_singlequote;
$json_obj->allow_barekey;
my $format_printed = $json_obj->decode($json_oneline);

foreach(keys(%{${format_printed}})) {
	say "-----------".$_."-----------";
	foreach(@{${${format_printed}}{$_}}) {
		say "**********";
		say ${$_}{'n'} . ":" . ${$_}{'g'};
		if(defined(${$_}{"cities"})) {
			foreach (@{${$_}{"cities"}}) {
				say ${$_}{'n'} . ":" . ${$_}{'g'};
			}
		}
		say "**********";
	}
	say "";
}
