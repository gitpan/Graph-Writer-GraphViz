
use inc::Module::Install;

name            ('Graph-Writer-GraphViz');
abstract        ('Use GraphViz to render Graph.');
author          ('Kang-min Liu (gugod@gugod.org)');
license         ('perl');
version_from    ('lib/Graph/Writer/GraphViz.pm');
requires        ('IO::All' => 0.30);
requires        ('GraphViz');
requires        ('Graph::Writer');

&WriteAll;

