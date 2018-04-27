package Text::Tabs;

require Exporter;

@ISA = (Exporter);
@EXPORT = qw(expand unexpand $tabstop);

use vars qw($VERSION $SUBVERSION $tabstop $debug);
$VERSION = 2013.0523;
$SUBVERSION = 'modern'; # back-compat vestige

use strict;

use 5.010_000;

BEGIN	{
	$tabstop = 8;
	$debug = 0;
}

sub expand {
	my @l;
	my $pad;
	for ( @_ ) {
		my $s = '';
		for (split(/^/m, $_, -1)) {
			my $offs = 0;
			s{\t}{
			    # this works on both 5.10 and 5.11
				$pad = $tabstop - (_xlen(${^PREMATCH}) + $offs) % $tabstop;
			    # this works on 5.11, but fails on 5.10
				#XXX# $pad = $tabstop - (_xpos() + $offs) % $tabstop;
				$offs += $pad - 1;
				" " x $pad;
			}peg;
			$s .= $_;
		}
		push(@l, $s);
	}
	return @l if wantarray;
	return $l[0];
}

sub unexpand
{
	my (@l) = @_;
	my @e;
	my $x;
	my $line;
	my @lines;
	my $lastbit;
	my $ts_as_space = " " x $tabstop;
	for $x (@l) {
		@lines = split("\n", $x, -1);
		for $line (@lines) {
			$line = expand($line);
			@e = split(/(${CHUNK}{$tabstop})/,$line,-1);
			$lastbit = pop(@e);
			$lastbit = '' 
				unless defined $lastbit;
			$lastbit = "\t"
				if $lastbit eq $ts_as_space;
			for $_ (@e) {
				if ($debug) {
					my $x = $_;
					$x =~ s/\t/^I\t/gs;
					print "sub on '$x'\n";
				}
				s/  +$/\t/;
			}
			$line = join('',@e, $lastbit);
		}
		$x = join("\n", @lines);
	}
	return @l if wantarray;
	return $l[0];
}

1;

__END__

=head1 NAME

Text::Tabs - expand and unexpand tabs like unix expand(1) and unexpand(1)

=head1 SYNOPSIS

  use Text::Tabs;

  $tabstop = 4;  # default = 8
  @lines_without_tabs = expand(@lines_with_tabs);
  @lines_with_tabs = unexpand(@lines_without_tabs);

=head1 DESCRIPTION

Text::Tabs does most of what the unix utilities expand(1) and unexpand(1) 
do.  Given a line with tabs in it, C<expand> replaces those tabs with
the appropriate number of spaces.  Given a line with or without tabs in
it, C<unexpand> adds tabs when it can save bytes by doing so, 
like the C<unexpand -a> command.  

Unlike the old unix utilities, this module correctly accounts for
any Unicode combining characters (such as diacriticals) that may occur
in each line for both expansion and unexpansion.  These are overstrike
characters that do not increment the logical position.  Make sure
you have the appropriate Unicode settings enabled.

=head1 INTERFACE

The following are exported:

=pod

=head2 expand

=head2 unexpand

=head2 $tabstop

The C<$tabstop> variable controls how many column positions apart each
tabstop is.  The default is 8.

Please note that C<local($tabstop)> doesn't do the right thing and if you want
to use C<local> to override C<$tabstop>, you need to use
C<local($Text::Tabs::tabstop)>.

=head1 BUGS

Text::Tabs handles only tabs (C<"\t">) and combining characters (C</\pM/>).  It doesn't
count backwards for backspaces (C<"\t">), omit other non-printing control characters (C</\pC/>),
or otherwise deal with any other zero-, half-, and full-width characters.

=head1 LICENSE

Copyright (C) 1996-2002,2005,2006 David Muir Sharnoff.  
Copyright (C) 2005 Aristotle Pagaltzis 
Copyright (C) 2012-2013 Google, Inc.

This module may be modified, used, copied, and redistributed at your own risk.
Although allowed by the preceding license, please do not publicly
redistribute modified versions of this code with the name "Text::Tabs"
unless it passes the unmodified Text::Tabs test suite.
