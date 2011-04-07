#!/usr/bin/env perl
use strict;
use warnings;

use Benchmark qw(timethese);
use Getopt::Long qw(GetOptions :config no_ignore_case);
use List::Util qw(max);

# Install Task::Digest
use Compress::LZF    ();
use Compress::Snappy ();
use Compress::Zlib   ();

my %opts = (
    iterations => -1,
    size       => 1,  # kB
);
GetOptions(\%opts, 'iterations|i=i', 'size|s=f',);

my $data = '0' x (1_024 * $opts{size});

my %compress = (
    'Compress::LZF::compress'    => sub { Compress::LZF::compress($data) },
    'Compress::Snappy::compress' => sub { Compress::Snappy::compress($data) },
    'Compress::Zlib::compress'   => sub { Compress::Zlib::compress($data) },
);

my $lzf    = Compress::LZF::compress($data);
my $snappy = Compress::Snappy::compress($data);
my $zlib   = Compress::Zlib::compress($data);

my %decompress = (
    'Compress::LZF::decompress' => sub { Compress::LZF::decompress($lzf) },
    'Compress::Snappy::decompress' =>
        sub { Compress::Snappy::decompress($snappy) },
    'Compress::Snappy::uncompress' =>
        sub { Compress::Zlib::uncompress($zlib) },
);

print "Compressible data - compression\n", '-'x31, "\n";
run(\%compress);
print "\n";
print "Compressible data - decompression\n", '-'x33, "\n";
run(\%decompress);
print "\n";

$data   = Compress::Zlib::compress($data);
$lzf    = Compress::LZF::compress($data);
$snappy = Compress::Snappy::compress($data);
$zlib   = Compress::Zlib::compress($data);

print "Uncompressible data - compression\n", '-'x33, "\n";
run(\%compress);
print "\n";
print "Uncompressible data - decompression\n", '-'x35, "\n";
run(\%decompress);

sub run {
    my ($data) = @_;

    my $times = timethese -1, $data, 'none';

    my @info;
    my ($max_name_len, $max_rate_len, $max_bw_len) = (0, 0, 0);

    while (my ($name, $info) = each %$times) {
        my ($duration, $cycles) = @{$info}[ 1, 5 ];
        my $rate = sprintf '%.0f', $cycles / $duration;
        my $bw = $rate * $opts{size} / 1024;
        $bw = sprintf int $bw ? '%.0f' : '%.2f', $bw;

        push @info, [$name, $rate, $bw];

        $max_name_len = max $max_name_len, length($name);
        $max_rate_len = max $max_rate_len, length($rate);
        $max_bw_len   = max $max_bw_len,   length($bw);
    }

    for my $rec (sort { $b->[1] <=> $a->[1] } @info) {
        my ($name, $rate, $bw) = @$rec;

        my $name_padding = $max_name_len - length($name);

        printf "%s%s %${max_rate_len}s/s  %${max_bw_len}s MB/s\n",
            $name, ' 'x$name_padding, $rate, $bw;
    }
}
