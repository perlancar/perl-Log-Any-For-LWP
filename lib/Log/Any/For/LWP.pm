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

 % TRACE=1 perl -MLog::Any::App -MLog::Any::For::LWP \
   -e'get "http://www.google.com/"'


=head1 SEE ALSO

L<Log::Any>


