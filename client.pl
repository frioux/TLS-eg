#!/usr/bin/env perl

use strict;
use warnings;

use IO::Async::Loop;
use IO::Socket::SSL;
use Net::Async::HTTP;

my $loop = IO::Async::Loop->new;

$loop->add(
   my $ua = Net::Async::HTTP->new(
      SSL_key_file => 'client.key',
      SSL_cert_file => 'client.pem',
      SSL_ca_file => 'rootCA.pem',
      SSL_verify_mode => SSL_VERIFY_NONE,
   )
);

my $res = $ua->GET('https://localhost:8000/serial')->get;

print $res->decoded_content;
