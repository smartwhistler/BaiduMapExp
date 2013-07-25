#!/usr/bin/perl
use warnings;
use strict;
use diagnostics;
use 5.010;

use LWP::Simple;
use JSON -support_by_pp;
use Encode qw/encode/;

my $query = "安医二附院";
my $region = "";
my $page_size = 6;
my $URL;

$query = $ARGV[0] if(defined($ARGV[0]));
$region = $ARGV[1] if(defined($ARGV[1]));
$URL = "https://maps.googleapis.com/maps/api/place/textsearch/json?".
	"query=".$query."+".$region."&sensor=false&key=AIzaSyDyC3GWpS2VF5GzkZ07FtQw67dQduPfsbM";
my $rlt = get($URL);

say "使用Google Place Text Search API在".$region."搜索".$query."的结果是:";
my $json_obj = JSON->new->allow_nonref;
$json_obj->allow_singlequote;
$json_obj->allow_barekey;
my $rlt_decoded = $json_obj->decode($rlt);
my $cnt=0;
foreach(@{${$rlt_decoded}{"results"}}){
	$cnt++;
	say "*******".$cnt."*******";
	say "名称: ".${$_}{"name"} if defined ${$_}{"name"};
	say "地址: ".${$_}{"formatted_address"} if defined ${$_}{"formatted_address"};
	say "经纬度: ".${${${$_}{"geometry"}}{"location"}}{"lat"}
		.",".${${${$_}{"geometry"}}{"location"}}{"lng"}
		if defined ${${$_}{"geometry"}}{"location"};
	if(defined ${$_}{"types"}) {
		print "类型: ";
		foreach(@{${$_}{"types"}}) {
			print $_.", ";
		}
		say "";
	}
}
