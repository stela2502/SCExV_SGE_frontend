package NGS_pipeline::base_db_controler;


use Moose::Role;


=head2 Add_add_form

Arguments: A Catalyst object and a hash containing at the minimum the value 'db_obj' 
that has to be a genexpress database model implementing a variable_table.
In addition, you may supply a 'downstream_table' variable, if you want to get a insert statement for the downstream table.
The last part is the 'redirect_on_success' variable, that should contain a relative location  in the genexpress web frontend.
If that contains a ##ID## tag, this tag will be exchanged to the newly created database ID.


=head2 __check_user ($c, $REQUIRED_ROLE)

This function cecks the rights of the users. First, whether the user is logged in.
If he/she is logged in and the function also requires an role the role is checked.

If the $REQUIRED_ROLE is an array of roles, any of the roles is sufficient to access the page.

=cut

sub __check_user {
	my ( $self, $c, $REQUIRED_ROLE, $return_0 ) = @_;
	return $c->check_user ( $REQUIRED_ROLE, $return_0  );
}


sub __process_returned_form {
	my ( $self, $c ) = @_;
	my ( $dataset, @data, $str );
	foreach my $field ( $c->form->fields ) {
		$str .= "$field; ";
		$field->{'type'} ||= '';
		if ( $field->{'type'} eq "file" ) {
			next; ## this is handled in the controler directly! 
			## OK - upload the file and give the script the linked position...
			my $upload   = $c->req->upload($field);
			Carp::confess ( "I tried to upload the field of name $field->{'name'} "."which should be a file, but I got no file object but (".$upload.")!\n".
			"A frequent error is to not use the 'post' methood for the page (missing the line '$c->form->method('post');')\n") unless ( ref($upload) =~m/\w/ );
			my $filename = $upload->filename;
			my $target =
			  $c->model('configuration')
			  ->GetConfigurationValue_for_tag('web_temp_path') . "/$filename";
			$target =~ s/\s/_/g;
			$target =~ s/[\)\(\:]/_/g;
			unless (  $upload->link_to($target)
				|| $upload->copy_to($target) )
			{
				if ( $! =~m/Die Datei existiert bereits/  ){
					$dataset->{$field} = $target;
				}
				elsif ( $! =~m/File exists/){
					$dataset->{$field} = $target;
				}
				else {
					Carp::confess("Failed to copy '$filename' to '$target': $!");
				}
				
			}
			else {
				$dataset->{$field} = $target;
			}
		}
		elsif ( $field->{'multiple'} ) {
			@data = $c->form->field($field);
			$dataset->{$field} = [@data];

#Carp::confess ( "Wow - why does that not work?? $field => ".join(", ",@{$dataset->{$field}})."\n");
		}
		else {
			@data = $c->form->field($field);
			$dataset->{$field} = $data[0];
		}
	}
	return $dataset;
}



=head1 NAME

Genexpress_catalist::Controller::base_db_controler - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

=head1 AUTHOR

Stefan Lang

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
