package NGS_pipeline::Controller::experiments;

use namespace::autoclean;

use Moose;
use NGS_pipeline::base_db_controler;
with 'NGS_pipeline::base_db_controler';

BEGIN { extends 'Catalyst::Controller' }

=head1 NAME

NGS_pipeline::Controller::experiments - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

sub index : Local : Args(0) {
	my ( $self, $c ) = @_;
	$self->__check_user($c);

	my $work          = $c->model('work');
	my $all_processes = $work->get_processes_for_user( $c->user() );
	$all_processes->calculate_on_columns(
		{
			'data_column'   => 'id',
			'target_column' => 'id',
			'function'      => sub {
				return "<a href='"
				  . $c->uri_for("/experiments/details/")
				  . $_[0]
				  . "'>$_[0]</a>";
			  }
		}
	);
	$c->stash->{'message'} = 'Here you see your last jobs (max =100).';

	$c->stash->{'text'}     = $all_processes->AsHTML();
	$c->stash->{'template'} = 'message.tt2';
}

sub details : Local {
	my ( $self, $c, $work_id ) = @_;
	my $ofile = $c->model('ofile');
	my $t     = $ofile->get_data_table_4_search(
		{
			'search_columns' => [
			ref($ofile) . '.id',
				'workload.module',
				ref($ofile) . '.type',
				ref($ofile) . '.file',
			],
			'where' => [
				[ 'md5sum',      '!=', 'my_value' ],
				[ 'workload.id', '=',  'my_value' ]
			],
		},
		'file not found',
		$work_id
	);
	$t->Remove_from_Column_Names('workload.');
	$t->Remove_from_Column_Names( ref($ofile) . '.' );

	#create a Download and a view link
	my $r = data_table->new();
	$r->Add_2_Header( [ 'type', 'filename', 'View', 'Download' ] );
	foreach ( @{ $t->GetAll_AsHashArrayRef() } ) {
		my @file = split( "/", $_->{'file'} );
		my $hash = {
			'type'     => $_->{'type'},
			'filename' => $file[-1],
			'Download' => "<a href='"
			  . $c->uri_for("/html_view/download/")
			  . $_->{'file'}
			  . "', target='_blank'>download</a>"
		};
		if ( defined $c->otype_2_action( $_->{'module'}, $_->{'type'} ) ) {
			$hash->{'View'} =
			  "<a href='"
			  . $c->uri_for(
				$c->otype_2_action( $_->{'module'}, $_->{'type'} ) )
			  . $_->{'id'}
			  . "', target='_blank'>view</a>";
		}
		$r->AddDataset($hash);
	}
	$c->stash->{'text'}     = $r->AsHTML();
	$c->stash->{'template'} = 'message.tt2';
}

=head1 AUTHOR

Stefan Lang

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
