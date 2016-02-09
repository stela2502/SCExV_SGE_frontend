#!/usr/bin/env perl
# IMPORTANT: if you delete this file your app will not work as
# expected.  You have been warned.
use inc::Module::Install 1.02;
use Module::Install::Catalyst; # Complain loudly if you don't have
                               # Catalyst::Devel installed or haven't said
                               # 'make dist' to create a standalone tarball.

name 'NGS_pipeline';
all_from 'lib/NGS_pipeline.pm';

requires 'Catalyst::Runtime' => '5.90019';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'Moose';
requires 'Proc::Daemon';
requires 'namespace::autoclean';
requires 'Config::General'; # This should reflect the config file format you've chosen
                 # See Catalyst::Plugin::ConfigLoader for supported formats
test_requires 'Test::More' => '0.88';
requires 'Catalyst::Plugin::Session::State::Cookie';
requires 'Catalyst::Plugin::Session::Store::FastMmap';
requires 'HTML::Template';
requires 'Catalyst::Plugin::FormBuilder';
requires 'Catalyst::View::TT';
requires 'Stefans_Libs_Essentials';
requires 'File::HomeDir';
requires 'Catalyst::Authentication::User';
requires 'Catalyst::Plugin::RequireSSL';

catalyst;

install_script glob('bin/ngs_pipeline_backend.pl');
install_script glob('bin/reportFluidigm.pl');
auto_install;
WriteAll;