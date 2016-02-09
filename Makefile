# This Makefile is for the NGS_pipeline extension to perl.
#
# It was generated automatically by MakeMaker version
# 6.72 (Revision: 67200) from the contents of
# Makefile.PL. Don't edit this file, edit Makefile.PL instead.
#
#       ANY CHANGES MADE HERE WILL BE LOST!
#
#   MakeMaker ARGV: ()
#

#   MakeMaker Parameters:

#     ABSTRACT => q[Catalyst based application]
#     AUTHOR => [q[Stefan Lang]]
#     BUILD_REQUIRES => { ExtUtils::MakeMaker=>q[6.36], Test::More=>q[0.88] }
#     CONFIGURE_REQUIRES => {  }
#     DISTNAME => q[NGS_pipeline]
#     EXE_FILES => [q[bin/ngs_pipeline_backend.pl], q[bin/reportFluidigm.pl]]
#     LICENSE => q[perl]
#     NAME => q[NGS_pipeline]
#     NO_META => q[1]
#     PREREQ_PM => { Config::General=>q[0], Catalyst::Action::RenderView=>q[0], Catalyst::Plugin::RequireSSL=>q[0], Catalyst::Plugin::Static::Simple=>q[0], Catalyst::Runtime=>q[5.90019], Catalyst::Plugin::Session::State::Cookie=>q[0], File::HomeDir=>q[0], Catalyst::Plugin::ConfigLoader=>q[0], HTML::Template=>q[0], Moose=>q[0], Proc::Daemon=>q[0], Catalyst::Plugin::FormBuilder=>q[0], Catalyst::View::TT=>q[0], Catalyst::Authentication::User=>q[0], namespace::autoclean=>q[0], ExtUtils::MakeMaker=>q[6.36], Catalyst::Plugin::Session::Store::FastMmap=>q[0], Stefans_Libs_Essentials=>q[0], Test::More=>q[0.88] }
#     TEST_REQUIRES => {  }
#     VERSION => q[0.01]
#     VERSION_FROM => q[lib/NGS_pipeline.pm]
#     dist => {  }
#     realclean => { FILES=>q[MYMETA.yml] }
#     test => { TESTS=>q[t/001_db_2.1.0_scientistTable.t t/001_db_2.1.1_stefans_libs_database_workload.t t/006_WEB_object_scientistTable.t t/01app.t t/02pod.t t/03podcoverage.t t/controller_chip_seq.t t/controller_debug.t t/controller_dna_seq.t t/controller_experiments.t t/controller_rna_seq.t t/controller_utilities.t t/model_Fluidigm_Helper_reciever.t t/model_Fluidigm_Helper_sender.t t/model_OType_2_Action.t t/ngs_backend.t t/stefans_libs_database_otype_2_CatalystAction.t t/stefans_libs_database_process_finished.t t/stefans_libs_database_workload_outfiles.t t/stefans_libs_NGS_pipeline_SGE_helper.t t/stefans_libs_NGS_pipeline_SGE_helper_Bowtie.t t/stefans_libs_NGS_pipeline_SGE_helper_HISAT.t t/stefans_libs_NGS_pipeline_SGE_helper_mapper_general.t t/stefans_libs_NGS_pipeline_SGE_helper_STAR.t] }

# --- MakeMaker post_initialize section:


# --- MakeMaker const_config section:

# These definitions are from config.sh (via /usr/lib64/perl5/Config.pm).
# They may have been overridden via Makefile.PL or on the command line.
AR = ar
CC = gcc
CCCDLFLAGS = -fPIC
CCDLFLAGS = -Wl,--enable-new-dtags
DLEXT = so
DLSRC = dl_dlopen.xs
EXE_EXT = 
FULL_AR = /usr/bin/ar
LD = gcc
LDDLFLAGS = -shared -O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 -grecord-gcc-switches -m64 -mtune=generic -Wl,-z,relro 
LDFLAGS =  -fstack-protector
LIBC = 
LIB_EXT = .a
OBJ_EXT = .o
OSNAME = linux
OSVERS = 3.19.1-201.fc21.x86_64
RANLIB = :
SITELIBEXP = /usr/local/share/perl5
SITEARCHEXP = /usr/local/lib64/perl5
SO = so
VENDORARCHEXP = /usr/lib64/perl5/vendor_perl
VENDORLIBEXP = /usr/share/perl5/vendor_perl


# --- MakeMaker constants section:
AR_STATIC_ARGS = cr
DIRFILESEP = /
DFSEP = $(DIRFILESEP)
NAME = NGS_pipeline
NAME_SYM = NGS_pipeline
VERSION = 0.01
VERSION_MACRO = VERSION
VERSION_SYM = 0_01
DEFINE_VERSION = -D$(VERSION_MACRO)=\"$(VERSION)\"
XS_VERSION = 0.01
XS_VERSION_MACRO = XS_VERSION
XS_DEFINE_VERSION = -D$(XS_VERSION_MACRO)=\"$(XS_VERSION)\"
INST_ARCHLIB = blib/arch
INST_SCRIPT = blib/script
INST_BIN = blib/bin
INST_LIB = blib/lib
INST_MAN1DIR = blib/man1
INST_MAN3DIR = blib/man3
MAN1EXT = 1
MAN3EXT = 3pm
INSTALLDIRS = site
DESTDIR = 
PREFIX = $(SITEPREFIX)
PERLPREFIX = /usr
SITEPREFIX = /usr/local
VENDORPREFIX = /usr
INSTALLPRIVLIB = /usr/share/perl5
DESTINSTALLPRIVLIB = $(DESTDIR)$(INSTALLPRIVLIB)
INSTALLSITELIB = /usr/local/share/perl5
DESTINSTALLSITELIB = $(DESTDIR)$(INSTALLSITELIB)
INSTALLVENDORLIB = /usr/share/perl5/vendor_perl
DESTINSTALLVENDORLIB = $(DESTDIR)$(INSTALLVENDORLIB)
INSTALLARCHLIB = /usr/lib64/perl5
DESTINSTALLARCHLIB = $(DESTDIR)$(INSTALLARCHLIB)
INSTALLSITEARCH = /usr/local/lib64/perl5
DESTINSTALLSITEARCH = $(DESTDIR)$(INSTALLSITEARCH)
INSTALLVENDORARCH = /usr/lib64/perl5/vendor_perl
DESTINSTALLVENDORARCH = $(DESTDIR)$(INSTALLVENDORARCH)
INSTALLBIN = /usr/bin
DESTINSTALLBIN = $(DESTDIR)$(INSTALLBIN)
INSTALLSITEBIN = /usr/local/bin
DESTINSTALLSITEBIN = $(DESTDIR)$(INSTALLSITEBIN)
INSTALLVENDORBIN = /usr/bin
DESTINSTALLVENDORBIN = $(DESTDIR)$(INSTALLVENDORBIN)
INSTALLSCRIPT = /usr/bin
DESTINSTALLSCRIPT = $(DESTDIR)$(INSTALLSCRIPT)
INSTALLSITESCRIPT = /usr/local/bin
DESTINSTALLSITESCRIPT = $(DESTDIR)$(INSTALLSITESCRIPT)
INSTALLVENDORSCRIPT = /usr/bin
DESTINSTALLVENDORSCRIPT = $(DESTDIR)$(INSTALLVENDORSCRIPT)
INSTALLMAN1DIR = /usr/share/man/man1
DESTINSTALLMAN1DIR = $(DESTDIR)$(INSTALLMAN1DIR)
INSTALLSITEMAN1DIR = /usr/local/share/man/man1
DESTINSTALLSITEMAN1DIR = $(DESTDIR)$(INSTALLSITEMAN1DIR)
INSTALLVENDORMAN1DIR = /usr/share/man/man1
DESTINSTALLVENDORMAN1DIR = $(DESTDIR)$(INSTALLVENDORMAN1DIR)
INSTALLMAN3DIR = /usr/share/man/man3
DESTINSTALLMAN3DIR = $(DESTDIR)$(INSTALLMAN3DIR)
INSTALLSITEMAN3DIR = /usr/local/share/man/man3
DESTINSTALLSITEMAN3DIR = $(DESTDIR)$(INSTALLSITEMAN3DIR)
INSTALLVENDORMAN3DIR = /usr/share/man/man3
DESTINSTALLVENDORMAN3DIR = $(DESTDIR)$(INSTALLVENDORMAN3DIR)
PERL_LIB =
PERL_ARCHLIB = /usr/lib64/perl5
LIBPERL_A = libperl.a
FIRST_MAKEFILE = Makefile
MAKEFILE_OLD = Makefile.old
MAKE_APERL_FILE = Makefile.aperl
PERLMAINCC = $(CC)
PERL_INC = /usr/lib64/perl5/CORE
PERL = /usr/bin/perl "-Iinc"
FULLPERL = /usr/bin/perl "-Iinc"
ABSPERL = $(PERL)
PERLRUN = $(PERL)
FULLPERLRUN = $(FULLPERL)
ABSPERLRUN = $(ABSPERL)
PERLRUNINST = $(PERLRUN) "-I$(INST_ARCHLIB)" "-Iinc" "-I$(INST_LIB)"
FULLPERLRUNINST = $(FULLPERLRUN) "-I$(INST_ARCHLIB)" "-Iinc" "-I$(INST_LIB)"
ABSPERLRUNINST = $(ABSPERLRUN) "-I$(INST_ARCHLIB)" "-Iinc" "-I$(INST_LIB)"
PERL_CORE = 0
PERM_DIR = 755
PERM_RW = 644
PERM_RWX = 755

MAKEMAKER   = /usr/share/perl5/vendor_perl/ExtUtils/MakeMaker.pm
MM_VERSION  = 6.72
MM_REVISION = 67200

# FULLEXT = Pathname for extension directory (eg Foo/Bar/Oracle).
# BASEEXT = Basename part of FULLEXT. May be just equal FULLEXT. (eg Oracle)
# PARENT_NAME = NAME without BASEEXT and no trailing :: (eg Foo::Bar)
# DLBASE  = Basename part of dynamic library. May be just equal BASEEXT.
MAKE = make
FULLEXT = NGS_pipeline
BASEEXT = NGS_pipeline
PARENT_NAME = 
DLBASE = $(BASEEXT)
VERSION_FROM = lib/NGS_pipeline.pm
OBJECT = 
LDFROM = $(OBJECT)
LINKTYPE = dynamic
BOOTDEP = 

# Handy lists of source code files:
XS_FILES = 
C_FILES  = 
O_FILES  = 
H_FILES  = 
MAN1PODS = bin/ngs_pipeline_backend.pl \
	bin/reportFluidigm.pl
MAN3PODS = lib/NGS_pipeline.pm \
	lib/NGS_pipeline/Controller/Administration.pm \
	lib/NGS_pipeline/Controller/Fluidigm.pm \
	lib/NGS_pipeline/Controller/Root.pm \
	lib/NGS_pipeline/Controller/debug.pm \
	lib/NGS_pipeline/Controller/experiments.pm \
	lib/NGS_pipeline/Controller/help.pm \
	lib/NGS_pipeline/Controller/html_view.pm \
	lib/NGS_pipeline/Controller/rna_seq.pm \
	lib/NGS_pipeline/Controller/utilities.pm \
	lib/NGS_pipeline/Model/ACL.pm \
	lib/NGS_pipeline/Model/Action_Groups.pm \
	lib/NGS_pipeline/Model/Experiment.pm \
	lib/NGS_pipeline/Model/Fluidigm_Helper.pm \
	lib/NGS_pipeline/Model/HelpFile.pm \
	lib/NGS_pipeline/Model/Menu.pm \
	lib/NGS_pipeline/Model/OType_2_Action.pm \
	lib/NGS_pipeline/Model/Roles.pm \
	lib/NGS_pipeline/Model/SGE_Helper_Module.pm \
	lib/NGS_pipeline/Model/ofile.pm \
	lib/NGS_pipeline/Model/work.pm \
	lib/NGS_pipeline/View/HTML.pm \
	lib/NGS_pipeline/base_db_controler.pm \
	lib/stefans_libs/NGS_pipeline/Menue.pm \
	lib/stefans_libs/NGS_pipeline/SGE_helper.pm \
	lib/stefans_libs/NGS_pipeline/SGE_helper/Bowtie.pm \
	lib/stefans_libs/NGS_pipeline/SGE_helper/HISAT.pm \
	lib/stefans_libs/NGS_pipeline/SGE_helper/STAR.pm \
	lib/stefans_libs/NGS_pipeline/SGE_helper/mapper_general.pm \
	lib/stefans_libs/WEB_Objects/scientistTable.pm \
	lib/stefans_libs/WEB_Objects/scientistTable/Action_List.pm \
	lib/stefans_libs/WEB_Objects/scientistTable/Role_List.pm \
	lib/stefans_libs/database/otype_2_CatalystAction.pm \
	lib/stefans_libs/database/scientistTable.pm \
	lib/stefans_libs/database/scientistTable/scientificComunity.pm \
	lib/stefans_libs/database_list_object.pm \
	lib/stefans_libs/database_object.pm

# Where is the Config information that we are using/depend on
CONFIGDEP = $(PERL_ARCHLIB)$(DFSEP)Config.pm $(PERL_INC)$(DFSEP)config.h

# Where to build things
INST_LIBDIR      = $(INST_LIB)
INST_ARCHLIBDIR  = $(INST_ARCHLIB)

INST_AUTODIR     = $(INST_LIB)/auto/$(FULLEXT)
INST_ARCHAUTODIR = $(INST_ARCHLIB)/auto/$(FULLEXT)

INST_STATIC      = 
INST_DYNAMIC     = 
INST_BOOT        = 

# Extra linker info
EXPORT_LIST        = 
PERL_ARCHIVE       = 
PERL_ARCHIVE_AFTER = 


TO_INST_PM = lib/NGS_pipeline.pm \
	lib/NGS_pipeline/Controller/Administration.pm \
	lib/NGS_pipeline/Controller/Fluidigm.pm \
	lib/NGS_pipeline/Controller/Root.pm \
	lib/NGS_pipeline/Controller/debug.pm \
	lib/NGS_pipeline/Controller/experiments.pm \
	lib/NGS_pipeline/Controller/help.pm \
	lib/NGS_pipeline/Controller/html_view.pm \
	lib/NGS_pipeline/Controller/rna_seq.pm \
	lib/NGS_pipeline/Controller/utilities.pm \
	lib/NGS_pipeline/Model/ACL.pm \
	lib/NGS_pipeline/Model/Action_Groups.pm \
	lib/NGS_pipeline/Model/Experiment.pm \
	lib/NGS_pipeline/Model/Fluidigm_Helper.pm \
	lib/NGS_pipeline/Model/HelpFile.pm \
	lib/NGS_pipeline/Model/Menu.pm \
	lib/NGS_pipeline/Model/OType_2_Action.pm \
	lib/NGS_pipeline/Model/Roles.pm \
	lib/NGS_pipeline/Model/SGE_Helper_Module.pm \
	lib/NGS_pipeline/Model/ofile.pm \
	lib/NGS_pipeline/Model/work.pm \
	lib/NGS_pipeline/View/HTML.pm \
	lib/NGS_pipeline/base_db_controler.pm \
	lib/stefans_libs/NGS_pipeline/Menue.pm \
	lib/stefans_libs/NGS_pipeline/SGE_helper.pm \
	lib/stefans_libs/NGS_pipeline/SGE_helper/Bowtie.pm \
	lib/stefans_libs/NGS_pipeline/SGE_helper/HISAT.pm \
	lib/stefans_libs/NGS_pipeline/SGE_helper/STAR.pm \
	lib/stefans_libs/NGS_pipeline/SGE_helper/mapper_general.pm \
	lib/stefans_libs/WEB_Objects/scientistTable.pm \
	lib/stefans_libs/WEB_Objects/scientistTable/Action_List.pm \
	lib/stefans_libs/WEB_Objects/scientistTable/Role_List.pm \
	lib/stefans_libs/database/experimentTable.pm \
	lib/stefans_libs/database/otype_2_CatalystAction.pm \
	lib/stefans_libs/database/outfiles.pm \
	lib/stefans_libs/database/process_finished.pm \
	lib/stefans_libs/database/scientistTable.pm \
	lib/stefans_libs/database/scientistTable/CatalystUser.pm \
	lib/stefans_libs/database/scientistTable/action_group_list.pm \
	lib/stefans_libs/database/scientistTable/action_groups.pm \
	lib/stefans_libs/database/scientistTable/role_list.pm \
	lib/stefans_libs/database/scientistTable/roles.pm \
	lib/stefans_libs/database/scientistTable/scientificComunity.pm \
	lib/stefans_libs/database/scientistTable/temporary_banned.pm \
	lib/stefans_libs/database/workload.pm \
	lib/stefans_libs/database_list_object.pm \
	lib/stefans_libs/database_object.pm

PM_TO_BLIB = lib/NGS_pipeline/Model/Experiment.pm \
	blib/lib/NGS_pipeline/Model/Experiment.pm \
	lib/stefans_libs/database/scientistTable/role_list.pm \
	blib/lib/stefans_libs/database/scientistTable/role_list.pm \
	lib/NGS_pipeline/base_db_controler.pm \
	blib/lib/NGS_pipeline/base_db_controler.pm \
	lib/stefans_libs/database_object.pm \
	blib/lib/stefans_libs/database_object.pm \
	lib/stefans_libs/WEB_Objects/scientistTable/Role_List.pm \
	blib/lib/stefans_libs/WEB_Objects/scientistTable/Role_List.pm \
	lib/stefans_libs/database/workload.pm \
	blib/lib/stefans_libs/database/workload.pm \
	lib/NGS_pipeline/Controller/rna_seq.pm \
	blib/lib/NGS_pipeline/Controller/rna_seq.pm \
	lib/stefans_libs/database/scientistTable/temporary_banned.pm \
	blib/lib/stefans_libs/database/scientistTable/temporary_banned.pm \
	lib/stefans_libs/WEB_Objects/scientistTable.pm \
	blib/lib/stefans_libs/WEB_Objects/scientistTable.pm \
	lib/NGS_pipeline/Model/Roles.pm \
	blib/lib/NGS_pipeline/Model/Roles.pm \
	lib/stefans_libs/NGS_pipeline/SGE_helper/HISAT.pm \
	blib/lib/stefans_libs/NGS_pipeline/SGE_helper/HISAT.pm \
	lib/stefans_libs/database/scientistTable/scientificComunity.pm \
	blib/lib/stefans_libs/database/scientistTable/scientificComunity.pm \
	lib/stefans_libs/database/otype_2_CatalystAction.pm \
	blib/lib/stefans_libs/database/otype_2_CatalystAction.pm \
	lib/NGS_pipeline/Controller/utilities.pm \
	blib/lib/NGS_pipeline/Controller/utilities.pm \
	lib/stefans_libs/NGS_pipeline/SGE_helper/STAR.pm \
	blib/lib/stefans_libs/NGS_pipeline/SGE_helper/STAR.pm \
	lib/NGS_pipeline/Controller/Root.pm \
	blib/lib/NGS_pipeline/Controller/Root.pm \
	lib/stefans_libs/database/scientistTable/action_groups.pm \
	blib/lib/stefans_libs/database/scientistTable/action_groups.pm \
	lib/stefans_libs/WEB_Objects/scientistTable/Action_List.pm \
	blib/lib/stefans_libs/WEB_Objects/scientistTable/Action_List.pm \
	lib/NGS_pipeline/Model/ofile.pm \
	blib/lib/NGS_pipeline/Model/ofile.pm \
	lib/stefans_libs/NGS_pipeline/Menue.pm \
	blib/lib/stefans_libs/NGS_pipeline/Menue.pm \
	lib/NGS_pipeline/Controller/Fluidigm.pm \
	blib/lib/NGS_pipeline/Controller/Fluidigm.pm \
	lib/NGS_pipeline/View/HTML.pm \
	blib/lib/NGS_pipeline/View/HTML.pm \
	lib/stefans_libs/database/scientistTable/CatalystUser.pm \
	blib/lib/stefans_libs/database/scientistTable/CatalystUser.pm \
	lib/stefans_libs/NGS_pipeline/SGE_helper/Bowtie.pm \
	blib/lib/stefans_libs/NGS_pipeline/SGE_helper/Bowtie.pm \
	lib/NGS_pipeline/Model/Action_Groups.pm \
	blib/lib/NGS_pipeline/Model/Action_Groups.pm \
	lib/stefans_libs/NGS_pipeline/SGE_helper.pm \
	blib/lib/stefans_libs/NGS_pipeline/SGE_helper.pm \
	lib/NGS_pipeline/Controller/html_view.pm \
	blib/lib/NGS_pipeline/Controller/html_view.pm \
	lib/NGS_pipeline/Model/Fluidigm_Helper.pm \
	blib/lib/NGS_pipeline/Model/Fluidigm_Helper.pm \
	lib/stefans_libs/database/experimentTable.pm \
	blib/lib/stefans_libs/database/experimentTable.pm \
	lib/NGS_pipeline/Model/Menu.pm \
	blib/lib/NGS_pipeline/Model/Menu.pm \
	lib/NGS_pipeline/Controller/debug.pm \
	blib/lib/NGS_pipeline/Controller/debug.pm \
	lib/NGS_pipeline.pm \
	blib/lib/NGS_pipeline.pm \
	lib/stefans_libs/NGS_pipeline/SGE_helper/mapper_general.pm \
	blib/lib/stefans_libs/NGS_pipeline/SGE_helper/mapper_general.pm \
	lib/NGS_pipeline/Model/SGE_Helper_Module.pm \
	blib/lib/NGS_pipeline/Model/SGE_Helper_Module.pm \
	lib/NGS_pipeline/Controller/help.pm \
	blib/lib/NGS_pipeline/Controller/help.pm \
	lib/NGS_pipeline/Controller/experiments.pm \
	blib/lib/NGS_pipeline/Controller/experiments.pm \
	lib/stefans_libs/database/process_finished.pm \
	blib/lib/stefans_libs/database/process_finished.pm \
	lib/NGS_pipeline/Model/HelpFile.pm \
	blib/lib/NGS_pipeline/Model/HelpFile.pm \
	lib/NGS_pipeline/Model/OType_2_Action.pm \
	blib/lib/NGS_pipeline/Model/OType_2_Action.pm \
	lib/stefans_libs/database/scientistTable/action_group_list.pm \
	blib/lib/stefans_libs/database/scientistTable/action_group_list.pm \
	lib/NGS_pipeline/Model/ACL.pm \
	blib/lib/NGS_pipeline/Model/ACL.pm \
	lib/stefans_libs/database/scientistTable.pm \
	blib/lib/stefans_libs/database/scientistTable.pm \
	lib/stefans_libs/database/outfiles.pm \
	blib/lib/stefans_libs/database/outfiles.pm \
	lib/stefans_libs/database_list_object.pm \
	blib/lib/stefans_libs/database_list_object.pm \
	lib/NGS_pipeline/Controller/Administration.pm \
	blib/lib/NGS_pipeline/Controller/Administration.pm \
	lib/NGS_pipeline/Model/work.pm \
	blib/lib/NGS_pipeline/Model/work.pm \
	lib/stefans_libs/database/scientistTable/roles.pm \
	blib/lib/stefans_libs/database/scientistTable/roles.pm


# --- MakeMaker platform_constants section:
MM_Unix_VERSION = 6.72
PERL_MALLOC_DEF = -DPERL_EXTMALLOC_DEF -Dmalloc=Perl_malloc -Dfree=Perl_mfree -Drealloc=Perl_realloc -Dcalloc=Perl_calloc


# --- MakeMaker tool_autosplit section:
# Usage: $(AUTOSPLITFILE) FileToSplit AutoDirToSplitInto
AUTOSPLITFILE = $(ABSPERLRUN)  -e 'use AutoSplit;  autosplit($$$$ARGV[0], $$$$ARGV[1], 0, 1, 1)' --



# --- MakeMaker tool_xsubpp section:


# --- MakeMaker tools_other section:
SHELL = /bin/sh
CHMOD = chmod
CP = cp
MV = mv
NOOP = $(TRUE)
NOECHO = @
RM_F = rm -f
RM_RF = rm -rf
TEST_F = test -f
TOUCH = touch
UMASK_NULL = umask 0
DEV_NULL = > /dev/null 2>&1
MKPATH = $(ABSPERLRUN) -MExtUtils::Command -e 'mkpath' --
EQUALIZE_TIMESTAMP = $(ABSPERLRUN) -MExtUtils::Command -e 'eqtime' --
FALSE = false
TRUE = true
ECHO = echo
ECHO_N = echo -n
UNINST = 0
VERBINST = 0
MOD_INSTALL = $(ABSPERLRUN) -MExtUtils::Install -e 'install([ from_to => {@ARGV}, verbose => '\''$(VERBINST)'\'', uninstall_shadows => '\''$(UNINST)'\'', dir_mode => '\''$(PERM_DIR)'\'' ]);' --
DOC_INSTALL = $(ABSPERLRUN) -MExtUtils::Command::MM -e 'perllocal_install' --
UNINSTALL = $(ABSPERLRUN) -MExtUtils::Command::MM -e 'uninstall' --
WARN_IF_OLD_PACKLIST = $(ABSPERLRUN) -MExtUtils::Command::MM -e 'warn_if_old_packlist' --
MACROSTART = 
MACROEND = 
USEMAKEFILE = -f
FIXIN = $(ABSPERLRUN) -MExtUtils::MY -e 'MY->fixin(shift)' --


# --- MakeMaker makemakerdflt section:
makemakerdflt : all
	$(NOECHO) $(NOOP)


# --- MakeMaker dist section:
TAR = tar
TARFLAGS = cvf
ZIP = zip
ZIPFLAGS = -r
COMPRESS = gzip --best
SUFFIX = .gz
SHAR = shar
PREOP = $(NOECHO) $(NOOP)
POSTOP = $(NOECHO) $(NOOP)
TO_UNIX = $(NOECHO) $(NOOP)
CI = ci -u
RCS_LABEL = rcs -Nv$(VERSION_SYM): -q
DIST_CP = best
DIST_DEFAULT = tardist
DISTNAME = NGS_pipeline
DISTVNAME = NGS_pipeline-0.01


# --- MakeMaker macro section:


# --- MakeMaker depend section:


# --- MakeMaker cflags section:


# --- MakeMaker const_loadlibs section:


# --- MakeMaker const_cccmd section:


# --- MakeMaker post_constants section:


# --- MakeMaker pasthru section:

PASTHRU = LIBPERL_A="$(LIBPERL_A)"\
	LINKTYPE="$(LINKTYPE)"\
	PREFIX="$(PREFIX)"


# --- MakeMaker special_targets section:
.SUFFIXES : .xs .c .C .cpp .i .s .cxx .cc $(OBJ_EXT)

.PHONY: all config static dynamic test linkext manifest blibdirs clean realclean disttest distdir



# --- MakeMaker c_o section:


# --- MakeMaker xs_c section:


# --- MakeMaker xs_o section:


# --- MakeMaker top_targets section:
all :: pure_all manifypods
	$(NOECHO) $(NOOP)


pure_all :: config pm_to_blib subdirs linkext
	$(NOECHO) $(NOOP)

subdirs :: $(MYEXTLIB)
	$(NOECHO) $(NOOP)

config :: $(FIRST_MAKEFILE) blibdirs
	$(NOECHO) $(NOOP)

help :
	perldoc ExtUtils::MakeMaker


# --- MakeMaker blibdirs section:
blibdirs : $(INST_LIBDIR)$(DFSEP).exists $(INST_ARCHLIB)$(DFSEP).exists $(INST_AUTODIR)$(DFSEP).exists $(INST_ARCHAUTODIR)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists $(INST_SCRIPT)$(DFSEP).exists $(INST_MAN1DIR)$(DFSEP).exists $(INST_MAN3DIR)$(DFSEP).exists
	$(NOECHO) $(NOOP)

# Backwards compat with 6.18 through 6.25
blibdirs.ts : blibdirs
	$(NOECHO) $(NOOP)

$(INST_LIBDIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_LIBDIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_LIBDIR)
	$(NOECHO) $(TOUCH) $(INST_LIBDIR)$(DFSEP).exists

$(INST_ARCHLIB)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_ARCHLIB)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_ARCHLIB)
	$(NOECHO) $(TOUCH) $(INST_ARCHLIB)$(DFSEP).exists

$(INST_AUTODIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_AUTODIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_AUTODIR)
	$(NOECHO) $(TOUCH) $(INST_AUTODIR)$(DFSEP).exists

$(INST_ARCHAUTODIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_ARCHAUTODIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_ARCHAUTODIR)
	$(NOECHO) $(TOUCH) $(INST_ARCHAUTODIR)$(DFSEP).exists

$(INST_BIN)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_BIN)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_BIN)
	$(NOECHO) $(TOUCH) $(INST_BIN)$(DFSEP).exists

$(INST_SCRIPT)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_SCRIPT)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_SCRIPT)
	$(NOECHO) $(TOUCH) $(INST_SCRIPT)$(DFSEP).exists

$(INST_MAN1DIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_MAN1DIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_MAN1DIR)
	$(NOECHO) $(TOUCH) $(INST_MAN1DIR)$(DFSEP).exists

$(INST_MAN3DIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_MAN3DIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_MAN3DIR)
	$(NOECHO) $(TOUCH) $(INST_MAN3DIR)$(DFSEP).exists



# --- MakeMaker linkext section:

linkext :: $(LINKTYPE)
	$(NOECHO) $(NOOP)


# --- MakeMaker dlsyms section:


# --- MakeMaker dynamic section:

dynamic :: $(FIRST_MAKEFILE) $(INST_DYNAMIC) $(INST_BOOT)
	$(NOECHO) $(NOOP)


# --- MakeMaker dynamic_bs section:

BOOTSTRAP =


# --- MakeMaker dynamic_lib section:


# --- MakeMaker static section:

## $(INST_PM) has been moved to the all: target.
## It remains here for awhile to allow for old usage: "make static"
static :: $(FIRST_MAKEFILE) $(INST_STATIC)
	$(NOECHO) $(NOOP)


# --- MakeMaker static_lib section:


# --- MakeMaker manifypods section:

POD2MAN_EXE = $(PERLRUN) "-MExtUtils::Command::MM" -e pod2man "--"
POD2MAN = $(POD2MAN_EXE)


manifypods : pure_all  \
	bin/ngs_pipeline_backend.pl \
	bin/reportFluidigm.pl \
	lib/NGS_pipeline/Model/HelpFile.pm \
	lib/NGS_pipeline/Controller/experiments.pm \
	lib/NGS_pipeline/Model/OType_2_Action.pm \
	lib/stefans_libs/NGS_pipeline/SGE_helper/mapper_general.pm \
	lib/NGS_pipeline/Model/SGE_Helper_Module.pm \
	lib/NGS_pipeline/Controller/help.pm \
	lib/NGS_pipeline/Controller/html_view.pm \
	lib/NGS_pipeline/Model/Action_Groups.pm \
	lib/stefans_libs/NGS_pipeline/SGE_helper.pm \
	lib/NGS_pipeline.pm \
	lib/NGS_pipeline/Controller/debug.pm \
	lib/NGS_pipeline/Model/Fluidigm_Helper.pm \
	lib/NGS_pipeline/Model/Menu.pm \
	lib/stefans_libs/NGS_pipeline/SGE_helper/Bowtie.pm \
	lib/NGS_pipeline/Model/work.pm \
	lib/NGS_pipeline/Controller/Administration.pm \
	lib/stefans_libs/database_list_object.pm \
	lib/stefans_libs/database/scientistTable.pm \
	lib/NGS_pipeline/Model/ACL.pm \
	lib/stefans_libs/NGS_pipeline/SGE_helper/HISAT.pm \
	lib/NGS_pipeline/Model/Roles.pm \
	lib/stefans_libs/WEB_Objects/scientistTable.pm \
	lib/NGS_pipeline/Controller/rna_seq.pm \
	lib/NGS_pipeline/Model/Experiment.pm \
	lib/stefans_libs/WEB_Objects/scientistTable/Role_List.pm \
	lib/stefans_libs/database_object.pm \
	lib/NGS_pipeline/base_db_controler.pm \
	lib/NGS_pipeline/View/HTML.pm \
	lib/stefans_libs/NGS_pipeline/Menue.pm \
	lib/NGS_pipeline/Controller/Fluidigm.pm \
	lib/NGS_pipeline/Model/ofile.pm \
	lib/stefans_libs/WEB_Objects/scientistTable/Action_List.pm \
	lib/NGS_pipeline/Controller/utilities.pm \
	lib/NGS_pipeline/Controller/Root.pm \
	lib/stefans_libs/NGS_pipeline/SGE_helper/STAR.pm \
	lib/stefans_libs/database/otype_2_CatalystAction.pm \
	lib/stefans_libs/database/scientistTable/scientificComunity.pm
	$(NOECHO) $(POD2MAN) --section=1 --perm_rw=$(PERM_RW) \
	  bin/ngs_pipeline_backend.pl $(INST_MAN1DIR)/ngs_pipeline_backend.pl.$(MAN1EXT) \
	  bin/reportFluidigm.pl $(INST_MAN1DIR)/reportFluidigm.pl.$(MAN1EXT) 
	$(NOECHO) $(POD2MAN) --section=3 --perm_rw=$(PERM_RW) \
	  lib/NGS_pipeline/Model/HelpFile.pm $(INST_MAN3DIR)/NGS_pipeline::Model::HelpFile.$(MAN3EXT) \
	  lib/NGS_pipeline/Controller/experiments.pm $(INST_MAN3DIR)/NGS_pipeline::Controller::experiments.$(MAN3EXT) \
	  lib/NGS_pipeline/Model/OType_2_Action.pm $(INST_MAN3DIR)/NGS_pipeline::Model::OType_2_Action.$(MAN3EXT) \
	  lib/stefans_libs/NGS_pipeline/SGE_helper/mapper_general.pm $(INST_MAN3DIR)/stefans_libs::NGS_pipeline::SGE_helper::mapper_general.$(MAN3EXT) \
	  lib/NGS_pipeline/Model/SGE_Helper_Module.pm $(INST_MAN3DIR)/NGS_pipeline::Model::SGE_Helper_Module.$(MAN3EXT) \
	  lib/NGS_pipeline/Controller/help.pm $(INST_MAN3DIR)/NGS_pipeline::Controller::help.$(MAN3EXT) \
	  lib/NGS_pipeline/Controller/html_view.pm $(INST_MAN3DIR)/NGS_pipeline::Controller::html_view.$(MAN3EXT) \
	  lib/NGS_pipeline/Model/Action_Groups.pm $(INST_MAN3DIR)/NGS_pipeline::Model::Action_Groups.$(MAN3EXT) \
	  lib/stefans_libs/NGS_pipeline/SGE_helper.pm $(INST_MAN3DIR)/stefans_libs::NGS_pipeline::SGE_helper.$(MAN3EXT) \
	  lib/NGS_pipeline.pm $(INST_MAN3DIR)/NGS_pipeline.$(MAN3EXT) \
	  lib/NGS_pipeline/Controller/debug.pm $(INST_MAN3DIR)/NGS_pipeline::Controller::debug.$(MAN3EXT) \
	  lib/NGS_pipeline/Model/Fluidigm_Helper.pm $(INST_MAN3DIR)/NGS_pipeline::Model::Fluidigm_Helper.$(MAN3EXT) \
	  lib/NGS_pipeline/Model/Menu.pm $(INST_MAN3DIR)/NGS_pipeline::Model::Menu.$(MAN3EXT) \
	  lib/stefans_libs/NGS_pipeline/SGE_helper/Bowtie.pm $(INST_MAN3DIR)/stefans_libs::NGS_pipeline::SGE_helper::Bowtie.$(MAN3EXT) \
	  lib/NGS_pipeline/Model/work.pm $(INST_MAN3DIR)/NGS_pipeline::Model::work.$(MAN3EXT) \
	  lib/NGS_pipeline/Controller/Administration.pm $(INST_MAN3DIR)/NGS_pipeline::Controller::Administration.$(MAN3EXT) \
	  lib/stefans_libs/database_list_object.pm $(INST_MAN3DIR)/stefans_libs::database_list_object.$(MAN3EXT) \
	  lib/stefans_libs/database/scientistTable.pm $(INST_MAN3DIR)/stefans_libs::database::scientistTable.$(MAN3EXT) \
	  lib/NGS_pipeline/Model/ACL.pm $(INST_MAN3DIR)/NGS_pipeline::Model::ACL.$(MAN3EXT) \
	  lib/stefans_libs/NGS_pipeline/SGE_helper/HISAT.pm $(INST_MAN3DIR)/stefans_libs::NGS_pipeline::SGE_helper::HISAT.$(MAN3EXT) \
	  lib/NGS_pipeline/Model/Roles.pm $(INST_MAN3DIR)/NGS_pipeline::Model::Roles.$(MAN3EXT) \
	  lib/stefans_libs/WEB_Objects/scientistTable.pm $(INST_MAN3DIR)/stefans_libs::WEB_Objects::scientistTable.$(MAN3EXT) \
	  lib/NGS_pipeline/Controller/rna_seq.pm $(INST_MAN3DIR)/NGS_pipeline::Controller::rna_seq.$(MAN3EXT) \
	  lib/NGS_pipeline/Model/Experiment.pm $(INST_MAN3DIR)/NGS_pipeline::Model::Experiment.$(MAN3EXT) \
	  lib/stefans_libs/WEB_Objects/scientistTable/Role_List.pm $(INST_MAN3DIR)/stefans_libs::WEB_Objects::scientistTable::Role_List.$(MAN3EXT) \
	  lib/stefans_libs/database_object.pm $(INST_MAN3DIR)/stefans_libs::database_object.$(MAN3EXT) 
	$(NOECHO) $(POD2MAN) --section=3 --perm_rw=$(PERM_RW) \
	  lib/NGS_pipeline/base_db_controler.pm $(INST_MAN3DIR)/NGS_pipeline::base_db_controler.$(MAN3EXT) \
	  lib/NGS_pipeline/View/HTML.pm $(INST_MAN3DIR)/NGS_pipeline::View::HTML.$(MAN3EXT) \
	  lib/stefans_libs/NGS_pipeline/Menue.pm $(INST_MAN3DIR)/stefans_libs::NGS_pipeline::Menue.$(MAN3EXT) \
	  lib/NGS_pipeline/Controller/Fluidigm.pm $(INST_MAN3DIR)/NGS_pipeline::Controller::Fluidigm.$(MAN3EXT) \
	  lib/NGS_pipeline/Model/ofile.pm $(INST_MAN3DIR)/NGS_pipeline::Model::ofile.$(MAN3EXT) \
	  lib/stefans_libs/WEB_Objects/scientistTable/Action_List.pm $(INST_MAN3DIR)/stefans_libs::WEB_Objects::scientistTable::Action_List.$(MAN3EXT) \
	  lib/NGS_pipeline/Controller/utilities.pm $(INST_MAN3DIR)/NGS_pipeline::Controller::utilities.$(MAN3EXT) \
	  lib/NGS_pipeline/Controller/Root.pm $(INST_MAN3DIR)/NGS_pipeline::Controller::Root.$(MAN3EXT) \
	  lib/stefans_libs/NGS_pipeline/SGE_helper/STAR.pm $(INST_MAN3DIR)/stefans_libs::NGS_pipeline::SGE_helper::STAR.$(MAN3EXT) \
	  lib/stefans_libs/database/otype_2_CatalystAction.pm $(INST_MAN3DIR)/stefans_libs::database::otype_2_CatalystAction.$(MAN3EXT) \
	  lib/stefans_libs/database/scientistTable/scientificComunity.pm $(INST_MAN3DIR)/stefans_libs::database::scientistTable::scientificComunity.$(MAN3EXT) 




# --- MakeMaker processPL section:


# --- MakeMaker installbin section:

EXE_FILES = bin/ngs_pipeline_backend.pl bin/reportFluidigm.pl

pure_all :: $(INST_SCRIPT)/reportFluidigm.pl $(INST_SCRIPT)/ngs_pipeline_backend.pl
	$(NOECHO) $(NOOP)

realclean ::
	$(RM_F) \
	  $(INST_SCRIPT)/reportFluidigm.pl $(INST_SCRIPT)/ngs_pipeline_backend.pl 

$(INST_SCRIPT)/reportFluidigm.pl : bin/reportFluidigm.pl $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/reportFluidigm.pl
	$(CP) bin/reportFluidigm.pl $(INST_SCRIPT)/reportFluidigm.pl
	$(FIXIN) $(INST_SCRIPT)/reportFluidigm.pl
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/reportFluidigm.pl

$(INST_SCRIPT)/ngs_pipeline_backend.pl : bin/ngs_pipeline_backend.pl $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/ngs_pipeline_backend.pl
	$(CP) bin/ngs_pipeline_backend.pl $(INST_SCRIPT)/ngs_pipeline_backend.pl
	$(FIXIN) $(INST_SCRIPT)/ngs_pipeline_backend.pl
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/ngs_pipeline_backend.pl



# --- MakeMaker subdirs section:

# none

# --- MakeMaker clean_subdirs section:
clean_subdirs :
	$(NOECHO) $(NOOP)


# --- MakeMaker clean section:

# Delete temporary files but do not touch installed files. We don't delete
# the Makefile here so a later make realclean still has a makefile to use.

clean :: clean_subdirs
	- $(RM_F) \
	  perl core.[0-9] \
	  $(BASEEXT).x core.[0-9][0-9][0-9][0-9][0-9] \
	  blibdirs.ts MYMETA.json \
	  core.[0-9][0-9][0-9][0-9] $(MAKE_APERL_FILE) \
	  pm_to_blib.ts lib$(BASEEXT).def \
	  tmon.out core \
	  perlmain.c $(INST_ARCHAUTODIR)/extralibs.all \
	  core.[0-9][0-9] mon.out \
	  $(BASEEXT).exp $(BASEEXT).def \
	  *$(OBJ_EXT) MYMETA.yml \
	  so_locations *perl.core \
	  $(INST_ARCHAUTODIR)/extralibs.ld *$(LIB_EXT) \
	  perl.exe pm_to_blib \
	  $(BASEEXT).bso core.*perl.*.? \
	  core.[0-9][0-9][0-9] perl$(EXE_EXT) \
	  $(BOOTSTRAP) 
	- $(RM_RF) \
	  blib 
	- $(NOECHO) $(RM_F) $(MAKEFILE_OLD)
	- $(MV) $(FIRST_MAKEFILE) $(MAKEFILE_OLD) $(DEV_NULL)


# --- MakeMaker realclean_subdirs section:
realclean_subdirs :
	$(NOECHO) $(NOOP)


# --- MakeMaker realclean section:
# Delete temporary files (via clean) and also delete dist files
realclean purge ::  clean realclean_subdirs
	- $(RM_F) \
	  $(MAKEFILE_OLD) $(FIRST_MAKEFILE) 
	- $(RM_RF) \
	  MYMETA.yml $(DISTVNAME) 


# --- MakeMaker metafile section:
metafile :
	$(NOECHO) $(NOOP)


# --- MakeMaker signature section:
signature :
	cpansign -s


# --- MakeMaker dist_basics section:
distclean :: realclean distcheck
	$(NOECHO) $(NOOP)

distcheck :
	$(PERLRUN) "-MExtUtils::Manifest=fullcheck" -e fullcheck

skipcheck :
	$(PERLRUN) "-MExtUtils::Manifest=skipcheck" -e skipcheck

manifest :
	$(PERLRUN) "-MExtUtils::Manifest=mkmanifest" -e mkmanifest

veryclean : realclean
	$(RM_F) *~ */*~ *.orig */*.orig *.bak */*.bak *.old */*.old



# --- MakeMaker dist_core section:

dist : $(DIST_DEFAULT) $(FIRST_MAKEFILE)
	$(NOECHO) $(ABSPERLRUN) -l -e 'print '\''Warning: Makefile possibly out of date with $(VERSION_FROM)'\''' \
	  -e '    if -e '\''$(VERSION_FROM)'\'' and -M '\''$(VERSION_FROM)'\'' < -M '\''$(FIRST_MAKEFILE)'\'';' --

tardist : $(DISTVNAME).tar$(SUFFIX)
	$(NOECHO) $(NOOP)

uutardist : $(DISTVNAME).tar$(SUFFIX)
	uuencode $(DISTVNAME).tar$(SUFFIX) $(DISTVNAME).tar$(SUFFIX) > $(DISTVNAME).tar$(SUFFIX)_uu
	$(NOECHO) $(ECHO) 'Created $(DISTVNAME).tar$(SUFFIX)_uu'

$(DISTVNAME).tar$(SUFFIX) : distdir
	$(PREOP)
	$(TO_UNIX)
	$(TAR) $(TARFLAGS) $(DISTVNAME).tar $(DISTVNAME)
	$(RM_RF) $(DISTVNAME)
	$(COMPRESS) $(DISTVNAME).tar
	$(NOECHO) $(ECHO) 'Created $(DISTVNAME).tar$(SUFFIX)'
	$(POSTOP)

zipdist : $(DISTVNAME).zip
	$(NOECHO) $(NOOP)

$(DISTVNAME).zip : distdir
	$(PREOP)
	$(ZIP) $(ZIPFLAGS) $(DISTVNAME).zip $(DISTVNAME)
	$(RM_RF) $(DISTVNAME)
	$(NOECHO) $(ECHO) 'Created $(DISTVNAME).zip'
	$(POSTOP)

shdist : distdir
	$(PREOP)
	$(SHAR) $(DISTVNAME) > $(DISTVNAME).shar
	$(RM_RF) $(DISTVNAME)
	$(NOECHO) $(ECHO) 'Created $(DISTVNAME).shar'
	$(POSTOP)


# --- MakeMaker distdir section:
create_distdir :
	$(RM_RF) $(DISTVNAME)
	$(PERLRUN) "-MExtUtils::Manifest=manicopy,maniread" \
		-e "manicopy(maniread(),'$(DISTVNAME)', '$(DIST_CP)');"

distdir : create_distdir  
	$(NOECHO) $(NOOP)



# --- MakeMaker dist_test section:
disttest : distdir
	cd $(DISTVNAME) && $(ABSPERLRUN) Makefile.PL 
	cd $(DISTVNAME) && $(MAKE) $(PASTHRU)
	cd $(DISTVNAME) && $(MAKE) test $(PASTHRU)



# --- MakeMaker dist_ci section:

ci :
	$(PERLRUN) "-MExtUtils::Manifest=maniread" \
	  -e "@all = keys %{ maniread() };" \
	  -e "print(qq{Executing $(CI) @all\n}); system(qq{$(CI) @all});" \
	  -e "print(qq{Executing $(RCS_LABEL) ...\n}); system(qq{$(RCS_LABEL) @all});"


# --- MakeMaker distmeta section:
distmeta : create_distdir metafile
	$(NOECHO) cd $(DISTVNAME) && $(ABSPERLRUN) -MExtUtils::Manifest=maniadd -e 'exit unless -e q{META.yml};' \
	  -e 'eval { maniadd({q{META.yml} => q{Module YAML meta-data (added by MakeMaker)}}) }' \
	  -e '    or print "Could not add META.yml to MANIFEST: $$$${'\''@'\''}\n"' --
	$(NOECHO) cd $(DISTVNAME) && $(ABSPERLRUN) -MExtUtils::Manifest=maniadd -e 'exit unless -f q{META.json};' \
	  -e 'eval { maniadd({q{META.json} => q{Module JSON meta-data (added by MakeMaker)}}) }' \
	  -e '    or print "Could not add META.json to MANIFEST: $$$${'\''@'\''}\n"' --



# --- MakeMaker distsignature section:
distsignature : create_distdir
	$(NOECHO) cd $(DISTVNAME) && $(ABSPERLRUN) -MExtUtils::Manifest=maniadd -e 'eval { maniadd({q{SIGNATURE} => q{Public-key signature (added by MakeMaker)}}) }' \
	  -e '    or print "Could not add SIGNATURE to MANIFEST: $$$${'\''@'\''}\n"' --
	$(NOECHO) cd $(DISTVNAME) && $(TOUCH) SIGNATURE
	cd $(DISTVNAME) && cpansign -s



# --- MakeMaker install section:

install :: pure_install doc_install
	$(NOECHO) $(NOOP)

install_perl :: pure_perl_install doc_perl_install
	$(NOECHO) $(NOOP)

install_site :: pure_site_install doc_site_install
	$(NOECHO) $(NOOP)

install_vendor :: pure_vendor_install doc_vendor_install
	$(NOECHO) $(NOOP)

pure_install :: pure_$(INSTALLDIRS)_install
	$(NOECHO) $(NOOP)

doc_install :: doc_$(INSTALLDIRS)_install
	$(NOECHO) $(NOOP)

pure__install : pure_site_install
	$(NOECHO) $(ECHO) INSTALLDIRS not defined, defaulting to INSTALLDIRS=site

doc__install : doc_site_install
	$(NOECHO) $(ECHO) INSTALLDIRS not defined, defaulting to INSTALLDIRS=site

pure_perl_install :: all
	$(NOECHO) $(MOD_INSTALL) \
		read $(PERL_ARCHLIB)/auto/$(FULLEXT)/.packlist \
		write $(DESTINSTALLARCHLIB)/auto/$(FULLEXT)/.packlist \
		$(INST_LIB) $(DESTINSTALLPRIVLIB) \
		$(INST_ARCHLIB) $(DESTINSTALLARCHLIB) \
		$(INST_BIN) $(DESTINSTALLBIN) \
		$(INST_SCRIPT) $(DESTINSTALLSCRIPT) \
		$(INST_MAN1DIR) $(DESTINSTALLMAN1DIR) \
		$(INST_MAN3DIR) $(DESTINSTALLMAN3DIR)
	$(NOECHO) $(WARN_IF_OLD_PACKLIST) \
		$(SITEARCHEXP)/auto/$(FULLEXT)


pure_site_install :: all
	$(NOECHO) $(MOD_INSTALL) \
		read $(SITEARCHEXP)/auto/$(FULLEXT)/.packlist \
		write $(DESTINSTALLSITEARCH)/auto/$(FULLEXT)/.packlist \
		$(INST_LIB) $(DESTINSTALLSITELIB) \
		$(INST_ARCHLIB) $(DESTINSTALLSITEARCH) \
		$(INST_BIN) $(DESTINSTALLSITEBIN) \
		$(INST_SCRIPT) $(DESTINSTALLSITESCRIPT) \
		$(INST_MAN1DIR) $(DESTINSTALLSITEMAN1DIR) \
		$(INST_MAN3DIR) $(DESTINSTALLSITEMAN3DIR)
	$(NOECHO) $(WARN_IF_OLD_PACKLIST) \
		$(PERL_ARCHLIB)/auto/$(FULLEXT)

pure_vendor_install :: all
	$(NOECHO) $(MOD_INSTALL) \
		read $(VENDORARCHEXP)/auto/$(FULLEXT)/.packlist \
		write $(DESTINSTALLVENDORARCH)/auto/$(FULLEXT)/.packlist \
		$(INST_LIB) $(DESTINSTALLVENDORLIB) \
		$(INST_ARCHLIB) $(DESTINSTALLVENDORARCH) \
		$(INST_BIN) $(DESTINSTALLVENDORBIN) \
		$(INST_SCRIPT) $(DESTINSTALLVENDORSCRIPT) \
		$(INST_MAN1DIR) $(DESTINSTALLVENDORMAN1DIR) \
		$(INST_MAN3DIR) $(DESTINSTALLVENDORMAN3DIR)

doc_perl_install :: all
	$(NOECHO) $(ECHO) Appending installation info to $(DESTINSTALLARCHLIB)/perllocal.pod
	-$(NOECHO) $(MKPATH) $(DESTINSTALLARCHLIB)
	-$(NOECHO) $(DOC_INSTALL) \
		"Module" "$(NAME)" \
		"installed into" "$(INSTALLPRIVLIB)" \
		LINKTYPE "$(LINKTYPE)" \
		VERSION "$(VERSION)" \
		EXE_FILES "$(EXE_FILES)" \
		>> $(DESTINSTALLARCHLIB)/perllocal.pod

doc_site_install :: all
	$(NOECHO) $(ECHO) Appending installation info to $(DESTINSTALLARCHLIB)/perllocal.pod
	-$(NOECHO) $(MKPATH) $(DESTINSTALLARCHLIB)
	-$(NOECHO) $(DOC_INSTALL) \
		"Module" "$(NAME)" \
		"installed into" "$(INSTALLSITELIB)" \
		LINKTYPE "$(LINKTYPE)" \
		VERSION "$(VERSION)" \
		EXE_FILES "$(EXE_FILES)" \
		>> $(DESTINSTALLARCHLIB)/perllocal.pod

doc_vendor_install :: all
	$(NOECHO) $(ECHO) Appending installation info to $(DESTINSTALLARCHLIB)/perllocal.pod
	-$(NOECHO) $(MKPATH) $(DESTINSTALLARCHLIB)
	-$(NOECHO) $(DOC_INSTALL) \
		"Module" "$(NAME)" \
		"installed into" "$(INSTALLVENDORLIB)" \
		LINKTYPE "$(LINKTYPE)" \
		VERSION "$(VERSION)" \
		EXE_FILES "$(EXE_FILES)" \
		>> $(DESTINSTALLARCHLIB)/perllocal.pod


uninstall :: uninstall_from_$(INSTALLDIRS)dirs
	$(NOECHO) $(NOOP)

uninstall_from_perldirs ::
	$(NOECHO) $(UNINSTALL) $(PERL_ARCHLIB)/auto/$(FULLEXT)/.packlist

uninstall_from_sitedirs ::
	$(NOECHO) $(UNINSTALL) $(SITEARCHEXP)/auto/$(FULLEXT)/.packlist

uninstall_from_vendordirs ::
	$(NOECHO) $(UNINSTALL) $(VENDORARCHEXP)/auto/$(FULLEXT)/.packlist


# --- MakeMaker force section:
# Phony target to force checking subdirectories.
FORCE :
	$(NOECHO) $(NOOP)


# --- MakeMaker perldepend section:


# --- MakeMaker makefile section:
# We take a very conservative approach here, but it's worth it.
# We move Makefile to Makefile.old here to avoid gnu make looping.
$(FIRST_MAKEFILE) : Makefile.PL $(CONFIGDEP)
	$(NOECHO) $(ECHO) "Makefile out-of-date with respect to $?"
	$(NOECHO) $(ECHO) "Cleaning current config before rebuilding Makefile..."
	-$(NOECHO) $(RM_F) $(MAKEFILE_OLD)
	-$(NOECHO) $(MV)   $(FIRST_MAKEFILE) $(MAKEFILE_OLD)
	- $(MAKE) $(USEMAKEFILE) $(MAKEFILE_OLD) clean $(DEV_NULL)
	$(PERLRUN) Makefile.PL 
	$(NOECHO) $(ECHO) "==> Your Makefile has been rebuilt. <=="
	$(NOECHO) $(ECHO) "==> Please rerun the $(MAKE) command.  <=="
	$(FALSE)



# --- MakeMaker staticmake section:

# --- MakeMaker makeaperl section ---
MAP_TARGET    = perl
FULLPERL      = /usr/bin/perl

$(MAP_TARGET) :: static $(MAKE_APERL_FILE)
	$(MAKE) $(USEMAKEFILE) $(MAKE_APERL_FILE) $@

$(MAKE_APERL_FILE) : $(FIRST_MAKEFILE) pm_to_blib
	$(NOECHO) $(ECHO) Writing \"$(MAKE_APERL_FILE)\" for this $(MAP_TARGET)
	$(NOECHO) $(PERLRUNINST) \
		Makefile.PL DIR= \
		MAKEFILE=$(MAKE_APERL_FILE) LINKTYPE=static \
		MAKEAPERL=1 NORECURS=1 CCCDLFLAGS=


# --- MakeMaker test section:

TEST_VERBOSE=0
TEST_TYPE=test_$(LINKTYPE)
TEST_FILE = test.pl
TEST_FILES = t/001_db_2.1.0_scientistTable.t t/001_db_2.1.1_stefans_libs_database_workload.t t/006_WEB_object_scientistTable.t t/01app.t t/02pod.t t/03podcoverage.t t/controller_chip_seq.t t/controller_debug.t t/controller_dna_seq.t t/controller_experiments.t t/controller_rna_seq.t t/controller_utilities.t t/model_Fluidigm_Helper_reciever.t t/model_Fluidigm_Helper_sender.t t/model_OType_2_Action.t t/ngs_backend.t t/stefans_libs_database_otype_2_CatalystAction.t t/stefans_libs_database_process_finished.t t/stefans_libs_database_workload_outfiles.t t/stefans_libs_NGS_pipeline_SGE_helper.t t/stefans_libs_NGS_pipeline_SGE_helper_Bowtie.t t/stefans_libs_NGS_pipeline_SGE_helper_HISAT.t t/stefans_libs_NGS_pipeline_SGE_helper_mapper_general.t t/stefans_libs_NGS_pipeline_SGE_helper_STAR.t
TESTDB_SW = -d

testdb :: testdb_$(LINKTYPE)

test :: $(TEST_TYPE) subdirs-test

subdirs-test ::
	$(NOECHO) $(NOOP)


test_dynamic :: pure_all
	PERL_DL_NONLAZY=1 $(FULLPERLRUN) "-MExtUtils::Command::MM" "-MTest::Harness" "-e" "undef *Test::Harness::Switches; test_harness($(TEST_VERBOSE), 'inc', '$(INST_LIB)', '$(INST_ARCHLIB)')" $(TEST_FILES)
	PERL_DL_NONLAZY=1 $(FULLPERLRUN) "-Iinc" "-I$(INST_LIB)" "-I$(INST_ARCHLIB)" $(TEST_FILE)

testdb_dynamic :: pure_all
	PERL_DL_NONLAZY=1 $(FULLPERLRUN) $(TESTDB_SW) "-Iinc" "-I$(INST_LIB)" "-I$(INST_ARCHLIB)" $(TEST_FILE)

test_ : test_dynamic

test_static :: test_dynamic
testdb_static :: testdb_dynamic


# --- MakeMaker ppd section:
# Creates a PPD (Perl Package Description) for a binary distribution.
ppd :
	$(NOECHO) $(ECHO) '<SOFTPKG NAME="$(DISTNAME)" VERSION="$(VERSION)">' > $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '    <ABSTRACT>Catalyst based application</ABSTRACT>' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '    <AUTHOR>Stefan Lang</AUTHOR>' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '    <IMPLEMENTATION>' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Catalyst::Action::RenderView" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Catalyst::Authentication::User" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Catalyst::Plugin::ConfigLoader" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Catalyst::Plugin::FormBuilder" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Catalyst::Plugin::RequireSSL" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Catalyst::Plugin::Session::State::Cookie" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Catalyst::Plugin::Session::Store::FastMmap" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Catalyst::Plugin::Static::Simple" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE VERSION="5.90019" NAME="Catalyst::Runtime" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Catalyst::View::TT" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Config::General" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="File::HomeDir" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="HTML::Template" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Moose::" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Proc::Daemon" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Stefans_Libs_Essentials::" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="namespace::autoclean" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <ARCHITECTURE NAME="x86_64-linux-thread-multi-5.18" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <CODEBASE HREF="" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '    </IMPLEMENTATION>' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '</SOFTPKG>' >> $(DISTNAME).ppd


# --- MakeMaker pm_to_blib section:

pm_to_blib : $(FIRST_MAKEFILE) $(TO_INST_PM)
	$(NOECHO) $(ABSPERLRUN) -MExtUtils::Install -e 'pm_to_blib({@ARGV}, '\''$(INST_LIB)/auto'\'', q[$(PM_FILTER)], '\''$(PERM_DIR)'\'')' -- \
	  lib/NGS_pipeline/Model/Experiment.pm blib/lib/NGS_pipeline/Model/Experiment.pm \
	  lib/stefans_libs/database/scientistTable/role_list.pm blib/lib/stefans_libs/database/scientistTable/role_list.pm \
	  lib/NGS_pipeline/base_db_controler.pm blib/lib/NGS_pipeline/base_db_controler.pm \
	  lib/stefans_libs/database_object.pm blib/lib/stefans_libs/database_object.pm \
	  lib/stefans_libs/WEB_Objects/scientistTable/Role_List.pm blib/lib/stefans_libs/WEB_Objects/scientistTable/Role_List.pm \
	  lib/stefans_libs/database/workload.pm blib/lib/stefans_libs/database/workload.pm \
	  lib/NGS_pipeline/Controller/rna_seq.pm blib/lib/NGS_pipeline/Controller/rna_seq.pm \
	  lib/stefans_libs/database/scientistTable/temporary_banned.pm blib/lib/stefans_libs/database/scientistTable/temporary_banned.pm \
	  lib/stefans_libs/WEB_Objects/scientistTable.pm blib/lib/stefans_libs/WEB_Objects/scientistTable.pm \
	  lib/NGS_pipeline/Model/Roles.pm blib/lib/NGS_pipeline/Model/Roles.pm \
	  lib/stefans_libs/NGS_pipeline/SGE_helper/HISAT.pm blib/lib/stefans_libs/NGS_pipeline/SGE_helper/HISAT.pm \
	  lib/stefans_libs/database/scientistTable/scientificComunity.pm blib/lib/stefans_libs/database/scientistTable/scientificComunity.pm \
	  lib/stefans_libs/database/otype_2_CatalystAction.pm blib/lib/stefans_libs/database/otype_2_CatalystAction.pm \
	  lib/NGS_pipeline/Controller/utilities.pm blib/lib/NGS_pipeline/Controller/utilities.pm \
	  lib/stefans_libs/NGS_pipeline/SGE_helper/STAR.pm blib/lib/stefans_libs/NGS_pipeline/SGE_helper/STAR.pm \
	  lib/NGS_pipeline/Controller/Root.pm blib/lib/NGS_pipeline/Controller/Root.pm \
	  lib/stefans_libs/database/scientistTable/action_groups.pm blib/lib/stefans_libs/database/scientistTable/action_groups.pm \
	  lib/stefans_libs/WEB_Objects/scientistTable/Action_List.pm blib/lib/stefans_libs/WEB_Objects/scientistTable/Action_List.pm \
	  lib/NGS_pipeline/Model/ofile.pm blib/lib/NGS_pipeline/Model/ofile.pm \
	  lib/stefans_libs/NGS_pipeline/Menue.pm blib/lib/stefans_libs/NGS_pipeline/Menue.pm \
	  lib/NGS_pipeline/Controller/Fluidigm.pm blib/lib/NGS_pipeline/Controller/Fluidigm.pm \
	  lib/NGS_pipeline/View/HTML.pm blib/lib/NGS_pipeline/View/HTML.pm \
	  lib/stefans_libs/database/scientistTable/CatalystUser.pm blib/lib/stefans_libs/database/scientistTable/CatalystUser.pm \
	  lib/stefans_libs/NGS_pipeline/SGE_helper/Bowtie.pm blib/lib/stefans_libs/NGS_pipeline/SGE_helper/Bowtie.pm \
	  lib/NGS_pipeline/Model/Action_Groups.pm blib/lib/NGS_pipeline/Model/Action_Groups.pm \
	  lib/stefans_libs/NGS_pipeline/SGE_helper.pm blib/lib/stefans_libs/NGS_pipeline/SGE_helper.pm \
	  lib/NGS_pipeline/Controller/html_view.pm blib/lib/NGS_pipeline/Controller/html_view.pm 
	$(NOECHO) $(ABSPERLRUN) -MExtUtils::Install -e 'pm_to_blib({@ARGV}, '\''$(INST_LIB)/auto'\'', q[$(PM_FILTER)], '\''$(PERM_DIR)'\'')' -- \
	  lib/NGS_pipeline/Model/Fluidigm_Helper.pm blib/lib/NGS_pipeline/Model/Fluidigm_Helper.pm \
	  lib/stefans_libs/database/experimentTable.pm blib/lib/stefans_libs/database/experimentTable.pm \
	  lib/NGS_pipeline/Model/Menu.pm blib/lib/NGS_pipeline/Model/Menu.pm \
	  lib/NGS_pipeline/Controller/debug.pm blib/lib/NGS_pipeline/Controller/debug.pm \
	  lib/NGS_pipeline.pm blib/lib/NGS_pipeline.pm \
	  lib/stefans_libs/NGS_pipeline/SGE_helper/mapper_general.pm blib/lib/stefans_libs/NGS_pipeline/SGE_helper/mapper_general.pm \
	  lib/NGS_pipeline/Model/SGE_Helper_Module.pm blib/lib/NGS_pipeline/Model/SGE_Helper_Module.pm \
	  lib/NGS_pipeline/Controller/help.pm blib/lib/NGS_pipeline/Controller/help.pm \
	  lib/NGS_pipeline/Controller/experiments.pm blib/lib/NGS_pipeline/Controller/experiments.pm \
	  lib/stefans_libs/database/process_finished.pm blib/lib/stefans_libs/database/process_finished.pm \
	  lib/NGS_pipeline/Model/HelpFile.pm blib/lib/NGS_pipeline/Model/HelpFile.pm \
	  lib/NGS_pipeline/Model/OType_2_Action.pm blib/lib/NGS_pipeline/Model/OType_2_Action.pm \
	  lib/stefans_libs/database/scientistTable/action_group_list.pm blib/lib/stefans_libs/database/scientistTable/action_group_list.pm \
	  lib/NGS_pipeline/Model/ACL.pm blib/lib/NGS_pipeline/Model/ACL.pm \
	  lib/stefans_libs/database/scientistTable.pm blib/lib/stefans_libs/database/scientistTable.pm \
	  lib/stefans_libs/database/outfiles.pm blib/lib/stefans_libs/database/outfiles.pm \
	  lib/stefans_libs/database_list_object.pm blib/lib/stefans_libs/database_list_object.pm \
	  lib/NGS_pipeline/Controller/Administration.pm blib/lib/NGS_pipeline/Controller/Administration.pm \
	  lib/NGS_pipeline/Model/work.pm blib/lib/NGS_pipeline/Model/work.pm \
	  lib/stefans_libs/database/scientistTable/roles.pm blib/lib/stefans_libs/database/scientistTable/roles.pm 
	$(NOECHO) $(TOUCH) pm_to_blib


# --- MakeMaker selfdocument section:


# --- MakeMaker postamble section:


# End.
# Postamble by Module::Install 1.12
catalyst_par :: all
	$(NOECHO) $(PERL) -Ilib -Minc::Module::Install -MModule::Install::Catalyst -e"Catalyst::Module::Install::_catalyst_par( '', 'NGS_pipeline', { CLASSES => [], PAROPTS =>  {}, ENGINE => 'CGI', SCRIPT => '', USAGE => q## } )"
# --- Module::Install::AutoInstall section:

config :: installdeps
	$(NOECHO) $(NOOP)

checkdeps ::
	$(PERL) Makefile.PL --checkdeps

installdeps ::
	$(NOECHO) $(NOOP)

installdeps_notest ::
	$(NOECHO) $(NOOP)

upgradedeps ::
	$(PERL) Makefile.PL --config= --upgradedeps=Test::More,0.88,Catalyst::Runtime,5.90019,Catalyst::Plugin::ConfigLoader,0,Catalyst::Plugin::Static::Simple,0,Catalyst::Action::RenderView,0,Moose,0,Proc::Daemon,0,namespace::autoclean,0,Config::General,0,Catalyst::Plugin::Session::State::Cookie,0,Catalyst::Plugin::Session::Store::FastMmap,0,HTML::Template,0,Catalyst::Plugin::FormBuilder,0,Catalyst::View::TT,0,Stefans_Libs_Essentials,0,File::HomeDir,0,Catalyst::Authentication::User,0,Catalyst::Plugin::RequireSSL,0

upgradedeps_notest ::
	$(PERL) Makefile.PL --config=notest,1 --upgradedeps=Test::More,0.88,Catalyst::Runtime,5.90019,Catalyst::Plugin::ConfigLoader,0,Catalyst::Plugin::Static::Simple,0,Catalyst::Action::RenderView,0,Moose,0,Proc::Daemon,0,namespace::autoclean,0,Config::General,0,Catalyst::Plugin::Session::State::Cookie,0,Catalyst::Plugin::Session::Store::FastMmap,0,HTML::Template,0,Catalyst::Plugin::FormBuilder,0,Catalyst::View::TT,0,Stefans_Libs_Essentials,0,File::HomeDir,0,Catalyst::Authentication::User,0,Catalyst::Plugin::RequireSSL,0

listdeps ::
	@$(PERL) -le "print for @ARGV" 

listalldeps ::
	@$(PERL) -le "print for @ARGV" Test::More Catalyst::Runtime Catalyst::Plugin::ConfigLoader Catalyst::Plugin::Static::Simple Catalyst::Action::RenderView Moose Proc::Daemon namespace::autoclean Config::General Catalyst::Plugin::Session::State::Cookie Catalyst::Plugin::Session::Store::FastMmap HTML::Template Catalyst::Plugin::FormBuilder Catalyst::View::TT Stefans_Libs_Essentials File::HomeDir Catalyst::Authentication::User Catalyst::Plugin::RequireSSL

