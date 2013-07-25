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
$URL = "http://api.go2map.com/engine/api/search/json?"
		."what=keyword:".$query
		."&range=city:".$region
		."&contenttype=utf8";
my $rlt = get($URL);
$rlt = encode("utf8", $rlt);	# 可恶的编码转换
# say $rlt;
my $json_obj = JSON->new->allow_nonref;
$json_obj->allow_singlequote;
$json_obj->allow_barekey;
my $rlt_decoded = $json_obj->decode($rlt);

say "使用搜狗地图在".$region."搜索".$query."的搜索结果是:";
my $cnt = 0;
foreach (@{${${${$rlt_decoded}{"response"}}{"data"}}{"feature"}}) {
	$cnt++;
	say "******".$cnt."******";
	say "名称: ".${$_}{"caption"} if defined ${$_}{"caption"};
	say "地址: ".${${$_}{"detail"}}{"address"} if defined ${$_}{"detail"};
	say "别名: ".${$_}{"alias"} if defined ${$_}{"alias"};
	say "Points: ".${${$_}{"points"}}{"txt"} if defined ${$_}{"points"};
	say "";
}
