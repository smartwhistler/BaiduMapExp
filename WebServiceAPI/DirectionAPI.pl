#!/usr/bin/perl
use warnings;
use strict;
use diagnostics;
use 5.010;

use LWP::Simple;
use JSON -support_by_pp;
use Encode qw/encode/;

my $query = "安医二附院";
my $region = "合肥";
my $page_size = 6;
my $URL;

$query = $ARGV[0] if(defined($ARGV[0]));
$region = $ARGV[1] if(defined($ARGV[1]));
$URL = "http://api.map.baidu.com/place/v2/search?".
		"&q=".$query."&region=".$region."&output=json".
		"&ak=273dab0494b269c25bfce69526f0316d".
		"&page_size=".$page_size."&page_num=0&scope=2";
my $rlt = get($URL);
$rlt = encode("utf8", $rlt);	# 可恶的编码转换

say "使用百度地图在".$region."搜索".$query."的结果是：";
if (defined $rlt) {
	my $json_obj = JSON->new->allow_nonref;
	$json_obj->allow_singlequote;
	$json_obj->allow_barekey;
	my $rlt_decoded = $json_obj->decode($rlt);
	if(${${rlt_decoded}}{"status"} == 0) {
		my $cnt=0;
		foreach (@{${${rlt_decoded}}{"results"}}) {
			$cnt++;
			say $cnt.". name: ".${$_}{"name"};
			say "location: ".${${$_}{"location"}}{"lat"}.", "
				.${${$_}{"location"}}{"lng"} if(defined(${$_}{"location"}));
			say "address: ".${$_}{"address"} if(defined(${$_}{"address"}));
			say "telephone: ".${$_}{"telephone"} if(defined(${$_}{"telephone"}));
			say "";
		}
	} else {
		die "Error: ".${${rlt_decoded}}{"message"};
	}
} else {
	die "Couldn't get it!";
}
