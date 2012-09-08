use strict;
use warnings;
use Test::More;
use Compress::Snappy;

{
    no warnings 'uninitialized';
    my $compressed = compress(undef);
    my $decompressed = decompress($compressed);
    is($decompressed, '', 'undef');
}

for my $len (0 .. 1_024) {
    my $in = '0' x $len;
    my $compressed = compress($in);
    my $decompressed = decompress($compressed);
    is($decompressed, $in, "length: $len");
}

{
    my $scalar = '0' x 1_024;
    ok compress($scalar) eq compress(\$scalar), 'scalar ref';
}

{
    package TrimmedString;
    sub new { bless(\"$_[1]", $_[0]) }
    use overload q("") => \&str;
    sub str { s/^\s+//, s/\s+$// for $_ = "${$_[0]}"; $_ }

    package main;
    my $scalar = TrimmedString->new('  string  ');
    ok compress($scalar) eq compress('string'), 'blessed scalar ref';
}

done_testing;
