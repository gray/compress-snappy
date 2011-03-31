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

my $scalar = '0' x 1_024;
ok(compress($scalar) eq compress(\$scalar), 'scalar ref');

done_testing;
