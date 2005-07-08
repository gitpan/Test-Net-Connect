use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Test::Net::Connect',
    license             => 'bsd',
    dist_author         => 'Nik Clayton <nik@FreeBSD.org>',
    dist_version_from   => 'lib/Test/Net/Connect.pm',
    requires => {
		 'Test::More' => 0,
		 'Net::DNS' => 0,
		 'IO::Socket::INET' => 0,
    },
    add_to_cleanup      => [ 'Test-Net-Connect-*' ],
    sign		=> 1,
    create_readme	=> 1,
);

print <<EOM;

The automated tests need to be configured with host/port information
for a host that you expect to be able to connect to, and host/port
information for a host that you do not expect to be able to connect
to.

This is so that the tests can verify that the module is working
correctly.

EOM

my %config = ();

$builder->config_data(good_host => $builder->prompt('Please enter a hostname or IP address that you expect to be able
to connect to:', 'localhost'));

$builder->config_data(good_port => $builder->prompt('Please enter a port number on that host to connect to:', 22));

$builder->config_data(bad_host => $builder->prompt('Please enter a hostname or IP address that do not expect to be able
to connect to:', '127.0.0.2'));

$builder->create_build_script();
