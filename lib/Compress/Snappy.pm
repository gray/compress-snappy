package Compress::Snappy;

use strict;
use warnings;
use parent qw(Exporter);

use XSLoader;

our $VERSION    = '0.07';
our $XS_VERSION = $VERSION;
$VERSION = eval $VERSION;

XSLoader::load(__PACKAGE__, $XS_VERSION);

our @EXPORT = qw(compress decompress uncompress);


1;

__END__

=head1 NAME

Compress::Snappy - Perl interface to Google's Snappy (de)compressor

=head1 SYNOPSIS

    use Compress::Snappy;

    my $dest = compress($source);
    my $dest = decompress($source);

=head1 DESCRIPTION

The C<Compress::Snappy> module provides an interface to Google's Snappy
(de)compressor.

Snappy does not aim for maximum compression, or compatibility with any other
compression library; instead, it aims for very high speeds and reasonable
compression. For instance, compared to the fastest mode of zlib, Snappy is
an order of magnitude faster for most inputs, but the resulting compressed
files are anywhere from 20% to 100% bigger.

=head1 FUNCTIONS

=head2 compress

    $string = compress($buffer)

Compresses the given buffer and returns the resulting string. The input
buffer can be either a scalar or a scalar reference.

=head2 decompress

=head2 uncompress

    $string = decompress($buffer)

Decompresses the given buffer and returns the resulting string. The input
buffer can be either a scalar or a scalar reference.

On error (in case of corrupted data) undef is returned.

=head1 PERFORMANCE

This distribution contains a benchmarking script which compares serveral
compression modules available on CPAN.  These are the results on a MacBook
2GHz Core 2 Duo (64-bit) with Perl 5.12.3, using a message size of 10KiB:

    Compressible data - compression
    -------------------------------
    Compress::Snappy::compress 827076/s  808 MB/s
    Compress::LZF::compress    295588/s  289 MB/s
    Compress::Zlib::compress     4483/s    4 MB/s

    Compressible data - decompression
    ---------------------------------
    Compress::Snappy::decompress 811471/s  792 MB/s
    Compress::LZF::decompress    337317/s  329 MB/s
    Compress::Snappy::uncompress   6399/s    6 MB/s

    Uncompressible data - compression
    ---------------------------------
    Compress::Snappy::compress 2123851/s  2074 MB/s
    Compress::LZF::compress     809561/s   791 MB/s
    Compress::Zlib::compress      4622/s     5 MB/s

    Unompressable data - decompression
    ----------------------------------
    Compress::LZF::decompress    2969268/s  2900 MB/s
    Compress::Snappy::decompress 2776948/s  2712 MB/s
    Compress::Snappy::uncompress    6576/s     6 MB/s

=head1 SEE ALSO

L<http://code.google.com/p/snappy/>

L<https://github.com/zeevt/csnappy>

=head1 REQUESTS AND BUGS

Please report any bugs or feature requests to
L<http://rt.cpan.org/Public/Bug/Report.html?Queue=Compress-Snappy>.  I will
be notified, and then you'll automatically be notified of progress on your
bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Compress::Snappy

You can also look for information at:

=over

=item * GitHub Source Repository

L<http://github.com/gray/compress-snappy>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Compress-Snappy>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Compress-Snappy>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/Public/Dist/Display.html?Name=Compress-Snappy>

=item * Search CPAN

L<http://search.cpan.org/dist/Compress-Snappy/>

=back

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 gray <gray at cpan.org>, all rights reserved.

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=head1 AUTHOR

gray, <gray at cpan.org>

=cut
