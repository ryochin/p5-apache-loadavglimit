#!/usr/bin/perl --
# subshell vs. system call bench for FreeBSD

use strict;
use Benchmark;
use Apache::LoadAvgLimit::GetAvg;
use Sys::Load;
use Shell qw(uptime);

timethese -5, {

  'Sys::Load' => sub {
    Sys::Load::getload
  },

  'LoadAvgLimit' => sub {
    Apache::LoadAvgLimit::GetAvg::get_loadavg
  },

  'uptime cmd' => sub {
    Shell::uptime
  }
}

=pod

=head1 ENV

  FreeBSD 5.2.1R w/ CPU: Intel(R) Pentium(R) 4 CPU 2.80GHz (2793.02-MHz 686-class CPU)

=head1 RESULTS

 Benchmark: running limit, shell, sys for at least 5 CPU seconds...
     limit:  6 wallclock secs ( 4.02 usr +  1.23 sys =  5.25 CPU) @ 152519.62/s (n=800728)
     shell: 18 wallclock secs ( 0.49 usr  4.73 sys +  1.20 cusr 11.95 csys = 18.37 CPU) @ 1001.96/s (n=5229)
       sys:  5 wallclock secs ( 2.06 usr +  2.94 sys =  5.00 CPU) @ 364485.20/s (n=1822426)

=cut
