package Text::Wrap;

require Exporter;

@ISA = (Exporter);
@EXPORT = qw(wrap fill);
@EXPORT_OK = qw($columns);

$VERSION = 96.041801;

use vars qw($VERSION $columns $debug);
use strict;

BEGIN	{
	$columns = 76;  # <= screen width
	$debug = 0;
}

use Text::Tabs;

sub wrap
{
	my ($ip, $xp, @t) = @_;

	my $r = "";
	my $t = expand(join(" ",@t));
	my $lead = $ip;
	my $ll = $columns - length(expand($lead)) - 1;
	my $nl = "";

	# remove up to a line length of things that aren't
	# new lines and tabs.

	if ($t =~ s/^([^\n]{0,$ll})(\s|\Z(?!\n))//xm) {

		# accept it.
		$r .= unexpand($lead . $1);

		# recompute the leader
		$lead = $xp;
		$ll = $columns - length(expand($lead)) - 1;
		$nl = $2;

		# repeat the above until there's none left
		while ($t and $t =~ s/^([^\n]{0,$ll})(\s|\Z(?!\n))//xm) {
			print "\$2 is '$2'\n" if $debug;
			$nl = $2;
			$r .= unexpand("\n" . $lead . $1);
		}
		$r .= $nl;
	} 

	die "couldn't wrap '$t'" 
		if length($t) > $ll;

	print "-----------$r---------\n" if $debug;

	print "Finish up with '$lead', '$t'\n" if $debug;

	$r .= $lead . $t if $t ne "";

	print "-----------$r---------\n" if $debug;;
	return $r;
}

sub fill 
{
	my ($ip, $xp, @raw) = @_;
	my @para;
	my $pp;

	for $pp (split(/\n\s+/, join("\n",@raw))) {
		$pp =~ s/\s+/ /g;
		my $x = wrap($ip, $xp, $pp);
		push(@para, $x);
	}

	# if paragraph_indent is the same as line_indent, 
	# separate paragraphs with blank lines

	return join ($ip eq $xp ? "\n\n" : "\n", @para);
}


1;
__DATA__

=head1 NAME

Text::Wrap - line wrapping to form simple paragraphs

=head1 SYNOPSIS 

	use Text::Wrap

	print wrap($initial_tab, $subsequent_tab, @text);
	print fill($initial_tab, $subsequent_tab, @text);

	use Text::Wrap qw(wrap fill $columns);

	$columns = 132;

=head1 DESCRIPTION

Text::Wrap::wrap() is a very simple paragraph formatter.  It formats a
single paragraph at a time by breaking lines at word boundries.
Indentation is controlled for the first line ($initial_tab) and
all subsquent lines ($subsequent_tab) independently.  $Text::Wrap::columns
should be set to the full width of your output device.

Text::Wrap::fill() is a simple multi-paragraph formatter.  It formats
each paragraph separately and then joins them together when it's done.  It
will destory any whitespace in the original text.  It breaks text into
paragraphs by looking for whitespace after a newline.  In other respects
it acts like wrap().

=head1 EXAMPLE

	print wrap("\t","","This is a bit of text that forms 
		a normal book-style paragraph");

	print fill("", "", `cat book`);

=head1 AUTHOR

David Muir Sharnoff <muir@idiom.com> with help from Tim Pierce and
others.

=cut
