use Text::Wrap;
print "1..2\n";
sub _ok { ( 'not ' x !$_[0] ) . 'ok' . ( $_[1] ? " - $_[1]" : '' ) . "\n" }
$Text::Wrap::columns = 4;
eval { $x = Text::Wrap::wrap('', '123', 'some text'); };
print _ok(!$@);
print _ok($x eq "some\n123t\n123e\n123x\n123t");
