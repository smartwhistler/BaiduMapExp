#!/usr/bin/perl
use warnings;
use strict;
use diagnostics;
use 5.010;

use LWP::Simple;
use JSON -support_by_pp;
use Encode qw/encode/;

my $query = "安医";
my $URL;

$query = $ARGV[0] if(defined($ARGV[0]));
$URL = "https://maps.googleapis.com/maps/api/place/autocomplete/json?"
	."input=".$query."&sensor=true&key=AIzaSyDyC3GWpS2VF5GzkZ07FtQw67dQduPfsbM";
my $rlt = get($URL);

say "使用Google Places Autocomplete API输入".$query."的补全结果是:";
my $json_obj = JSON->new->allow_nonref;
$json_obj->allow_singlequote;
$json_obj->allow_barekey;
my $rlt_decoded = $json_obj->decode($rlt);
foreach (@{${$rlt_decoded}{"predictions"}}) {
	say ${$_}{"description"};
}
