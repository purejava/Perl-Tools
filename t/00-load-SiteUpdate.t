#!/usr/bin/env perl
use strict;

use Test::More tests => 1;

BEGIN {
    use_ok( 'Web::SiteUpdate' );
}

diag( "Testing Web::SiteUpdate $Web::SiteUpdate::VERSION, Perl $], $^X" );