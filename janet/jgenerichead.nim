
type
    JanetUnion* {.union.} = object
        u64*:      uint64
        number*:   cdouble
        integer*:  int32
        pointey*:  pointer
        cpointer*: pointer

    Janet* {.importc: "Janet".} = object
        ass* {.importc: "as".}: JanetUnion
        typee* {.importc: "type".} : JanetType

    JANET_SIZEOF* = JanetType.sizeof + cdouble.sizeof
