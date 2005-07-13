use Test::Tester;
use Test::More qw(no_plan);

BEGIN {
use_ok( 'Test::Net::Connect' );
use_ok( 'Test::Net::Connect::ConfigData' );
}

my $good_parms = { host => Test::Net::Connect::ConfigData->config('good_host'),
		   port => Test::Net::Connect::ConfigData->config('good_port'),
		   proto => 'tcp' };

my $bad_parms = { host => Test::Net::Connect::ConfigData->config('bad_host'),
		  port => 25,
		  proto => 'tcp' };

my $v = $good_parms;

check_test(sub { connect_ok( $v, "Check host:port from user"); },
	   { ok => 1, name => "Check host:port from user",
	     diag => '', },
	   "Basic call with all arguments succeeds");

$v = $good_parms;
delete $v->{proto};

check_test(sub { connect_ok( $v, "Check host:port from user"); },
	   { ok => 1, name => "Check host:port from user" },
	   "Basic call with default proto arguments succeeds");

$v = $good_parms;
delete $v->{proto};
$v->{host} .= ':' . $v->{port};
delete $v->{port};

check_test(sub { connect_ok( $v, "Check host:port from user"); },
	   { ok => 1, name => "Check host:port from user" },
	   "Basic call with default proto and host:port form succeeds");

# Things that should fail

# Failing because the params are wrong

check_test(sub { connect_ok(); },
	   { ok => 0, name => 'connect_ok()',
	     diag => '    connect_ok() called with no arguments' },
	   "connect_ok()");

check_test(sub { connect_ok('localhost'); },
	   { ok => 0, name => 'connect_ok()',
	     diag => '    First argument to connect_ok() must be a hash ref'},
	   "connect_ok(SCALAR)");

check_test(sub { connect_ok('localhost', 'test name'); },
	   { ok => 0, name => 'test name',
	     diag => '    First argument to connect_ok() must be a hash ref'},
	   "connect_ok(SCALAR, SCALAR)");

check_test(sub { connect_ok({ port => 22 }); },
	   { ok => 0, name => 'connect_ok()',
	     diag => '    connect_ok() called with no hostname'},
	   "connect_ok() with no host name");

check_test(sub { connect_ok({ host => undef }); },
	   { ok => 0, name => 'connect_ok()',
	     diag => '    connect_ok() called with no hostname'},
	   "connect_ok() with undef host name");

check_test(sub { connect_ok({ host => '' }); },
	   { ok => 0, name => 'connect_ok()',
	     diag => '    connect_ok() called with no hostname'},
	   "connect_ok() with undef host name");

check_test(sub { connect_ok({ host => '' }, 'test name'); },
	   { ok => 0, name => 'test name',
	     diag => '    connect_ok() called with no hostname'},
	   "connect_ok() with undef host name");

$v = $good_parms;
delete $v->{port};
delete $v->{proto};

check_test(sub { connect_ok($v); },
	   { ok => 0, name => 'connect_ok()',
	     diag => '    connect_ok() called with no port' },
	   "connect_ok() with no port");

$v->{port} = '';

check_test(sub { connect_ok($v); },
	   { ok => 0, name => 'connect_ok()',
	     diag => '    connect_ok() called with no port' },
	   "connect_ok() with no port");

check_test(sub { connect_ok($v, 'test name'); },
	   { ok => 0, name => 'test name',
	     diag => '    connect_ok() called with no port' },
	   "connect_ok() with no port");

check_test(sub { connect_ok({ host => 'localhost', port => 25, foo => 'bar'} ); },
	   { ok => 0, name => 'Connecting to tcp://localhost:25',
	     diag => "    Invalid field 'foo' given" },
	   "connect_ok() with key 'foo'");

# Failing because the host is not reachable

$v = $bad_parms;

check_test(sub { connect_ok($v, "Connect with a bad host"); },
	   { ok => 0, name => "Connect with a bad host", },
	   "Connecting to a non-existent host");




