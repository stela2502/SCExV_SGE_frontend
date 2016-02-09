package NGS_pipeline::Model::Fluidigm_Helper;
use Moose;
use namespace::autoclean;
use Digest::MD5;

extends 'Catalyst::Model';

=head1 NAME

NGS_pipeline::Model::Fluidigm_Helper - Catalyst Model

=head1 DESCRIPTION

Catalyst Model.

=head1 AUTHOR

Stefan Lang

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

sub path {
	my ( $self, $c, $session_id ) = @_;
	my $path = $c->config->{'shared_path'};
	$path ||= $c->config->{'root'};
	mkdir($path) unless ( -d $path );
	$path .= $session_id . "/";
	mkdir($path) unless ( -d $path );
	return $path;
}

sub file2md5str {
	my ( $self, $filename ) = @_;
	my $md5_sum = 0;
	if ( -f $filename ) {
		open( FILE, "<$filename" );
		binmode FILE;
		my $ctx = Digest::MD5->new;
		$ctx->addfile(*FILE);
		$md5_sum = $ctx->b64digest;
		close(FILE);
	}
	return $md5_sum;
}

sub register_RandomForest_job {
	my ( $self, $c, $dataset, $upload ) = @_;

#Carp::confess ( root::get_hashEntries_as_string( {'c'=>$c, 'dataset'=>$dataset, 'upload' => $upload}, 3, "The problematic data" ) );
	my $path = $self->path( $c, $dataset->{'session'} );
	if ( -f $path ) {
		system( 'rm -Rf ' . $path );
	}
	my @path = split( "/", $upload->filename );
	my $target = $path . $path[ @path - 1 ];
	$upload->copy_to($target);
	my $md5 = $self->file2md5str($target);
	unless ( $md5 eq $dataset->{'key'} ) {
		return ( 0,
"Possible error here - md5 sum does not match! ($md5 != $dataset->{'key'})"
			  . " file: "
			  . $target );
	}
	else {
		chdir($path);
		system( 'tar -zxf ' . $path[ @path - 1 ] )
		  if ( $path[ @path - 1 ] =~ m/tar.gz$/ );
		system( 'unzip ' . $path[ @path - 1 ] )
		  if ( $path[ @path - 1 ] =~ m/.zip$/ );
		unless ( -f $path . 'RandomForestStarter.sh' ) {
			return ( 0, "The required script file is missing!" );
		}
		else {
			## this is necassary to give the worker access to that folder and the information therein!
			system("chown -R worker:worker $path");
			#system("chmod 775 $path");
			#system("chmod 664 $path/* -R");
			#system("chmod 775 $path/libs");
			## create the qsub sript
			open( IN, "<$path" . "RandomForestStarter.sh" );
			my @in = <IN>;
			close(IN);
			my $fn      = "$path" . "RandomForestStarter.sh";
			my $work_id = $c->model('work')->AddDataset(
				{
					'username' => 'Fluidigm',
					'module'   => 'Random Forest Calculation',
					'info1' =>
					  join( "/", $c->req->address(), $dataset->{'rpage'} ),
					'info2'  => $dataset->{'session'},
					'type'   => 'multiple',
					'script' => $fn,
				}
			);
			return ( 1,
				    "This should have worked? $! $path "
				  . $path[ @path - 1 ]
				  . " $path"
				  . "RandomForestStarter.sh work id $work_id" );
		}
	}
	return ( 0, "You should not have been able to reach this!" );
}
__PACKAGE__->meta->make_immutable;

1;
