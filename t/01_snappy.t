use strict;
use warnings;
use Test::More;
use Compress::Snappy;

my $in = 'test' x 200;
my $compressed = compress($in);
my $decompressed = decompress($compressed);
is($decompressed, $in);

done_testing;
