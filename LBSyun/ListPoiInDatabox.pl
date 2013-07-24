#!/usr/bin/perl
use warnings;
use strict;
use diagnostics;
use 5.010;

use LWP::Simple;
use JSON -support_by_pp;
use Encode qw/encode/;
use Unicode::Escape;

my $URL = "http://api.map.baidu.com/geodata/poi".
		"?method=list&databox_id=17393&ak=273dab0494b269c25bfce69526f0316d";
my $rlt = get($URL);
$rlt = encode("utf8", $rlt);	# 可恶的编码转换
say $rlt;

my $json_obj = JSON->new->allow_nonref;
$json_obj->allow_singlequote;
$json_obj->allow_barekey;
my $rlt_decoded = $json_obj->decode($rlt);
