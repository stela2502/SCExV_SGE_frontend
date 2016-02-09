package NGS_pipeline::Model::OType_2_Action;
use Moose;
use namespace::autoclean;

extends 'Catalyst::Model';
use stefans_libs::database::otype_2_CatalystAction;

=head1 NAME

NGS_pipeline::Model::OType_2_Action - Catalyst Model

=head1 DESCRIPTION

Catalyst Model.

=head1 AUTHOR

Stefan Lang

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

sub new {
	my ( $app, @arguments ) = @_;
	return stefans_libs::database::otype_2_CatalystAction->new( NGS_pipeline->get_my_db_object('standard') ,0, @arguments );
}


__PACKAGE__->meta->make_immutable;

1;
