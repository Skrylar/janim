
type
    JanetTagged* = object
        when cpu_endian == big_endian:
            typee: int32
            payload: int32
        elif cpu_endian == little_endian:
            payload: int32
            typee: int32

    Janet* {.importc: "Janet", union.} = object
        tagged*: JanetTagged
        number*: uint64
        u64*: uint32

const
    JANET_DOUBLE_OFFSET* = 0xFFFF
