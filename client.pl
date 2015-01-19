#!/usr/bin/env perl

use strict;
use warnings;

use IO::Async::Loop;
use Net::Async::HTTP;

my $loop = IO::Async::Loop->new;

$loop->add(
   my $ua = Net::Async::HTTP->new(
      SSL_key_file => 'web.key',
      SSL_cert_file => 'web.pem',
      SSL_ca_file => 'rootCA.pem',
   )
);

print $ua->GET('https://localhost:8000/serial')->get->decoded_content;
