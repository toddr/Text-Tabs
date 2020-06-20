use warnings;

#Author: Dan Dascalescu
use strict;
print "1..1\n";
sub _ok { ( 'not ' x !$_[0] ) . 'ok' . ( $_[1] ? " - $_[1]" : '' ) . "\n" }

use Text::Wrap;

local $Text::Wrap::columns = 15;
local $Text::Wrap::separator2 = '[N]';

print _ok(wrap('','','some long text here that should be wrapped on at least three lines') eq
"some long text[N]here that[N]should be[N]wrapped on at[N]least three[N]lines",
'If you just to preserve existing newlines but add new breaks with something else, set $Text::Wrap::separator2 instead.');
