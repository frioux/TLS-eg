#!/usr/bin/env perl

use strict;
use warnings;

use IO::Async::Loop;
use IO::Async::SSL;
use IO::Async::SSLStream;
use IO::Socket::SSL;
use Net::Async::HTTP::Server::PSGI;
use Plack::App::Directory;

my $loop = IO::Async::Loop->new;
my $handler = Net::Async::HTTP::Server::PSGI->new(
   app => Plack::App::Directory->new({ root => '.' }),
);

$loop->add($handler);
$handler->listen(
   extensions => ['SSL'],
   SSL_key_file => 'web.key',
   SSL_cert_file => 'web.pem',
   SSL_verify_mode => SSL_VERIFY_PEER,
   SSL_ca_file => 'rootCA.pem',
   host => '0.0.0.0',
   service => 8000,
   socktype => 'stream',
   on_listen_error => sub { die $_[1] },
   on_resolve_error => sub { die $_[1] },
   on_listen => sub {
      my $h = shift->read_handle;
      print STDERR 'listening on ' . $h->sockhost . ':' . $h->sockport . "\n";
   },
);

$loop->run
