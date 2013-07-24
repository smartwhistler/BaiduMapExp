#!/usr/bin/perl
use warnings;
use strict;
use diagnostics;
use 5.010;

use LWP::Simple;
use JSON -support_by_pp;
use Encode qw/encode/;
use Unicode::Escape;

my ${origin} = "科大讯飞信息科技公司";
my ${originregion} = "合肥";
my ${destination} = "合肥工业大学";
my ${destinationregion} = "合肥";
my ${waypoints} = "百脑汇";
my ${mode} = "driving";

my $URL = "http://api.map.baidu.com/direction/v1?"
		."mode=".${mode}
		."&origin=".${origin}."&destination=".${destination}
		."&origin_region=".${originregion}
		."&destination_region=".${destinationregion}
		."&waypoints=".${waypoints}
		."&output=json&ak=273dab0494b269c25bfce69526f0316d";
my $rlt = get($URL);
$rlt = encode("utf8", $rlt);	# 可恶的编码转换，返回的导航结果是ascii编码，经过utf8编码后，并没有变化。

say "******百度地图路径规划******";
say "从 ".$originregion." 的 ".$origin." 导航到 ".$destinationregion." 的 ".$destination."，途径".${waypoints}.":";

if (defined $rlt) {
	my $json_obj = JSON->new->allow_nonref;
	$json_obj->allow_singlequote;
	$json_obj->allow_barekey;
	my $rlt_decoded = $json_obj->decode($rlt);
	if(${${rlt_decoded}}{"status"} == 0) {
		if (defined(${${${rlt_decoded}}{"result"}}{"origin"})) {
			say "###起点###";
			my $ref_origin = ${${${rlt_decoded}}{"result"}}{"origin"};
			print Unicode::Escape::unescape(${${ref_origin}}{"cname"}) if defined (${${ref_origin}}{"cname"});
			print " ".Unicode::Escape::unescape(${${ref_origin}}{"wd"}) if defined (${${ref_origin}}{"wd"});
			print " ".${${${ref_origin}}{"originPt"}}{"lng"}.",".${${${ref_origin}}{"originPt"}}{"lat"}
				if defined (${${ref_origin}}{"originPt"});
			say "";
		}
		say "";
		if (defined(${${${rlt_decoded}}{"result"}}{"destination"})) {
			say "###终点###";
			my $ref_dest = ${${${rlt_decoded}}{"result"}}{"destination"};
			print Unicode::Escape::unescape(${${ref_dest}}{"cname"}) if defined (${${ref_dest}}{"cname"});
			print " ".Unicode::Escape::unescape(${${ref_dest}}{"wd"}) if defined (${${ref_dest}}{"wd"});
			print " ".${${${ref_dest}}{"destinationPt"}}{"lng"}.",".${${${ref_dest}}{"destinationPt"}}{"lat"}
				if defined (${${ref_dest}}{"destinationPt"});
			say "";
		}
		say "";
		if (defined(${${${rlt_decoded}}{"result"}}{"taxi"})) {
			say "###出租车###";
			my $ref_taxi = ${${${rlt_decoded}}{"result"}}{"taxi"};
			say "距离: ".${${ref_taxi}}{"distance"}."米" if defined(${${ref_taxi}}{"distance"});
			say "时间: ".${${ref_taxi}}{"duration"}."s" if defined(${${ref_taxi}}{"duration"});
			say "remark: ".Unicode::Escape::unescape(${${ref_taxi}}{"remark"}) if defined(${${ref_taxi}}{"remark"});
			say "详情:";
			if(defined(${${ref_taxi}}{"detail"})) {
				my $cnt=0;
				foreach(@{${${ref_taxi}}{"detail"}}) {
					$cnt++;
					print $cnt.". ";
					say "描述:".Unicode::Escape::unescape${$_}{"desc"};
					say "每公里价格:".Unicode::Escape::unescape${$_}{"km_price"};
					say "起步价:".Unicode::Escape::unescape${$_}{"start_price"};
					say "总价钱:".Unicode::Escape::unescape${$_}{"total_price"};
				}
			}
		}
		say "";
		if (defined(${${${rlt_decoded}}{"result"}}{"routes"})) {
			my $cnt=0;
			say "###导航###";
			foreach(@{${${${rlt_decoded}}{"result"}}{"routes"}}) {
				$cnt++;
				say "步骤".$cnt.":";
				say "从 ".${${$_}{"originLocation"}}{"lng"}.",".${${$_}{"originLocation"}}{"lat"}
					." 到 ".${${$_}{"destinationLocation"}}{"lng"}.",".${${$_}{"destinationLocation"}}{"lat"}." 的距离"
	 				if defined ${$_}{"originLocation"} and defined ${$_}{"destinationLocation"};
				say "距离:".${$_}{"distance"}."米" if defined(${$_}{"distance"});
				say "时间:".${$_}{"duration"}."s" if defined(${$_}{"duration"});
				if(${$_}{"steps"}) {
					foreach(@{${$_}{"steps"}}) {
						if (defined ${$_}{"instructions"}) {
							my $instr = Unicode::Escape::unescape${$_}{"instructions"};
							$instr =~ s/<.*?>//g;
							say $instr;
						}
						if(length(${$_}{"stepOriginInstruction"}) > 0) {
							say "单步起点:".Unicode::Escape::unescape${$_}{"stepOriginInstruction"};
						}
						if(length(${$_}{"stepDestinationInstruction"}) > 0) {
							say "单步终点:".Unicode::Escape::unescape${$_}{"stepDestinationInstruction"};
						}
					}
				}
			}
		}
	} else {
		die "Error: ".${${rlt_decoded}}{"message"};
	}
} else {
	die "Couldn't get it!";
}
