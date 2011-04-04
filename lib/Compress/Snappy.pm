package Compress::Snappy;

use strict;
use warnings;
use parent qw(Exporter);

use XSLoader;

our $VERSION    = '0.06';
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
