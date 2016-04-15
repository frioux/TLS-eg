#!/usr/bin/env perl

use strict;
use warnings;

use IO::Socket::SSL;
my $server = IO::Socket::SSL->new(
    LocalAddr => '0.0.0.0',
    LocalPort => 8000,
    Listen => 10,

    # which certificate to offer
    # with SNI support there can be different certificates per hostname
    SSL_cert_file => 'web.pem',
    SSL_key_file => 'web.key',
    SSL_verify_mode => SSL_VERIFY_PEER | SSL_VERIFY_FAIL_IF_NO_PEER_CERT,
) or die "failed to listen: $!";

# accept client
my $client = $server->accept or die
    "failed to accept or ssl handshake: $!,$SSL_ERROR";
