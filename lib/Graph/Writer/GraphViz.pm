package Graph::Writer::GraphViz;
use strict;
use IO::All;
use GraphViz;
use Graph::Writer;
use vars qw(@ISA);
@ISA = qw(Graph::Writer);

our $VERSION = '0.03';

my $format = 'png';

sub _init  {
    my ($self,%param) = @_;
    $self->SUPER::_init();
    $format = $param{-format} || 'png';
}

sub _write_graph {
    my ($self, $graph, $FILE) = @_;
    my $grvz = $self->graph2graphviz($graph);
    my $as_fmt = 'as_' . $format;
    if(ref($FILE) eq 'IO::All') {
	my $f = $grvz->$as_fmt;
	$FILE->append($f);
    } else {
	$grvz->$as_fmt($FILE);
    }
}

sub graph2graphviz {
    my ($self,$g) = @_;
    my $r = GraphViz->new(directed=>$g->directed);
    my @v = $g->vertices;
    $r->add_node($_) for @v;
    my @e = $g->edges;
    for my $i (0 .. @e/2-1) {
	my ($a,$b) = @e[2*$i , 2*$i + 1];
	if($g->has_attribute('weight',$a,$b)) {
	    my $w = $g->get_attribute('weight',$a,$b);
	    $r->add_edge($a,$b,label=>$w);
	} else {
	    $r->add_edge($a,$b);
	}
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

=head1 DESCRIPTION

B<Graph::Writer::GraphViz> is a class for writing out a Graph
object with GraphViz module. All GraphViz formats should
be supported without a problem.

=head1 METHODS

=head2 new()

Unlike other B<Graph::Writer> modules, this module
provide an extra parameter '-format' to new() method,
in order to save different format. Please see
the SYNOPSIS for example usage.

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
