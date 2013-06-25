package Apache::LoadAvgLimit::GetAvg;

use strict;
use vars qw($VERSION @ISA @EXPORT_OK);

require Exporter;
require DynaLoader;
require AutoLoader;

@ISA = qw(Exporter DynaLoader);
@EXPORT_OK = qw( get_loadavg );

$VERSION = '0.03';

bootstrap Apache::LoadAvgLimit::GetAvg $VERSION;

1;
__END__

