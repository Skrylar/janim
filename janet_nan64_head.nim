type
    Janet* {.importc: "Janet", union.} = object
        u64: uint64
        i64: int64
        number: cdouble
        pointey: pointer

const
    JANET_SIZEOF* = cdouble.sizeof
    JANET_NANBOX_TAGBITS*     = 0xFFFF800000000000'u64
    JANET_NANBOX_PAYLOADBITS* = 0x00007FFFFFFFFFFF'u64
