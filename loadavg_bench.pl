#!/usr/local/bin/perl --
# subshell vs. system call bench for FreeBSD

use strict;
use Benchmark;
use Apache::LoadAvgLimit::GetAvg;
use Sys::Load;

timethese -1, {
  'LoadAvgLimit' => sub {
    my @avg = Apache::LoadAvgLimit::GetAvg::get_loadavg;
    return 1;
  },

  'Sys::Load' => sub {
    my @avg = Sys::Load::getload;
     return 1;
  },

  'uptime cmd' => sub {
    my $avg = qx( uptime );
    $avg =~ s@^.+?load average[s]*: (.+?)$@$1@;
    my @avg = split ', ', $avg;
    return 1;
  },
};

