#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#define NEED_sv_2pvbyte
#include "ppport.h"

#include "src/csnappy_compress.c"
#include "src/csnappy_decompress.c"

MODULE = Compress::Snappy    PACKAGE = Compress::Snappy

PROTOTYPES: ENABLE

SV *
compress (buffer)
  SV *buffer
PREINIT:
    char *in, *out;
    STRLEN len;
    uint32_t max_compressed_len, compressed_len;
    void *working_memory;
CODE:
    if (SvROK(buffer)) buffer = SvRV(buffer);
    if (! SvOK(buffer)) XSRETURN_NO;
    in = SvPVbyte(buffer, len);
    if (! len) XSRETURN_NO;
    max_compressed_len = snappy_max_compressed_length(len);
    Newx(out, max_compressed_len, char);
    if (! out) XSRETURN_UNDEF;
    Newx(working_memory, SNAPPY_WORKMEM_BYTES, void);
    if (! working_memory) {
        Safefree(out);
        XSRETURN_UNDEF;
    }
    snappy_compress(in, len, out, &compressed_len,
                    working_memory, SNAPPY_WORKMEM_BYTES_POWER_OF_TWO);
    Safefree(working_memory);
    RETVAL = newSVpvn(out, compressed_len);
    Safefree(out);
OUTPUT:
    RETVAL

SV *
decompress (buffer)
  SV *buffer
ALIAS:
    uncompress = 1
PREINIT:
    char *in, *out;
    STRLEN len;
    uint32_t decompressed_len;
CODE:
    if (SvROK(buffer)) buffer = SvRV(buffer);
    if (! SvOK(buffer)) XSRETURN_NO;
    in = SvPVbyte(buffer, len);
    if (! len) XSRETURN_NO;
    if (snappy_get_uncompressed_length(in, len, &decompressed_len))
        XSRETURN_UNDEF;
    Newx(out, decompressed_len, char);
    if (! out) XSRETURN_UNDEF;
    if (snappy_decompress(in, len, out, decompressed_len)) {
        Safefree(out);
        XSRETURN_UNDEF;
    }
    RETVAL = newSVpvn(out, decompressed_len);
    Safefree(out);
OUTPUT:
    RETVAL
