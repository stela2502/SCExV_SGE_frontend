package NGS_pipeline::Controller::debug;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

NGS_pipeline::Controller::debug - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Local :Form {
    my ( $self, $c ) = @_;
	unless ( $ENV{'CATALYST_DEBUG'} ){
		$self->res->redirect($c->uri_for('/access_denied'));
		$self->detach();
	}
    ## here I copy the reciever logics from the NGS server
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
			'comment' => 'returnpage',
			'name'    => 'returnpage',
			'type'    => 'text',
			'required' => 1,
	);
	$c->stash->{'message'} = 'This is not meant to be used by a human - please do not upload anything!';
	if ( $c->form->submitted  ){
		my $dataset = $self->__process_returned_form($c);
		## check the file
		my $upload  = $c->req->uploads->{'filename'};
		my $path = $c->config->{'shared_path'} ;
		$path ||= $c->config->{'root'};
		$path.= "/fluidigm_auto/";
		mkdir ( $path ) unless ( -d $path );
		$path.= join("_",split(/[:\-\s]/,$c->model('ACL')->NOW()))."/";
		mkdir ( $path ) unless ( -d $path );
		$upload->copy_to( $path. $upload->filename );
		my $md5 = $self->file2md5str( $path. $upload->filename );
		unless ( $md5 eq $dataset->{'key'} ) {
			$c->stash->{'error'} = "Possible error here - md5 sum does not match! ($md5)";
			$c->stash->{'template'}   = 'message.tt2';
			$c->detach();
		}
		else {
			
			chdir( $path );
			system ( 'tar -zxf '. $upload->filename ) if ( $upload->filename =~ m/tar.gz$/);
			system ( 'unzip '. $upload->filename ) if ( $upload->filename =~ m/.zip$/);
			unless ( -f $path.'RandomForestStarter.sh' ){
				$c->stash->{'error'} = "The required script file is missing!";
				$c->stash->{'template'}   = 'message.tt2';
				$c->detach();
			}
			else {
				## create the qsub sript
				my $script = $c->model( 'SGE_Helper_Module') -> qsub_head({ 'proc' => 32, 'memfree' => '1GB' } ).
				'/bin/bash/' ." $path"."RandomForestStarter.sh\n";
				my $fn = "$path"."RandomForestStarter.sh";
				open ( OUT ,">$fn" );
				print OUT $script;
				close ( OUT );
				my $work_id = $c->model('work')->AddDataset(
				{
					'username' => 'Fluidigm',
					'module'   => 'Random Forest Calculation',
					'info1'    => $self->req->address().$dataset->{'returnpage'},
					'info2'    => $dataset->{'session'},
					'script' => $fn,
				}
			);
			}
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

__PACKAGE__->meta->make_immutable;

1;
