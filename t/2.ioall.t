#!/usr/bin/env perl -w

use strict;
use Test::Simple tests => 1;
use IO::All;
use Graph;
use Graph::Writer::GraphViz;

my @v = qw/Alice Bob Crude Dr/;
my $g = Graph->new(@v);


my $wr = Graph::Writer::GraphViz->new(-format => 'dot');
my $io = io('$');
$wr->write_graph($g,$io);

my ($g1,$g2);
$io->seek(0,0);
$g2 = $io->slurp;

{
    local $/ = undef;
    $g1 = <DATA>;
}

ok($g1 eq $g2);

__DATA__
digraph test {
	node [label="\N"];
	graph [bb="0,0,290,52"];
	Alice [label=Alice, pos="30,26", width="0.83", height="0.50"];
	Bob [label=Bob, pos="105,26", width="0.75", height="0.50"];
	Crude [label=Crude, pos="184,26", width="0.94", height="0.50"];
	Dr [label=Dr, pos="263,26", width="0.75", height="0.50"];
}
