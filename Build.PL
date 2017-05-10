use strict;
use warnings;
use Module::Build;

# NOTE: This Build.PL is to make it easier for people without dzil
# to install dependencies/etc. It may be out of sync with dist.ini
# and dist_version needs to be manually updated, for now.

my $builder = Module::Build->new(
    module_name         => 'Web::FileCheck',
    license             => 'perl',
    dist_author         => 'Ralph Plawetzki <ralph@purejava.org>',
    dist_abstract       => 'Check for files on a server',
    dist_version        => '0.01',
    include_dirs        => '',
    build_requires => {
        'Test::More'      => 0,
        'Test::Exception' => 0,
    },
    configure_requires => { 'Module::Build' => 0.38 },
    requires => {
        'Mail::SendEasy'   => '1.2',
        'perl'            => '5.008',
    },
    add_to_cleanup      => [ 'Web-FileCheck-*' ],
    meta_merge     => {
        resources => {
            repository  => 'http://github.com/purejava/Perl-Tools/tree/master'
        },
    },
);

$builder->create_build_script();
print "Have a great day!\n";