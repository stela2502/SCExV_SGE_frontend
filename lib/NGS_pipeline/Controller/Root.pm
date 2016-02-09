package NGS_pipeline::Controller::Root;
use Moose;
use namespace::autoclean;
use POSIX;

use NGS_pipeline::base_db_controler;
with 'NGS_pipeline::base_db_controler';
BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config( namespace => '' );

=head1 NAME

NGS_pipeline::Controller::Root - Root Controller for NGS_pipeline

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

sub index : Path : Args(0) {
	my ( $self, $c ) = @_;
	my $path = $c->config->{'root'} . "/tmp/";
	$c->model('Menu')->Reinit();

	unless ( defined $c->session->{'known'} ) {
		$c->session->{'known'} = 0;
	}
	elsif ( $c->session->{'known'} == 0 ) {
		$c->session->{'known'} = 1;
	}

   #Carp::confess( "find ".$path." -maxdepth 1 -mtime +1 -exec rm -Rf {} \\;" );
	## this position can be used to upload the files!
	$c->stash->{'uploadPage'} = $c->uri_for("/files/upload/");
	$c->stash->{'template'}   = 'start.tt2';

}

sub start : Local Form {
	my ( $self, $c, @args ) = @_;
	$c->check_user( 'user' );
	$self->{'form_array'} = [];
	push(
		@{ $self->{'form_array'} },
		{
			'comment'  => 'Aligner',
			'name'     => 'program',
			'options'     => ['STAR', 'HISAT'],
			'value' => 'HISAT',
			'required' => 1,
		}
	);
	push(
		@{ $self->{'form_array'} },
		{
			'comment'  => 'Upload the FASTQ files',
			'name'     => 'fastq1',
			'type'     => 'file',
			'required' => 1,
		}
	);
	push(
		@{ $self->{'form_array'} },
		{
			'comment'  => 'Upload the paired FASTQ files',
			'name'     => 'fastq2',
			'type'     => 'file',
			'required' => 0,
		}
	);
	push(
		@{ $self->{'form_array'} },
		{
			'comment' =>
'A string followed by a number to identify the sample in the paired file',
			'name'  => 'orderKey',
			'value' => 'sample',
		}
	);
	push(
		@{ $self->{'form_array'} },
		{
			'comment'  => 'The type of your experiment',
			'name'     => 'type',
			'options'  => [ 'RNA', 'DNA' ],
			'required' => 1,
		}
	);
	push(
		@{ $self->{'form_array'} },
		{
			'comment' =>
			  'The organism the cells are from (e.g. human or mouse)',
			'name'     => 'organism',
			'options'  => [ 'human', 'mouse' ],
			'required' => 1,
		}
	);
	push(
		@{ $self->{'form_array'} },
		{
			'comment' =>
			  'The cells you have used for this experiment (e.g. HSC n=100)',
			'name'     => 'celltype',
			'value'    => '',
			'required' => 1,
		}
	);
	push(
		@{ $self->{'form_array'} },
		{
			'comment'  => 'The group the sample(s) are in (e.g. HSC treated)',
			'name'     => 'group',
			'value'    => '',
			'required' => 1,
		}
	);
	push(
		@{ $self->{'form_array'} },
		{
			'comment'  => 'Please select the genome version you want to map to',
			'name'     => 'version',
			'options'  => [ 'hg19', 'mm10' ],
			'required' => 1,
		}
	);

	$c->form->method('post');
	foreach ( @{ $self->{'form_array'} } ) {
		$c->form->field( %{$_} );
	}
	if ( $c->form->submitted ) {
		my $path    = $c->session_path(). "/fastq/";
		my $dataset = $self->__process_returned_form($c);
		my $upload  = $c->req->uploads->{'fastq1'};
		$dataset->{'proc'}        = 32;
		$dataset->{'fastqc_path'} = $c->session_path() . "/fastqc/";
		$dataset->{'mapper_path'} = $c->session_path() . "/".$dataset->{'program'}."/";

		#Carp::confess ( root::get_hashEntries_as_string( $upload , 3, "TEXT"));
		my $samples_table = $self->samples_table($c);
		my @file_positions;
		foreach my $u (
			map {
				if ( ref($_) eq "ARRAY" ) {
					@{
						$self->order_files( $_,
							{ 'orderKey' => $c->form->field('orderKey') } )
					};
				}
				else { $_ }
			} $upload
		  )
		{
			push(
				@file_positions,

				$samples_table->AddDataset(
					{
						'program'  => $dataset->{'program'},
						'filename' => $u->filename(),
						'path'     => $path,
						'version'  => $dataset->{'version'},
						'organism' => $dataset->{'organism'},
						'celltype' => $dataset->{'celltype'},
						'group'    => $dataset->{'group'},
					}
				) - 1
			);
			$u->copy_to( $path . $u->filename );
		}
		$upload = $c->req->uploads->{'fastq2'};
		my ($table_col_pos) = $samples_table->Header_Position('paired_fastq');
		my $i = 0;

		foreach my $u (
			map {
				if ( ref($_) eq "ARRAY" ) {
					@{
						$self->order_files( $_,
							{ 'orderKey' => $c->form->field('orderKey') } )
					};
				}
				else { $_ }
			} $upload
		  )
		{
			next unless ( defined $u);
			@{ @{ $samples_table->{'data'} }[ $file_positions[ $i++ ] ] }
			  [$table_col_pos] = $u->filename();
			$u->copy_to( $path . $u->filename );
		}
		### create the qsub scripts!!!!!!
		my $helper = $c->model('SGE_Helper_Module')->{'programs'}->{$dataset->{'program'}};
		($table_col_pos) = $samples_table->Header_Position('mapping_script');
		foreach my $file_pos (@file_positions) {
			my $hash        = $samples_table->get_line_asHash($file_pos);
			my $merged      = { %$dataset, %$hash };
			my $qsub_script = $c->model('SGE_Helper_Module')->qsub_head(
				{
					%$dataset,
					%$hash,
					%{
						@{
							$c->model('ACL')
							  ->_select_all_for_DATAFIELD( $c->user(),
								'username' )
						}[0]
					}
				}
			);
			my $files;
			$merged->{'fastqc_path'} ||= $merged->{'path'}."/fastqc/";
			my ( $srt, $f ) = $helper->fastqc_file( $merged->{'path'} . $merged->{'filename'},
				$merged );
			$qsub_script .=$srt;
			$files ->{'html'} = [$f];
			if ( -f $merged->{'path'} . $merged->{'paired_fastq'} ){
				( $srt, $f ) = $helper->fastqc_file(
				$merged->{'path'} . $merged->{'paired_fastq'}, $merged );
				$qsub_script .=$srt;
				push ( @{$files ->{'html'}}, $f);
			}
			$qsub_script .= $helper->create_program_call($merged);
			$files ->{'bam'} =  $helper->main_ofile($merged);
			( $srt, $f ) = $helper->genomeCoverageBed_file( $helper->main_ofile($merged),
				$merged );
			$qsub_script .= $srt;
			# push ( @files, $f); this file is not important!
			( $srt, $f ) =  $helper->bedGraphToBigWig_file( $helper->main_ofile($merged),
				$merged );
			$qsub_script .= $srt;
			$files ->{'bw'} =  $f;
			## now the qsub script has to be written to the users folder and a link to a summary folder has to be created
			warn $c->session_path()
			  . "scripts/qsub_"
			  . join( "_", split( /[\s\-:]/, $c->model('ACL')->NOW() ) )
			  . ".sh $table_col_pos ". @{ @{ $samples_table->{'data'} }[ $file_positions[$file_pos] ] }
			  [$table_col_pos];
			@{ @{ $samples_table->{'data'} }[ $file_positions[$file_pos] ] }
			  [$table_col_pos] = $hash->{'mapping_script'} =
			    $c->session_path()
			  . "scripts/qsub_"
			  . join( "_", split( /[\s\-:]/, $c->model('ACL')->NOW() ) )
			  . ".sh";
			mkdir ($c->session_path(). "scripts" ) unless ( -d $c->session_path(). "scripts" );
			#  Carp::confess ( $hash->{'mapping_script'} );
			open( SCRIPT, ">" . $hash->{'mapping_script'} )
			  or Carp::confess(
				"Could not open the file '$hash ->{'mapping_script'}'\n$!\n");
			print SCRIPT $qsub_script;
			close(SCRIPT);
			my $work_id = $c->model('work')->AddDataset(
				{
					'username' => $c->user(),
					'module'   => 'NGS mapping',
					'type' => 'normal',
					'info1'    => 'genome:' . $dataset->{'version'},
					'info2'    => 'Alignement type:' . $dataset->{'type'},
					'script' => $hash ->{'mapping_script'},
				}
			);
			$c->model('ofile')->AddFiles( $work_id, $files );
		}
		$self->samples_table( $c, $samples_table ); ##write that
	}
	$c->stash->{'text'} =
	  "<h1>Start to upload your FASTQ files to the analysis server</h1>\n"

	  . "<p>Here you can submitt your FASTQ files to the server. We ask you to upload files for only one experimental group at a time, "
	  . "as you then can define the group names already during the file upload.</br>\n"
	  . "The group name will make it easier for us and you to perform "
	  . "the downstream analysis.</p>";
	$c->form->template( $c->path_to( 'root', 'src' ) . '/form/upload.tt2' );
	$c->stash->{'template'} = 'Form.tt2';
}

sub order_files {
	my ( $self, $files, $processed_form ) = @_;
	return $files unless ( defined $processed_form->{'orderKey'} );
	return [
		sort {
			my ($A) = $a->{'filename'} =~ m/$processed_form->{'orderKey'}(\d+)/;
			my ($B) = $b->{'filename'} =~ m/$processed_form->{'orderKey'}(\d+)/;
			$A <=> $B;
		} @{$files}
	];
}

sub samples_table {
	my ( $self, $c, $data_table ) = @_;
	my $path = $c->session_path();
	if ( ref($data_table) eq "data_table" ) {
		$data_table->write_file( $path . "Samples.xls" );
	}
	elsif ( -f $path . "Samples.xls" ) {
		$data_table =
		  data_table->new( { 'filename' => $path . "Samples.xls" } );
		return $data_table;
	}
	$data_table = data_table->new();
	$data_table->Add_2_Header(
		[
			'program', 'filename',       'path',       'paired_fastq', 'organism',
			'celltype',       'version',    'group',        'fastqc_path',
			'mapping_script', 'sorted bam', 'bed graph'
		]
	);
	return $data_table;
}

sub access_denied : Local {
	my ( $self, $c ) = @_;
	$c->stash->{'message'} =
"Sorry you are not allowed to access this resource.\nProbably you should 'Log in' first?";
	$c->stash->{'template'} = 'message.tt2';
}

sub login : Local: Form {
	my ( $self, $c ) = @_;
	$c->require_ssl unless ( $ENV{CATALYST_DEBUG} );
	$self->{'form_array'} = [];
	push(
		@{ $self->{'form_array'} },
		{
			'comment'  => 'username',
			'name'     => 'username',
			'type'     => 'text',
			'required' => 1,
		}
	);
	push(
		@{ $self->{'form_array'} },
		{
			'comment'  => 'Your password',
			'name'     => 'password',
			'type'     => 'password',
			'required' => 1,
		}
	);

	$c->stash->{'template'} = 'login.tt2';
	foreach ( @{ $self->{'form_array'} } ) {
		$c->form->field( %{$_} );
	}
	return unless ( $c->form->submitted() && $c->form->validate() );
		if (
			$c->model('ACL')->check_pw(
				$c,
				$c->form->field('username'),
				$c->_hash_pw(
					$c->form->field('username'),
					$c->form->field('password')
				)
			)
		  )
		{
			$c->stash->{'message'} = 'Logged in successfully.';
			$c->res->redirect( $c->uri_for('/') );
			$c->detach();
		}
	
	$c->res->redirect( $c->uri_for('/access_denied/user unknown') );
	$c->detach();
}

sub logout : Local {
	my ( $self, $c ) = @_;
	$c->logout();
	$c->session->{'user'}  = undef;
	$c->flash->{'message'} = 'Logged out.';
	$c->res->redirect( $c->uri_for() );
}

=head2 default

Standard 404 error page

=cut

sub default : Path {
	my ( $self, $c ) = @_;
	$c->response->body('Page not found');
	$c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {
	my ( $self, $c ) = @_;
	$c->cookie_check();

	#	if ( -f $c->session_path()."Sample_Colors.xls"){
	#		$c->model('Menu')
	#		  ->Add( 'Go To', '/dropsamples/index', "Exclude Cells" );
	#		$c->model('Menu')
	#		  ->Add( 'Go To', '/dropgenes/index', "Exclude Genes" );
	#	}
	$c->stash->{'sidebar'} = { 'container' => [ $c->model('Menu')->menu($c) ] };
	if ( defined $c->stash->{'ERROR'} ) {
		$c->stash->{'ERROR'} = [ $c->stash->{'ERROR'} ]
		  unless ( ref( $c->stash->{'ERROR'} ) eq "ARRAY" );
	}
}

=head1 AUTHOR

Stefan Lang

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
