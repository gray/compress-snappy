#!/usr/bin/env perl
use strict;
use warnings;

use Benchmark qw(cmpthese);
use Getopt::Long qw(GetOptions :config no_ignore_case);

use Compress::LZF    ();
use Compress::Snappy ();
use Compress::Zlib   ();

my %opts = (
    iterations => -1,
    size       => 1,  # kB
);
GetOptions(\%opts, 'iterations|i=i', 'size|s=f',);

my $data = '01234567' x (128 * $opts{size});

printf "Compression (%s KiB)\n%s\n", $opts{size}, '-'x80;
cmpthese $opts{iterations}, {
    lzf    => sub { Compress::LZF::compress($data) },
    snappy => sub { Compress::Snappy::compress($data) },
    zlib   => sub { Compress::Zlib::compress($data) },
};

my $lzf    = Compress::LZF::compress($data);
my $snappy = Compress::Snappy::compress($data);
my $zlib   = Compress::Zlib::compress($data);

printf "\nDecompression (%s KiB)\n%s\n", $opts{size}, '-'x80;
cmpthese $opts{iterations}, {
    lzf    => sub { Compress::LZF::decompress($lzf) },
    snappy => sub { Compress::Snappy::decompress($snappy) },
    zlib   => sub { Compress::Zlib::uncompress($zlib) },
};
