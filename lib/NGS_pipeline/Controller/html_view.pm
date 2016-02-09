package NGS_pipeline::Controller::html_view;

use namespace::autoclean;

use Moose;
use NGS_pipeline::base_db_controler;
with 'NGS_pipeline::base_db_controler';

BEGIN { extends 'Catalyst::Controller' }

=head1 NAME

NGS_pipeline::Controller::chip_seq - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

sub index : Local {
	my ( $self, $c, $ofile_id ) = @_;
	$self->__check_user($c);
	## here I need to check whether the user has the right to access this ofile
	my $table = $c->model('ofile')->get_data_table_4_search(
		{
			'search_columns' => ['file'],
			'where'          => [
				['username', '=', 'my_value' ],
				[ ref( $c->model('ofile') ) . '.id',       '=', 'my_value' ],
				[ ref( $c->model('ofile') ) . '.type',     '=', 'my_value' ],
			],
		},
		$c->user(),
		$ofile_id,
		[ 'html', 'text' ],
	);
	unless ( $table->Lines() ) {
		$c->stash->{'message'} = "You do not have access rights for this file!";
		$c->stash->{'template'} = 'message.tt2';
		$c->detach();
	}
	else {
		## capture the html/text file into the text variable!!
		open( IN, "<@{@{$table->{'data'}}[0]}[0]" ) or $c->stash->{'message'} = "$!";
		my ($t, @path);
		@path = split("/",@{@{$table->{'data'}}[0]}[0]);
		pop(@path);
		$path[0] = $c->uri_for('/html_view/download').join("/", @path );
		$c->stash->{'text'} =  join( "", map { $t = $_; $t =~ s/src="(?!\/)/src="$path[0]\//; $t } <IN> );
		close(IN);
	}
	$c->stash->{'template'} = 'message.tt2';
}

sub download : Local {
	my ( $self, $c, @file ) = @_;
	$c->check_user();
	my $file = join( "/", @file );
	my $un = $c->user();
	unless ( $file =~ m/$un/ ) {
		$c->stash->{'message'} =
		  "Sorry this is not your outfile - you must not access that!";
		$c->stash->{'template'} = 'message.tt2';
		$c->detach();
	}
	unless ( -f $file ) {
		$c->stash->{'message'} =
		  "Sorry I can not access the file '$file' on the server!";
		$c->stash->{'template'} = 'message.tt2';
		$c->detach();
	}
	my $fn = @file[ @file - 1 ];
	open( OUT, "<$file" );
	$c->res->content_type('image/svg+xml') if ( $file =~ m/svg$/ );
	$c->res->header( 'Content-Disposition', qq[attachment; filename="$fn"] );
	while ( defined( my $line = <OUT> ) ) {
		$c->res->write($line);
	}
	close(OUT);

	$c->res->code(204);
}

=head1 AUTHOR

Stefan Lang

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
