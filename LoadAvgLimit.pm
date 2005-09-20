package Apache::LoadAvgLimit;

use strict;
use vars qw($VERSION);
use Apache;
use Apache::Constants qw(:common HTTP_SERVICE_UNAVAILABLE);
use Apache::LoadAvgLimit::GetAvg;

$VERSION = '0.01';

sub handler {
    my $r = shift;
    return DECLINED unless $r->is_initial_req;

    # get
    my @avg = Apache::LoadAvgLimit::GetAvg::get_loadavg()
        or $r->log_error("Cannot get load avg !")
        and return SERVER_ERROR;

    my $over = 0;
    if( (my $limit = $r->dir_config('LoadAvgLimit')) =~ /^[\d\.]{1,}$/ ){

	# at least one avg needs to be over the specified limit.
	for my $avg(@avg){
	    next if $avg <= $limit;
	    $over++;
	    last;
	}

    }else{

	my @limit;

	if( $r->dir_config('LoadAvgLimit_1') =~ /^[\d\.]{1,}$/ ){
	    $limit[0] = $r->dir_config('LoadAvgLimit_1')
	}

	if( $r->dir_config('LoadAvgLimit_5') =~ /^[\d\.]{1,}$/ ){
            $limit[1] = $r->dir_config('LoadAvgLimit_5')
	}

	if( $r->dir_config('LoadAvgLimit_15') =~ /^[\d\.]{1,}$/ ){
            $limit[2] = $r->dir_config('LoadAvgLimit_15')
	}

	# check
	for my $i(0..2){
	    next if not defined $limit[$i];
	    next if $avg[$i] <= $limit[$i];
	    $over++;
	    last;
	}

    }

    if( $over ){
	$r->log_reason("System load average reaches limit.", $r->filename);
	return HTTP_SERVICE_UNAVAILABLE;
    }

    return OK;
}

1;
__END__

=pod

=head1 NAME

Apache::LoadAvgLimit - limiting client request by system CPU load-averages

=head1 SYNOPSIS

  in httpd.conf, simply

  <Location /perl>
    PerlInitHandler Apache::LoadAvgLimit
    PerlSetVar LoadAvgLimit 2.50
  </Location>

  or fully

  <Location /perl>
    PerlInitHandler Apache::LoadAvgLimit
    PerlSetVar LoadAvgLimit_1 4.00
    PerlSetVar LoadAvgLimit_5 3.00
    PerlSetVar LoadAvgLimit_15 2.50
  </Location>

=head1 DESCRIPTION

If system load-average is over the value of B<LoadAvgLimit*>, Apache::LoadAvgLimit will try to reduce the machine load by returning HTTP status 503 (Service Temporarily Unavailable) to client browser.

Especially, it may be useful in <Location> directory that has heavy CGI, Apache::Registry script or contents-handler program.

=head1 PARAMETERS

B<LoadAvgLimit>

When at least one of three load-averages (1, 5, 15 min) is over this value, returning status 503.

B<LoadAvgLimit_1>, 
B<LoadAvgLimit_5>, 
B<LoadAvgLimit_15>

Each minute's load-averages (1, 5, 15 min) is over this value, returning status 503.

=head1 AUTHOR

Okamoto RYO <ryo@aquahill.net>

=head1 SEE ALSO

mod_perl(3), Apache(3), getloadavg(3), uptime(1)

=cut

