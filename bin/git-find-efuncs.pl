#!/usr/bin/env perl
# vim: ft=perl ts=4 sts=0 sw=4 noet ai fenc=utf-8 ff=unix eol
# License: GPLv2, https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html
use strict;
use utf8;
binmode STDIN, ':utf8';
binmode STDOUT, ':utf8';
binmode STDERR, ':utf8';
BEGIN{if(0){
		use Data::Dumper qw'Dumper';
	}else{
		use YAML;
		sub Dumper {return YAML::Dump(@_);};
}};

=pod

Finds Elixir function definitions changed since the current branch diverged from staging

=cut

my $range_spec = 'staging..HEAD'; # TODO use one of the getopt modules to allow setting this
my @git_args = ('log', '-p', '-G', 'defp?', $range_spec, '--');

sub identify_file($){return((shift @_) =~ m/\A\+\+\+\s*b\/(.*)\z/o)[0];};
sub identify_def($){return((shift @_) =~ m/\A([+-])\s*(defp? .*?)\s*(?:do|,)\s*\z/o);};

my $file_funcs = {};
my $current_filename;
open(my $git_child, '-|:utf8', 'git', @git_args);
while(my $line = <$git_child>){
	chomp $line;
	if(my $filename = identify_file($line)){
		unless(ref($file_funcs->{$filename}) eq 'HASH'){$file_funcs->{$filename} = {};};
		$current_filename = $filename;
		next;
	}
	if(my @result = identify_def($line)){
		$file_funcs->{$current_filename}->{@result[1]} = @result[0];
	}
}
close($git_child);
print STDOUT Dumper($file_funcs), "\n";
