#!/usr/bin/env perl
use strict;

use Test::More tests => 1;

BEGIN {
    use_ok( 'Web::FileCheck' );
}

diag( "Testing Web::FileCheck $Web::FileCheck::VERSION, Perl $], $^X" );