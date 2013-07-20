#!/usr/bin/perl
use 5.010;
use strict;
use warnings;

if(defined($ARGV[0])) {
	open(POI_TAG, "<".$ARGV[0]);
} else {
	open(POI_TAG, "<"."BaiduMap_tag.txt");
}
my @poi_tag_lines = <POI_TAG>;
chomp(@poi_tag_lines);
close(POI_TAG);

my %topleveltag_reftosubtag;
my $RefToRefOf__topleveltag_reftosubtag;	# 引用的引用
my $RefToRefOf__tag_reftosubtag;			# 引用的引用

foreach(@poi_tag_lines) {
	if(m/^[\t]{0}[^\t]/) {
		$RefToRefOf__topleveltag_reftosubtag = \$topleveltag_reftosubtag{$_};
	} elsif(m/^[\t]{1}[^\t]/) {
		$_ =~ s/^[\t]{1}([^\t].*)/$1/;
		$RefToRefOf__tag_reftosubtag = \${${$RefToRefOf__topleveltag_reftosubtag}}{$_};
	} elsif(m/^[\t]{2}[^\t]/) {
		$_ =~ s/^[\t]{2}([^\t].*)/$1/;
		undef ${${$RefToRefOf__tag_reftosubtag}}{$_};
	} else {
		die "格式错误: ".$_;
	}
}

# 用递归实现更好，不过懒得搞
foreach (keys(%topleveltag_reftosubtag)) {
	my $level1_tagname = $_;
	my $reftosubtag;
	if(defined(${topleveltag_reftosubtag}{$_})) {
		$reftosubtag = ${topleveltag_reftosubtag}{$_};
		foreach(keys(%{${reftosubtag}})) {
			my $level2_tagname = $_;
			my $reftosubsubtag;
			if(defined(${$reftosubtag}{$_})) {
				$reftosubsubtag = ${$reftosubtag}{$_};
				foreach(keys(%{${reftosubsubtag}})) {
					my $level3_tagname = $_;
					say $level1_tagname . "->" . $level2_tagname . "->" . $level3_tagname;
				}
			} else {
				say $level1_tagname . "->" . $level2_tagname;
			}
		}
	} else {
		say $level1_tagname;
	}
}
