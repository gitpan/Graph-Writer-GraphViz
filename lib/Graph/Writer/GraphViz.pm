package Graph::Writer::GraphViz;
use strict;
use IO::All;
use GraphViz;
use Graph::Writer;
use vars qw(@ISA);
@ISA = qw(Graph::Writer);

our $VERSION = '0.04';

# GraphViz Parameters
my %graph_param;
my @param_keys = qw/format layout ranksep shape fontsize arrowsize/;

sub _init  {
    my ($self,%param) = @_;
    $self->SUPER::_init();
    for(@param_keys) {
	$graph_param{$_} = $param{"-$_"}
	    if(defined $param{"-$_"});
    }
    $graph_param{format} ||= 'png';
}

sub _write_graph {
    my ($self, $graph, $FILE) = @_;
    my $grvz = $self->graph2graphviz($graph);
    my $as_fmt = 'as_' . $graph_param{format};
    if(ref($FILE) eq 'IO::All') {
	my $f = $grvz->$as_fmt;
	$FILE->append($f);
    } else {
	$grvz->$as_fmt($FILE);
    }
}

sub graph2graphviz {
    my ($self,$g) = @_;
    $graph_param{directed} = $g->directed;
    my $r = GraphViz->new(%graph_param);
    $self->add_nodes($r,$g);
    $self->add_edges($r,$g);
    return $r;
}

sub add_edges {
    my ($self,$r,$g) = @_;
    my @e = $g->edges;
    for my $i (0 .. @e/2-1) {
	my ($a,$b) = @e[2*$i , 2*$i + 1];
	my %param;
	if($g->has_attribute('weight',$a,$b)) {
	    my $w = $g->get_attribute('weight',$a,$b);
	    $param{label} = $w;
	}
	$r->add_edge($a,$b,%param);
    }
}

sub add_nodes {
    my ($self,$r,$g) = @_;
    my @v = $g->vertices;
    for (@v) {
	my %param;
	if($g->has_attribute('shape',$_)) {
	    my $w = $g->get_attribute('shape',$_);
	    $param{shape} = $w;
	}
	$r->add_node($_,%param) ;
    }
    return $r;
}


1;
__END__

=head1 NAME

Graph::Writer::GraphViz - GraphViz Writer for Graph object

=head1 SYNOPSIS


  my @v = qw/Alice Bob Crude Dr/;
  my $g = Graph->new(@v);

  my $wr = Graph::Writer::GraphViz->new(-format => 'dot');
  $wr->write_graph($g,'/tmp/graph.simple.dot');

  my $wr_png = Graph::Writer::GraphViz->new(-format => 'png');
  $wr_png->write_graph($g,'/tmp/graph.simple.png');

  Graph::Writer::GraphViz->new(
	-format => 'png',
	-layout => 'twopi',
	-ranksep => 1.5,
	-fontsize => 8
       )->write_graph($g,'/tmp/graph.png');

=head1 DESCRIPTION

B<Graph::Writer::GraphViz> is a class for writing out a Graph
object with GraphViz module. All GraphViz formats should
be supported without a problem.

=head1 METHODS

=head2 new()

Unlike other B<Graph::Writer> modules, this module provide an extra
parameter '-format' to new() method, in order to save different
format.  Other supported GraphViz parameters are -layout, -ranksep,
-shape, -fontsize, -arrowsize.  Please see the SYNOPSIS for example
usage.

Valid format depends on those GraphViz B<as_fmt> methods on your
system, like, 'gif' if you have 'as_gif', 'text' if you can do
'as_text'.

=head1 SEE ALSO

L<Graph>, L<Graph::Writer>, L<GraphViz>

=head1 COPYRIGHT

Copyright 2004 by Kang-min Liu <gugod@gugod.org>.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

See <http://www.perl.com/perl/misc/Artistic.html>

=cut
