proc u64*(x: Janet): int =
    return x.u64.int

proc nanbox_lowtag*(typee: int): uint64 =
    return typee.uint64 or 0x1FFF0'u

proc nanbox_tag*(typee: int): uint64 =
    return (nanbox_lowtag(typee) shl 47'u)

proc typee*(x: Janet): int64 =
    if classify(x.number) == fcNan:
        return ((x.u64 shr 47) and 0xF).int64
    else:
        return JANET_NUMBER.int64

proc nanbox_checkauxtype*(x: Janet; typee: int): bool =
    return ((x.u64 and JANET_NANBOX_TAGBITS) == nanbox_tag(typee))

proc nanbox_isnumber*(x: Janet): bool =
    return ((classify(x.number) != fcNan) or nanbox_checkauxtype(x, JANET_NUMBER.int))

proc checktype*(x: Janet; t: int): bool =
    if (t == JANET_NUMBER.int):
        return nanbox_isnumber(x)
    else:
        return nanbox_checkauxtype(x, t)

proc nanbox_to_pointer*   (x: Janet): pointer {.importc: "nanbox_to_pointer".}
proc nanbox_from_pointer* (p: pointer; tagmask: uint64): Janet {.importc: "nanbox_from_pointer".}
proc nanbox_from_cpointer*(p: pointer; tagmask: uint64): Janet {.importc: "nanbox_from_cpointer".}
proc nanbox_from_double*  (d: cdouble): Janet {.importc: "nanbox_from_double".}
proc nanbox_from_bits*    (bits: uint64): Janet {.importc: "nanbox_from_bits".}

proc truthy*(x: Janet): bool =
    return (not checktype(x, JANET_NIL.int)) and ((not checktype(x, JANET_BOOLEAN.int)) or ((x.u64 and 0x1) != 0))

proc nanbox_from_payload*(t, p: int): Janet =
    return nanbox_from_bits(nanbox_tag(t).uint64 or p.uint64)

proc nanbox_wrap*(p: pointer; t: int): Janet =
    return nanbox_from_pointer(p, nanbox_tag(t))

proc nanbox_wrap_c*(p: pointer; t: int): Janet =
    return nanbox_from_cpointer(p, nanbox_tag(t))

proc wrap_nil*(): Janet =
    return nanbox_from_payload(JANET_NIL.int, 1)

proc wrap_true*(): Janet =
    return nanbox_from_payload(JANET_BOOLEAN.int, 1)

proc wrap_false*(): Janet =
    return nanbox_from_payload(JANET_BOOLEAN.int, 0)

proc wrap_boolean*(b: bool): Janet =
    if b:
        return nanbox_from_payload(JANET_BOOLEAN.int, 1)
    else:
        return nanbox_from_payload(JANET_BOOLEAN.int, 0)

proc wrap_number*(r: cdouble): Janet =
    return nanbox_from_double(r)

proc unwrap_boolean*(x: Janet): bool =
    return (x.u64 and 0x1) != 0

proc unwrap_number*(x: Janet): cdouble =
    return x.number

proc wrap_struct*(s: ptr KV): Janet =
    return nanbox_wrap_c(s.pointer, JANET_STRUCT.int)

proc wrap_tuple*(s: ptr Janet): Janet =
    return nanbox_wrap_c(s, JANET_TUPLE.int)

proc wrap_fiber*(s: ptr Fiber): Janet =
    return nanbox_wrap(s.pointer, JANET_FIBER.int)

proc wrap_array*(s: ptr Array): Janet =
    return nanbox_wrap(s.pointer, JANET_ARRAY.int)

proc wrap_table*(s: ptr Table): Janet =
    return nanbox_wrap(s.pointer, JANET_TABLE.int)

proc wrap_buffer*(s: ptr Buffer): Janet =
    return nanbox_wrap(s.pointer, JANET_BUFFER.int)

proc wrap_string*(s: cstring): Janet =
    return nanbox_wrap_c(s, JANET_STRING.int)

proc wrap_symbol*(s: cstring): Janet =
    return nanbox_wrap_c(s, JANET_SYMBOL.int)

proc wrap_keyword*(s: cstring): Janet =
    return nanbox_wrap_c(s, JANET_KEYWORD.int)

proc wrap_abstract*(s: pointer): Janet =
    return nanbox_wrap(s, JANET_ABSTRACT.int)

proc wrap_function*(s: ptr Function): Janet =
    return nanbox_wrap(s.pointer, JANET_FUNCTION.int)

proc wrap_cfunction*(s: CFunction): Janet =
    return nanbox_wrap(s.pointer, JANET_CFUNCTION.int)

proc wrap_pointer*(s: pointer): Janet =
    return nanbox_wrap(s, JANET_POINTER.int)

proc unwrap_struct*(x: Janet): ptr KV =
    return cast[ptr KV](nanbox_to_pointer(x))

proc unwrap_tuple*(x: Janet): ptr Janet =
    return cast[ptr Janet](nanbox_to_pointer(x))

proc unwrap_fiber*(x: Janet): ptr Fiber =
    return cast[ptr Fiber](nanbox_to_pointer(x))

proc unwrap_array*(x: Janet): ptr Array =
    return cast[ptr Array](nanbox_to_pointer(x))

proc unwrap_table*(x: Janet): ptr Table =
    return cast[ptr Table](nanbox_to_pointer(x))

proc unwrap_buffer*(x: Janet): ptr Buffer =
    return cast[ptr Buffer](nanbox_to_pointer(x))

proc unwrap_string*(x: Janet): cstring =
    return cast[cstring](nanbox_to_pointer(x))

proc unwrap_symbol*(x: Janet): cstring =
    return cast[cstring](nanbox_to_pointer(x))

proc unwrap_keyword*(x: Janet): cstring =
    return cast[cstring](nanbox_to_pointer(x))

proc unwrap_abstract*(x: Janet): pointer =
    return nanbox_to_pointer(x)

proc unwrap_pointer*(x: Janet): pointer =
    return nanbox_to_pointer(x)

proc unwrap_function*(x: Janet): ptr Function =
    return cast[ptr Function](nanbox_to_pointer(x))

proc unwrap_cfunction*(x: Janet): CFunction =
    return cast[CFunction](nanbox_to_pointer(x))
