#!/usr/bin/perl
use warnings;
use strict;
use diagnostics;
use 5.010;

use LWP::Simple;
use JSON -support_by_pp;
use Encode qw/encode/;
use Unicode::Escape;

my $waypoints = "118.77147503233,32.054128923368;116.3521416286,39.965780080447;116.28215586757,39.965780080447";
my $URL = "http://api.map.baidu.com/telematics/v2/distance?"
		."waypoints=".$waypoints
		."&output=json&ak=273dab0494b269c25bfce69526f0316d";
my $rlt = get($URL);
$rlt = encode("utf8", $rlt);	# 可恶的编码转换

my $json_obj = JSON->new->allow_nonref;
$json_obj->allow_singlequote;
$json_obj->allow_barekey;
my $rlt_decoded = $json_obj->decode($rlt);
my $cnt = 0;
foreach(split(/;/, $waypoints)) {
	$cnt++;
	say "第".$cnt."点的经纬度: ".$_;
}
say "";
if(${${${rlt_decoded}}{"result"}}{"error"} == 0) {
	my $cnt = 0;
	foreach (@{${$rlt_decoded}{"results"}}) {
		$cnt++;
		say "第".$cnt."个点到第".($cnt+1)."个点的距离: ".$_."m";
	}
} else {
	say "Error: 返回结果错误!!";
}
