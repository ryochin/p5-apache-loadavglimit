#!/usr/bin/perl 

use strict;

my @avg = &get_loadavg();

warn join ':', @avg;


sub get_loadavg {

  my $uptime = qx( `which uptime` )
    or return;
  chomp $uptime;

  my @avg;
  if( $^O eq 'freebsd' or $^O eq 'Darwin' ){
    # load averages: 0.18, 0.15, 0.16 
    if( $uptime =~ s/^.+?load averages: ([\d\.\s\,]+?)$/$1/o ){
      @avg = split /[\s\,]+/, ,$uptime;
    }
  }elsif( $^O eq 'linux' or $^O eq 'solaris' ){
    # load average: 0.00, 0.00, 0.00
    if( $uptime =~ s/^.+?load average: ([\d\.\s\,]+?)$/$1/o ){
      @avg = split /[\s\,]+/, ,$uptime;
    }
  }else{
    # mmm..
    if( $uptime =~ s/^.*?([\d\.]{4},\s*?[\d\.]{4},\s*?[\d\.]{4}).*?$/$1/o ){
      @avg = split /[\s\,]+/, ,$uptime;
    }
  }

  return wantarray ? @avg : \@avg;
}

