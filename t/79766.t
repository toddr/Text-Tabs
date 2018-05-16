use warnings;
use strict;
use Text::Wrap;
print "1..2\n";
sub _ok { ( 'not ' x !$_[0] ) . 'ok' . ( $_[1] ? " - $_[1]" : '' ) . "\n" }

my $r;
my $s = q{xx xxxxxxxx xxxxxxxxx xx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=xxxxxxxxxxxxxxxxxxxxxxxx};

eval { $r = wrap("", "", $s) };
print _ok(!$@, $@);
print _ok($r eq "xx xxxxxxxx xxxxxxxxx xx
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=xxxxxxxxxxxxx
xxxxxxxxxxx", "match");
