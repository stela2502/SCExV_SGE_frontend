package NGS_pipeline::Controller::utilities;

use namespace::autoclean;

use Moose;
use NGS_pipeline::base_db_controler;
with 'NGS_pipeline::base_db_controler';

BEGIN { extends 'Catalyst::Controller' }

=head1 NAME

NGS_pipeline::Controller::utilities - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Local  {
    my ( $self, $c ) = @_;
	$self->__check_user( $c );
	
    $c->response->body('Matched NGS_pipeline::Controller::utilities in utilities.');
}


=head1 AUTHOR

Stefan Lang

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut


1;
