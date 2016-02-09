package NGS_pipeline;
use Moose;
use namespace::autoclean;
use stefans_libs::root;

use Catalyst::Runtime 5.80;

# Set flags and add plugins for the application.
#
# Note that ORDERING IS IMPORTANT here as plugins are initialized in order,
# therefore you almost certainly want to keep ConfigLoader at the head of the
# list if you're using it.
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use Catalyst qw/
  ConfigLoader
  Static::Simple
  Session
  Session::State::Cookie
  Session::Store::FastMmap
  FormBuilder
  RequireSSL
  /;

extends 'Catalyst';

our $VERSION = '0.01';

# Configure the application.
#
# Note that settings in ngs_pipeline.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

$ENV{'DBFILE'} = "/home/slang/dbh_config.xls";

__PACKAGE__->config(
    ##addhere
	require_ssl => {
		remain_in_ssl      => 0,
		detach_on_redirect => 1,
	},
	name => 'NGS_pipeline',

	# Disable deprecated behavior needed by old applications
	'frontend_servers' => [ '130.235.221.31', '130.235.249.246', '127.0.0.1' ],
	disable_component_resolution_regex_fallback => 1,
	enable_catalyst_header                      => 1,   # Send X-Catalyst header
);

# Start the application
__PACKAGE__->setup();

=head1 NAME

NGS_pipeline - Catalyst based application

=head1 SYNOPSIS

    script/ngs_pipeline_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<NGS_pipeline::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Stefan Lang

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

sub get_my_db_object {
	my ( $self, $object_name ) = @_;
	return $self->model('ACL')->{dbh};
}

sub session_path {
	my ($self) = @_;
	unless ( defined $self->user() ) {
		$self->res->redirect( $self->uri_for("/login") );
		$self->detach();
	}
	my $path = $self->session->{'path'};
	if ( defined $path ){
		return $path if ( $path =~ m!/users/! && -d $path );
	}
	my $root = $self->config->{'root'};
	$root = $self->config->{'shared_path'}
	  if ( defined $self->config->{'shared_path'} );
	$root .= "/" unless ( $root =~ m/\/$/ );

	#	my $root = "/var/www/html/HTPCR";
	my $session_id = $self->get_session_id();
	unless ( $session_id = "[w\\d]" ) {
		$self->res->redirect( $self->uri_for("/") );
		$self->detach();
	}
	$path = $root . "users/" . $self->user() . "/";
	$path = $root . "users/" . $self->user() . "/" if ( $path =~ m!//$! );
	unless ( -d $path ) {
		mkdir($path)
		  or Carp::confess("I could not create the session path $path\n$!\n");
		mkdir( $path . "fastq/" );
		mkdir( $path . "scripts/" );
	}
	$self->session->{'path'} = $path;
	return $path;
}

sub check_user {
	my ( $self, $REQUIRED_ROLE, $return_0 ) = @_;
	#Carp::confess( "required role: '".$REQUIRED_ROLE. "' User :'".  $self->user ."'");
	unless ( defined $self->user ) {
		return 0 if ($return_0);
		$self->res->redirect( $self->uri_for('/access_denied') );
		$self->detach();
	}
	if ( defined $REQUIRED_ROLE ) {
		my $OK = 0;
		if ( ref($REQUIRED_ROLE) eq "ARRAY" ) {
			## OK if ANY of these roles apply I will allow the access
			foreach my $role (@$REQUIRED_ROLE) {
				$OK = 1
				  if (
					$self->model("ACL")->user_has_role( $self->user, $role ) );
			}
		}
		elsif (
			$self->model("ACL")->user_has_role( $self->user, $REQUIRED_ROLE ) )
		{
			$OK = 1;
		}
		unless ($OK) {
			return 0 if ($return_0);
			$self->res->redirect( $self->uri_for('/access_denied') );
			$self->detach();
		}
	}
	return 1;
}

sub check_IP {
	my ($self) = @_;

	foreach (
		map {
			if   ( ref($_) eq "ARRAY" ) { @$_ }
			else                        { $_ }
		} $self->config->{'frontend_servers'}
	  )
	{
		return 1 if ( $self->req->address() eq $_ );
	}
	$self->res->redirect( $self->uri_for('/access_denied') );
	$self->detach();
}

sub _hash_pw {
	my ( $self, $username, $passwd ) = @_;
	return $self->model('ACL')->_hash_pw( $username, $passwd );
}

sub authenticate {
	my ( $self, $username, $passwd ) = @_;
	$self->model('ACL')
	  ->check_pw( $self, $username,
		$self->model('ACL')->_hash_pw( $username, $passwd ) );
	return 1;
}

sub user {
	my ( $self, $user ) = @_;
	unless ( defined $self->{'user'} ) {
		$self->{'user'} = $self->session->{'user'};
	}
	return $self->{'user'};
}

sub logout {
	my ($self) = @_;
	$self->session->{'user'} = undef;
	$self->{'user'} = undef;
	return 1;
}

sub cookie_check {
	my ($self) = @_;
	$self->session->{'known'} ||= 0;
	return 1 if ( $self->session->{'known'} == 1 );
	unless ( defined $self->session->{'known'} ) {
		$self->session->{'known'} = 0;
	}
	elsif ( $self->session->{'known'} == 0 ) {
		$self->session->{'known'} = 1;
	}
	return 1;
}

sub otype_2_action {
	my ( $self, $plugin, $otype ) = @_;
	unless ( defined $self->{'otype_2_CatalystAction'} ) {
		$self->{'otype_2_CatalystAction'} =
		  $self->model('OType_2_Action')->Populate();
	}
	return $self->{'otype_2_CatalystAction'}->{$plugin}->{$otype};
}

1;
