#!/usr/bin/env perl
use strict;

use Test::More tests => 1;

my $file = './forward_modified_email.pl';

print "bail out! Script file is missing!" unless -e $file;

my $output = `$^X -c $file 2>&1`;

print "bail out! Script file does not compile!"
    unless like( $output, qr/syntax OK$/, 'script compiles' );

diag( "Testing forward_modified_email.pl, Perl $], $^X" );