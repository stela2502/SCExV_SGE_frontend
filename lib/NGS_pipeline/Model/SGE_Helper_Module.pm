package NGS_pipeline::Model::SGE_Helper_Module;

use strict;
use warnings;
use parent 'Catalyst::Model';
use stefans_libs::NGS_pipeline::SGE_helper;

sub new {
	my ( $class, $c, $args ) = @_;
	return stefans_libs::NGS_pipeline::SGE_helper->new();
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