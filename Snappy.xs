#define PERL_NO_GET_CONTEXT

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
compress (sv)
  SV *sv
PREINIT:
    char *str;
    STRLEN len;
    uint32_t max_compressed_len, compressed_len;
    void *working_memory;
CODE:
    if (SvROK(sv)) sv = SvRV(sv);
    if (! SvOK(sv)) XSRETURN_NO;
    str = SvPVbyte(sv, len);
    if (! len) XSRETURN_NO;
    max_compressed_len = snappy_max_compressed_length(len);
    RETVAL = newSV(max_compressed_len);
    if (! RETVAL) XSRETURN_UNDEF;
    Newx(working_memory, SNAPPY_WORKMEM_BYTES, void);
    if (! working_memory) XSRETURN_UNDEF;
    snappy_compress(str, len, SvPVX(RETVAL), &compressed_len,
                    working_memory, SNAPPY_WORKMEM_BYTES_POWER_OF_TWO);
    Safefree(working_memory);
    SvCUR_set(RETVAL, compressed_len);
    SvPOK_on(RETVAL);
OUTPUT:
    RETVAL

SV *
decompress (sv)
  SV *sv
ALIAS:
    uncompress = 1
PREINIT:
    char *str;
    STRLEN len;
    uint32_t decompressed_len;
CODE:
    if (SvROK(sv)) sv = SvRV(sv);
    if (! SvOK(sv)) XSRETURN_NO;
    str = SvPVbyte(sv, len);
    if (! len) XSRETURN_NO;
    if (snappy_get_uncompressed_length(str, len, &decompressed_len))
        XSRETURN_UNDEF;
    RETVAL = newSV(decompressed_len);
    if (! RETVAL) XSRETURN_UNDEF;
    if (snappy_decompress(str, len, SvPVX(RETVAL), decompressed_len))
        XSRETURN_UNDEF;
    SvCUR_set(RETVAL, decompressed_len);
    SvPOK_on(RETVAL);
OUTPUT:
    RETVAL
