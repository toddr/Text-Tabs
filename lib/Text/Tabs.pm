use strict;

package Text::Tabs;

require Exporter;

our @ISA = qw(Exporter);
our @EXPORT = qw(expand unexpand $tabstop);

our $VERSION = 2013.0523;
our $SUBVERSION = 'modern'; # back-compat vestige

use 5.010_000;

our $tabstop = 8;

sub expand {
	my @l;
	for ( @_ ) {
		push @l, '';
		while ( /\G(.*?)(^|\z|\t)/smg ) {
			$l[-1] .= $1;
			$l[-1] .= ' ' x ( $tabstop - (() = "$1" =~ /\X/g) % $tabstop ) if $2;
		}
	}
	wantarray ? @l : $l[0];
}

sub unexpand
{
	my @l = &expand;
	for ( @l ) {
		s[((?:(?![\r\n])\X){$tabstop})]{
			my $c = $1, my $chr;
			if ( '  ' eq substr $c, -2 ) {
				do { $chr = chop $c } while ' ' eq $chr;
				$c . $chr . "\t";
			}
			else { $1 }
		}eg;
	}
	wantarray ? @l : $l[0];
}

1;

__END__

=head1 NAME

Text::Tabs - convert between tabs and multiple spaces

=head1 SYNOPSIS

 perl -CS -MText::Tabs -pe '$_ = expand $_'   -- stuff.txt in-utf8.txt
 perl -CS -MText::Tabs -pe '$_ = unexpand $_' -- stuff.txt in-utf8.txt

=head1 DESCRIPTION

This module provides functions for converting tabs to multiple spaces and vice
versa, named after the corresponding Unix utilities, expand(1) and unexpand(1).
It includes basic Unicode support by ignoring combining marks when calculating
the column position.

=head1 INTERFACE

All symbols are exported by default.

=head2 expand

Takes a list of strings and converts each of them by
replacing tabs with spaces.

Returns the list of converted strings in list context,
or just the first string in scalar context.

=head2 unexpand

Takes a list of strings and converts each of them by
substituting a tab for every sequence of multiple spaces that reaches a tabstop.

Returns the list of converted strings in list context,
or just the first string in scalar context.

=head2 $tabstop

The number of character columns per table column (default: 8).

B<Caveat coder>:
because of how exporting works (by putting references in glob slots)
and how L<local|perlfunc/local> works (by shadowing a slot in a container (e.g. a glob)),
you will not get the result you expect from C<local $tabstop>:
it will affect the C<*tabstop> glob in your own package but not the one in C<Text::Tabs>,
so C<expand>/C<unexpand> will not see the overriden value.
Instead, you will have to use C<local $Text::Tabs::tabstop>. Sorry.

=head1 BUGS

Unlike the Unix utilities, backspaces do not decrement the column position.

Unicode support is limited:
no ignoring of various non-printing Unicode characters (L<C<\pC>|perluniprops>)
and nothing special is done for zero-/half-/full-width characters.

Exporting C<$tabstop> was a now-unfixable mistake.

=head1 LICENSE

This software is copyright (c) 2018 by Aristotle Pagaltzis.

This is free software; you can redistribute it and/or modify it under the same terms as the Perl 5 programming language system itself.
