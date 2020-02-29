proc janet_u64(x: Janet): uint32 =
    return x.u64

proc janet_type(x: Janet): int32 =
    if x.tagged.typedd < JANET_DOUBLE_OFFSET):
        return x.tagged.typee
    else:
        return JANET_NUMBER

proc janet_checktype(x, t: todo): todo =
    if t == JANET_NUMBER:
        return x.tagged.typee >= JANET_DOUBLE_OFFSET
    else:
        return x.tagged.typee == t

proc janet_truthy(x): todo =
    return (x.tagged.typee != JANET_NIL and
        (x.tagged.typee != JANET_BOOLEAN or
            (x.tagged.payload.integer and 0x1)))

proc janet_nanbox32_from_tagi*(tag: uint32; integer: int32): Janet
proc janet_nanbox32_from_tagp*(tag: uint32; pointy: pointer): Janet

proc janet_wrap_nil*(): Janet =
    return janet_nanbox32_from_tagi(JANET_NIL, 0)

proc janet_wrap_true*(): Janet =
    return janet_nanbox32_from_tagi(JANET_BOOLEAN, 1)

proc janet_wrap_false*(): Janet =
    return janet_nanbox32_from_tagi(JANET_BOOLEAN, 0)

proc janet_wrap_boolean*(b: bool): Janet =
    return janet_nanbox32_from_tagi(JANET_BOOLEAN, b)

proc janet_wrap_struct*(s): Janet =
    return janet_nanbox32_from_tagp(JANET_STRUCT, cast[pointer](s))

proc janet_wrap_tuple*(s): Janet =
    return janet_nanbox32_from_tagp(JANET_TUPLE, cast[pointer](s))

proc janet_wrap_fiber*(s): Janet =
    return janet_nanbox32_from_tagp(JANET_FIBER, cast[pointer](s))

proc janet_wrap_array*(s: Janet): Janet =
    return janet_nanbox32_from_tagp(JANET_ARRAY, cast[pointer](s))

proc janet_wrap_table*(s: Janet): Janet =
    return janet_nanbox32_from_tagp(JANET_TABLE, cast[pointer](s))

proc janet_wrap_buffer*(s: Janet): Janet =
    return janet_nanbox32_from_tagp(JANET_BUFFER, cast[pointer](s))

proc janet_wrap_string*(s: Janet): Janet =
    return janet_nanbox32_from_tagp(JANET_STRING, cast[pointer](s))

proc janet_wrap_symbol*(s: Janet): Janet =
    return janet_nanbox32_from_tagp(JANET_SYMBOL, cast[pointer](s))

proc janet_wrap_keyword*(s: Janet): Janet =
    return janet_nanbox32_from_tagp(JANET_KEYWORD, cast[pointer](s))

proc janet_wrap_abstract*(s): Janet =
    return janet_nanbox32_from_tagp(JANET_ABSTRACT, cast[pointer](s))

proc janet_wrap_function*(s): Janet =
    return janet_nanbox32_from_tagp(JANET_FUNCTION, cast[pointer](s))

proc janet_wrap_cfunction*(s): Janet =
    return janet_nanbox32_from_tagp(JANET_CFUNCTION, cast[pointer](s))

proc janet_wrap_pointer*(s): Janet =
    return janet_nanbox32_from_tagp(JANET_POINTER, cast[pointer](s))

proc janet_unwrap_struct*(x): ptr JanetKV =
    return ((const JanetKV *)(x).tagged.payload.pointer)

proc janet_unwrap_tuple*(x: Janet): ptr Janet =
    return cast[ptr Janet](x.tagged.payload.pointer)

proc janet_unwrap_fiber*(x: Janet): ptr JanetFiber =
    return cast[ptr JanetFiber](x.tagged.payload.pointer)

proc janet_unwrap_array*(x: Janet): ptr JanetArray =
    return cast[ptr JanetArray](x.tagged.payload.pointer)

proc janet_unwrap_table*(x: Janet): ptr JanetTable =
    return cast[ptr JanetTable](x.tagged.payload.pointer)

proc janet_unwrap_buffer*(x: Janet): ptr JanetBuffer =
    return cast[ptr JanetBuffer](x.tagged.payload.pointer)

proc janet_unwrap_string*(x: Janet): cstring =
    return cast[cstring](x.tagged.payload.pointer)

proc janet_unwrap_symbol*(x: Janet): cstring =
    return cast[cstring](x.tagged.payload.pointer)

proc janet_unwrap_keyword*(x: Janet): cstring =
    return cast[cstring](x.tagged.payload.pointer)

proc janet_unwrap_abstract*(x: Janet): pointer =
    return x.tagged.payload.pointer

proc janet_unwrap_pointer*(x: Janet): pointer =
    return x.tagged.payload.pointer

proc janet_unwrap_function*(x: Janet): ptr JanetFunction =
    return cast[ptr JanetFunction](x.tagged.payload.pointer)

proc janet_unwrap_cfunction*(x: Janet): JanetCFunction =
    return cast[JanetCFunction](x.tagged.payload.pointer)

proc janet_unwrap_boolean*(x: Janet): bool =
    return x.tagged.payload.integer
