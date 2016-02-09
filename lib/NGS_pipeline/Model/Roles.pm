package NGS_pipeline::Model::Roles;

use strict;
use warnings;
use parent 'Catalyst::Model';
use stefans_libs::database::scientistTable::roles;

sub new {
	my ( $class, $c, $args ) = @_;
	return roles->new( NGS_pipeline->get_my_db_object() , 0, $args);
}

=head1 NAME

Genexpress_catalist::Model::Roles - Catalyst Model

=head1 DESCRIPTION

Catalyst Model.

=head1 AUTHOR

Stefan Lang

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;