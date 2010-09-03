package TestAppCPPN::Controller::Root;
use parent 'Catalyst::Controller';
use strict;
use warnings;

__PACKAGE__->config( 'namespace', '' );

sub get_params : Local Args {
	my ( $self, $c, @args ) = @_;
	$c->res->body('Nothing to see here, steal my context and move along.');
}

## Silence: [error] No default action defined
sub default :Private { 1 }

1;
