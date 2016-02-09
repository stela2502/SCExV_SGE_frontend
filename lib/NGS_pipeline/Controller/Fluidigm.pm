package NGS_pipeline::Controller::Fluidigm;

use namespace::autoclean;
use Moose;
use NGS_pipeline::base_db_controler;
with 'NGS_pipeline::base_db_controler';
BEGIN { extends 'Catalyst::Controller' }


=head1 NAME

NGS_pipeline::Controller::dna_seq - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

sub index  : Local  Form  {
    my ( $self, $c ) = @_;
    my $ok;
	$c->check_IP( '127.0.0.1', '130.235.165.71' );
	$c->form->method('post');
	$c->form->field(
			'comment' => 'filename',
			'name'    => 'filename',
			'type'    => 'file',
			'required' => 1,
	);
	$c->form->field(
			'comment' => 'key',
			'name'    => 'key',
			'type'    => 'text',
			'required' => 1,
	);
	$c->form->field(
			'comment' => 'session',
			'name'    => 'session',
			'type'    => 'text',
			'required' => 1,
	);
	$c->form->field(
			'comment' => 'rpage',
			'name'    => 'rpage',
			'type'    => 'text',
			'required' => 1,
	);
	$c->stash->{'message'} = 'This is not meant to be used by a human - please do not upload anything!';
	if ( $c->form->submitted  ){
		my $dataset = $self->__process_returned_form($c);
		## check the file
		my $upload  = $c->req->uploads->{'filename'};
		( $ok, $c->stash->{'error'} ) = $c->model('Fluidigm_Helper') -> register_RandomForest_job ($c, $dataset, $upload );
		unless ( $ok ){
			$c->stash->{'error'} .= "FluidigmController : An error has occured!\n";
			$c->stash->{'template'}   = 'Form.tt2';
			$c->detach();
		}
		else {
			$c->stash->{'template'}   = 'message.tt2';
			$c->stash->{'error'} .= " Done!";
			$c->detach();
		}
	}
	$c->stash->{'template'}   = 'Form.tt2'; 
}



=head1 AUTHOR

Stefan Lang

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut


1;
