package Log::Any::For::LWP;

use 5.010;
use strict;
use warnings;
use Log::Any '$log';

# VERSION

use Net::HTTP::Methods::patch::log_request qw();
use LWP::UserAgent::patch::log_response    qw();

my %opts;

sub import {
    my $self = shift;
    %opts = @_;
    $opts{-log_request}         //= 1;
    $opts{-log_response_header} //= 1;
    $opts{-log_response_body}   //= 0;

    Net::HTTP::Methods::patch::log_request->import()
          if $opts{-log_request};
    LWP::UserAgent::patch::log_response->import(
        -log_response_header => $opts{-log_response_header},
        -log_response_body   => $opts{-log_response_body},
    );
}

sub unimport {
    LWP::UserAgent::patch::log_response->unimport();
    Net::HTTP::Methods::patch::log_request->unimport()
          if $opts{-log_request};
}

1;
# ABSTRACT: Add logging to LWP

=head1 SYNOPSIS

 use Log::Any::For::LWP
     -log_request         => 1, # optional, default 1
     -log_response_header => 1, # optional, default 1
     -log_response_body   => 1, # optional, default 0
 ;

Sample script and output:

 % TRACE=1 perl -MLog::Any::App -MLog::Any::For::LWP -MLWP::Simple \
   -e'get "http://www.google.com/"'
 [36] HTTP request (proto=http, len=134):
 GET / HTTP/1.1
 TE: deflate,gzip;q=0.3
 Connection: TE, close
 Host: www.google.com
 User-Agent: LWP::Simple/6.00 libwww-perl/6.04

 [79] HTTP response header:
 302 Moved Temporarily
 Cache-Control: private
 Connection: close
 Date: Tue, 17 Jul 2012 04:39:10 GMT
 ...

 [81] HTTP request (proto=http, len=136):
 GET / HTTP/1.1
 TE: deflate,gzip;q=0.3
 Connection: TE, close
 Host: www.google.co.id
 User-Agent: LWP::Simple/6.00 libwww-perl/6.04

 [190] HTTP response header:
 200 OK
 Cache-Control: private, max-age=0
 Connection: close
 Date: Tue, 17 Jul 2012 04:39:10 GMT
 ...


=head1 SEE ALSO

L<Log::Any>


