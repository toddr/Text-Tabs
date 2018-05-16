use 5.006; use strict; use warnings;
use ExtUtils::MakeMaker;

sub MY::postamble { <<'' }
create_distdir : MANIFEST
distdir        : MANIFEST
MANIFEST :
	( echo MANIFEST ; git ls-files ) | sort -f > MANIFEST

my $u = 'github.com/ap/Text-Tabs';

my	%WriteMakefileArgs = (
	'NAME'		=> 'Text-Wrap',
	'DISTNAME'	  => 'Text-Tabs+Wrap',

	VERSION_FROM       => 'lib/Text/Tabs.pm',
	ABSTRACT           => 'Expand tabs and do simple line wrapping',
	AUTHOR             => 'David Muir Sharnoff <muir@idiom.org>',
	META_MERGE         => {
		'meta-spec'    => { version => 2 },
		resources      => {
			repository => { type => 'git', url => "git://$u.git", web => "https://$u" },
			bugtracker => { web => "https://$u/issues" },
		},
	},
	INSTALLDIRS        => ( "$]" >= 5.011 ? 'site' : 'perl' ),
);

delete $WriteMakefileArgs{'META_MERGE'}
	unless eval { ExtUtils::MakeMaker->VERSION(6.46) };

WriteMakefile(%WriteMakefileArgs);
