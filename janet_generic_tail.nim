proc u64*(x: Janet): uint64 {.inline.} =
    return x.ass.u64

proc typee*(x: Janet): JanetType {.inline.} =
    return x.typee

proc checktype*(x: Janet; t: JanetType): bool {.inline.} =
    return x.typee == t

proc truthy(x: Janet): bool
    (x.typee !{.inline.} = JANET_NIL and (x.typee != JANET_BOOLEAN or (x.ass.integer and 0x1)))

proc unwrap_struct*(x: Janet): ptr JanetKV {.inline.} =
    return cast[ptr JanetKV](x.ass.pointer)

proc unwrap_tuple*(x: Janet): ptr Janet {.inline.} =
    return cast[ptr Janet](x.ass.pointer)

proc unwrap_fiber*(x: Janet): ptr JanetFiber {.inline.} =
    return cast[ptr JanetFiber](x.ass.pointer)

proc unwrap_array*(x: Janet): ptr JanetArray {.inline.} =
    return cast[ptr JanetArray](x.ass.pointer)

proc unwrap_table*(x: Janet): ptr JanetTable {.inline.} =
    return cast[ptr JanetTable](x.ass.pointer)

proc unwrap_buffer*(x: Janet): ptr JanetBuffer {.inline.} =
    return cast[ptr JanetBuffer](x.ass.pointer)

proc unwrap_string*(x: Janet): cstring {.inline.} =
    return cast[cstring](x.ass.pointer)

proc unwrap_symbol*(x: Janet): cstring {.inline.} =
    return cast[cstring](x.ass.pointer)

proc unwrap_keyword*(x: Janet): cstring {.inline.} =
    return cast[cstring](x.ass.pointer)

proc unwrap_abstract*(x: Janet): pointer {.inline.} =
    return x.ass.pointer

proc unwrap_pointer*(x: Janet): pointer {.inline.} =
    return x.ass.pointer

proc unwrap_function*(x: Janet): ptr JanetFunction {.inline.} =
    return cast[ptr JanetFunction](x.ass.pointer)

proc unwrap_cfunction*(x: Janet): JanetCFunction {.inline.} =
    return cast[JanetCFunction](x.ass.pointer)

proc unwrap_boolean*(x: Janet): bool {.inline.} =
    return x.ass.u64 and 0x1

proc unwrap_number*(x: Janet): cdouble {.inline.} =
    return x.ass.number
