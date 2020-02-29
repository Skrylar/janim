import math

const
    JANET_HEADER = "janet.h"
    JANET_LIB = "libjanet.so"

{.pragma: janproc, cdecl, dynlib: JANET_LIB, header: JANET_HEADER.}
{.pragma: jantype, header: JANET_HEADER.}

const
    JANET_VERSION_MAJOR* = 0 # TODO
    JANET_VERSION_MINOR* = 0 # TODO
    JANET_VERSION_PATCH* = 0 # TODO

    JANET_VERSION* = "latest"
    JANET_BUILD*   = "local"

    JANET_THREADS = true

when host_os == "windows":
    const
        JANET_WINDOWS* = 1
        JANET_BSD*     = 0
        JANET_APPLE*   = 0
        JANET_LINUX*   = 0
        JANET_POSIX*   = 0
elif host_os == "macosx":
    const
        JANET_WINDOWS* = 0
        JANET_BSD*     = 0
        JANET_APPLE*   = 1
        JANET_LINUX*   = 0
        JANET_POSIX*   = 0
elif host_os == "linux":
    const
        JANET_WINDOWS* = 0
        JANET_BSD*     = 0
        JANET_APPLE*   = 0
        JANET_LINUX*   = 1
        JANET_POSIX*   = 1
elif (host_os == "netbsd") or (host_os == "freebsd") or (host_os == "openbsd"):
    const
        JANET_WINDOWS* = 0
        JANET_BSD*     = 1
        JANET_APPLE*   = 0
        JANET_LINUX*   = 0
        JANET_POSIX*   = 1
elif (host_os == "solaris") or (host_os == "aix"):
    const
        JANET_WINDOWS* = 0
        JANET_BSD*     = 0
        JANET_APPLE*   = 0
        JANET_LINUX*   = 0
        JANET_POSIX*   = 1

# this is for emscripten but nim doesn't detect this
#define JANET_WEB 1

# detect host bit size
when int.sizeof == 8:
    const
        JANET_64* = true
        JANET_32* = false
elif int.sizeof == 4:
    const
        JANET_64* = false
        JANET_32* = true

# detect endianness
when cpu_endian == little_endian:
    const
        JANET_LITTLE_ENDIAN* = true
        JANET_BIG_ENDIAN* = false
else:
    const
        JANET_LITTLE_ENDIAN* = false
        JANET_BIG_ENDIAN* = true

# thread local flags would go here, but how do those work in nim?

const
    JANET_ASSEMBLER* = true
    JANET_DYNAMIC_MODULES* = true
    JANET_INT_TYPES* = true
    JANET_PEG* = true
    JANET_TYPED_ARRAY* = true
    JANET_MODULE_ENTRY* = false # TODO should this be true by default?

# XXX does nim even have a noreturn pragma?

const
    JANET_MAX_MACRO_EXPAND* = 200
    JANET_MAX_PROTO_DEPTH* = 200
    JANET_NO_NANBOX* = false
    JANET_RECURSION_GUARD* = 1024
    JANET_SINGLE_THREADED* = false
    JANET_STACK_MAX* = 0x7fffffff

when JANET_NO_NANBOX == false:
    when JANET_64 == true:
        const
            JANET_NANBOX_32* = false
            JANET_NANBOX_64* = true
    elif JANET_32 == true:
        const
            JANET_NANBOX_32* = true
            JANET_NANBOX_64* = false
else:
    const
        JANET_NANBOX_32* = false
        JANET_NANBOX_64* = false

when JANET_NO_NANBOX == true:
    const
        JANET_NANBOX_BIT* = 0
else:
    const
        JANET_NANBOX_BIT* = 0x1

when JANET_SINGLE_THREADED == true:
    const
        JANET_SINGLE_THREADED_BIT* = 0x2
else:
    const
        JANET_SINGLE_THREADED_BIT* = 0

const
    JANET_CURRENT_CONFIG_BITS* = JANET_SINGLE_THREADED_BIT or JANET_NANBOX_BIT

type
    BuildConfig* {.importc: "JanetBuildConfig".} = object
        major*: cuint
        minor*: cuint
        patch*: cuint
        bits*: cuint

proc config_current*(): BuildConfig =
    result.major = JANET_VERSION_MAJOR
    result.minor = JANET_VERSION_MINOR
    result.patch = JANET_VERSION_PATCH
    result.bits  = JANET_CURRENT_CONFIG_BITS

var signal_names* {.importc: "janet_signal_names", jantype.}: array[14, cstring]
var status_names* {.importc: "janet_status_names", jantype.}: array[16, cstring]
var type_names* {.importc: "janet_type_names", jantype.}: array[16, cstring]

when JANET_NANBOX_64 == true:
    include janet_nan64_head
elif JANET_NANBOX_32 == true:
    include janet_nan32_head
else:
    include janet_generic_head

type
    Abstract* {.importc: "JanetAbstract", jantype.} = distinct pointer # TODO double check this isn't a void
    Keyword*  {.importc: "JanetKeyword", jantype.}  = ptr uint8
    String*   {.importc: "JanetString", jantype.}   = ptr uint8
    Symbol*   {.importc: "JanetSymbol", jantype.}   = ptr uint8
    Tuple*    {.importc: "JanetTuple", jantype.}    = ptr Janet
    Struct*   {.importc: "JanetStruct", jantype.}   = KV

    AbstractHead* {.importc: "JanetAbstractHead", jantype.} = object
        gc*:    GCObject
        typee*: ptr AbstractType
        size*:  csize
        data*:  ptr clonglong

    MarshalContext* {.importc: "JanetMarshalContext", jantype.} = object
        m_state*: pointer
        u_state*: pointer
        flags*:   cint
        data*:    ptr uint8
        at*:      ptr AbstractType

    AbstractType* {.importc: "JanetAbstractType", jantype.} = object
        name*:      cstring
        gc*:        proc(data: pointer; len: csize): cint
        gcmark*:    proc(data: pointer; len: csize): cint
        get*:       proc(data: pointer; key: Janet; outt: ptr Janet): cint
        put*:       proc(data: pointer; key: Janet; value: Janet)
        marshal*:   proc(p: pointer; ctx: ptr MarshalContext)
        unmarshal*: proc(ctx: ptr MarshalContext): pointer
        tostring*:  proc(p: pointer; buffer: ptr Buffer)

    Array* {.importc: "JanetArray", jantype.} = object
        gc*:       int32
        count*:    int32
        capacity*: ptr uint8
        data*:     ptr GCObject

    Buffer* {.importc: "JanetBuffer", jantype.} = object
        gc*:       GCObject
        count*:    int32
        capacity*: int32
        data*:     ptr uint8

    ByteView* {.importc: "JanetByteView", jantype.} = object
        bytes*: ptr uint8
        len*:   int32

    DictView* {.importc: "JanetDictView", jantype.} = object
        kvs*: ptr KV
        len*: int32
        cap*: int32

    Fiber* {.importc: "JanetFiber", jantype.} = object
        gc*:         GCObject
        flags*:      int32
        frame*:      int32
        stackstart*: int32
        stacktop*:   int32
        capacity*:   int32
        maxstack*:   int32
        env*:        ptr Table
        data*:       ptr Janet
        child*:      ptr Fiber

    FuncDef* {.importc: "JanetFuncDef", jantype.} = object
        gc*:                  GCObject
        environments*:        ptr int32
        constants*:           ptr Janet
        defs*:                ptr ptr FuncDef
        bytecode*:            ptr uint32
        sourcemap*:           ptr SourceMapping
        source*:              String
        name*:                String
        flags*:               int32
        slotcount*:           int32
        arity*:               int32
        min_arity*:           int32
        max_arity*:           int32
        constants_length*:    int32
        bytecode_length*:     int32
        environments_length*: int32
        defs_length*:         int32

    FuncEnvAs* {.union.} = object
        fiber: ptr Fiber
        values: ptr Janet

    FuncEnv* {.importc: "JanetFuncEnv", jantype.} = object
        gc*:     GCObject
        ass*:    FuncEnvAs
        length*: int32
        offset*: int32

    Function* {.importc: "JanetFunction", jantype.} = object
        gc*:   GCObject
        def*:  ptr FuncDef
        envs*: ptr ptr FuncEnv

    GCObject* {.importc: "JanetGCObject", jantype.} = object
        flags*: int32
        next*: ptr GCObject

    KV* {.importc: "JanetKV", jantype.} = object
        key*:   Janet
        value*: Janet

    Method* {.importc: "JanetMethod", jantype.} = object
        name*: cstring
        cfun*: CFunction

    Range* {.importc: "JanetRange", jantype.} = object
        start*: int32
        endd*:  int32

    Reg* {.importc: "JanetReg", jantype.} = object
        name*:          cstring
        cfun*:          CFunction
        documentation*: cstring

    RNG* {.importc: "JanetRNG", jantype.} = object
        a*, b*, c*, d*: uint32
        counter*: uint32

    SourceMapping* {.importc: "JanetSourceMapping", jantype.} = object
        line*:   int32
        column*: int32

    StackFrame* {.importc: "JanetStackFrame", jantype.} = object
        funcc*:     ptr Function
        pc*:        uint32
        env*:       ptr FuncEnv
        prevframe*: int32
        flags*:     int32

    StringHead* {.importc: "JanetStringHead", jantype.} = object
        gc*:     ptr GCObject
        length*: int32
        hash*:   int32
        data*:   ptr uint8

    StructHead* {.importc: "JanetStructHead", jantype.} = object
        gc*:       GCObject
        length*:   int32
        hash*:     int32
        capacity*: int32
        data*:     ptr KV

    Table* {.importc: "JanetTable", jantype.} = object
        gc*:       int32
        count*:    int32
        capacity*: int32
        deleted*:  ptr Table
        data*:     ptr Table
        proto*:    Janet

    TupleHead* {.importc: "JanetTupleHead", jantype.} = object
        gc*:        GCObject
        length*:    int32
        hash*:      int32
        sm_line*:   int32
        sm_column*: int32
        data*:      ptr Janet

    View* {.importc: "JanetView", jantype.} = object
        items*: ptr Janet
        len*:   int32

    Module* {.importc: "JanetModule", jantype.}       = proc(x: ptr Table) {.cdecl.}
    Modconf* {.importc: "JanetModconf", jantype.}     = proc(): BuildConfig {.cdecl.}
    CFunction* {.importc: "JanetCFunction", jantype.} = proc(argc: int32; argv: ptr Janet): ptr Janet {.cdecl.}

const
    STACKFRAME_SIZEOF* = (pointer.sizeof * 2) + (int32.sizeof * 3)

include janet_enum

const
    JANET_COUNT_TYPES*     = (ord(JANET_POINTER) + 1)

    JANET_TFLAG_NIL*       = (1 shl ord(JANET_NIL))
    JANET_TFLAG_BOOLEAN*   = (1 shl ord(JANET_BOOLEAN))
    JANET_TFLAG_FIBER*     = (1 shl ord(JANET_FIBER))
    JANET_TFLAG_NUMBER*    = (1 shl ord(JANET_NUMBER))
    JANET_TFLAG_STRING*    = (1 shl ord(JANET_STRING))
    JANET_TFLAG_SYMBOL*    = (1 shl ord(JANET_SYMBOL))
    JANET_TFLAG_KEYWORD*   = (1 shl ord(JANET_KEYWORD))
    JANET_TFLAG_ARRAY*     = (1 shl ord(JANET_ARRAY))
    JANET_TFLAG_TUPLE*     = (1 shl ord(JANET_TUPLE))
    JANET_TFLAG_TABLE*     = (1 shl ord(JANET_TABLE))
    JANET_TFLAG_STRUCT*    = (1 shl ord(JANET_STRUCT))
    JANET_TFLAG_BUFFER*    = (1 shl ord(JANET_BUFFER))
    JANET_TFLAG_FUNCTION*  = (1 shl ord(JANET_FUNCTION))
    JANET_TFLAG_CFUNCTION* = (1 shl ord(JANET_CFUNCTION))
    JANET_TFLAG_ABSTRACT*  = (1 shl ord(JANET_ABSTRACT))
    JANET_TFLAG_POINTER*   = (1 shl ord(JANET_POINTER))

    JANET_TFLAG_DICTIONARY* = JANET_TFLAG_TABLE or JANET_TFLAG_STRUCT
    JANET_TFLAG_BYTES*      = JANET_TFLAG_STRING or JANET_TFLAG_SYMBOL or JANET_TFLAG_BUFFER or JANET_TFLAG_KEYWORD
    JANET_TFLAG_INDEXED*    = JANET_TFLAG_ARRAY or JANET_TFLAG_TUPLE
    JANET_TFLAG_LENGTHABLE* = JANET_TFLAG_BYTES or JANET_TFLAG_INDEXED or JANET_TFLAG_DICTIONARY
    JANET_TFLAG_CALLABLE*   = JANET_TFLAG_FUNCTION or JANET_TFLAG_CFUNCTION or JANET_TFLAG_LENGTHABLE or JANET_TFLAG_ABSTRACT

#include janet_nonc

when JANET_NANBOX_64 == true:
    include janet_nan64_tail
elif JANET_NANBOX_32 == true:
    include janet_nan32_tail
else:
    include janet_generic_tail

proc checkint*(x: Janet): cint {.importc: "janet_checkint".}
proc checkint64*(x: Janet): cint {.importc: "janet_checkint64".}
proc checksize*(x: Janet): cint {.importc: "janet_checksize".}
proc checkabstract*(x: Janet; at: ptr AbstractType): Abstract {.importc: "janet_checkabstract".}

proc checkintrange*[T](x: T): bool =
    return x == x.int32.T

proc checkint64range*[T](x: T): bool =
    return x == x.int64.T

proc unwrap_integer*(x: Janet): int32 =
    return unwrap_number(x).int32

proc wrap_integer*(x: int32): Janet =
    return wrap_number(x.cdouble)

proc checktypes*(x: Janet; tps: cint): cint =
    return (1.cint shl typee(x)) and (tps)

const
    JANET_FIBER_MASK_ERROR*: cint = 2
    JANET_FIBER_MASK_DEBUG*: cint = 4
    JANET_FIBER_MASK_YIELD*: cint = 8

    JANET_FIBER_MASK_USER0*: cint = 16 shl 0
    JANET_FIBER_MASK_USER1*: cint = 16 shl 1
    JANET_FIBER_MASK_USER2*: cint = 16 shl 2
    JANET_FIBER_MASK_USER3*: cint = 16 shl 3
    JANET_FIBER_MASK_USER4*: cint = 16 shl 4
    JANET_FIBER_MASK_USER5*: cint = 16 shl 5
    JANET_FIBER_MASK_USER6*: cint = 16 shl 6
    JANET_FIBER_MASK_USER7*: cint = 16 shl 7
    JANET_FIBER_MASK_USER8*: cint = 16 shl 8
    JANET_FIBER_MASK_USER9*: cint = 16 shl 9

    JANET_FIBER_MASK_USER*: cint     = 0x3FF0
    JANET_FIBER_STATUS_MASK*: cint   = 0xFF0000
    JANET_FIBER_STATUS_OFFSET*: cint = 16

    JANET_FUNCDEF_FLAG_VARARG*: cint       = 0x10000
    JANET_FUNCDEF_FLAG_NEEDSENV*: cint     = 0x20000
    JANET_FUNCDEF_FLAG_HASNAME*: cint      = 0x80000
    JANET_FUNCDEF_FLAG_HASSOURCE*: cint    = 0x100000
    JANET_FUNCDEF_FLAG_HASDEFS*: cint      = 0x200000
    JANET_FUNCDEF_FLAG_HASENVS*: cint      = 0x400000
    JANET_FUNCDEF_FLAG_HASSOURCEMAP*: cint = 0x800000
    JANET_FUNCDEF_FLAG_STRUCTARG*: cint    = 0x1000000
    JANET_FUNCDEF_FLAG_TAG*: cint          = 0xFFFF

    JANET_FILE_WRITE*: cint         = 1
    JANET_FILE_READ*: cint          = 2
    JANET_FILE_APPEND*: cint        = 4
    JANET_FILE_UPDATE*: cint        = 8
    JANET_FILE_NOT_CLOSEABLE*: cint = 16
    JANET_FILE_CLOSED*: cint        = 32
    JANET_FILE_BINARY*: cint        = 64
    JANET_FILE_SERIALIZABLE*: cint  = 128
    JANET_FILE_PIPED*: cint         = 256

    JANET_STACKFRAME_TAILCALL*: cint = 1
    JANET_STACKFRAME_ENTRANCE*: cint = 2

    JANET_PRETTY_COLOR*: cint   = 1
    JANET_PRETTY_ONELINE*: cint = 2

const
    JANET_FRAME_SIZE*: cint = ((STACKFRAME_SIZEOF + JANET_SIZEOF - 1) /% JANET_SIZEOF)
    JANET_FUNCFLAG_TRACE*: cint = 1 shl 16

proc JANET_FIBER_MASK_USERN*(N: cint): cint {.inline.} =
    return 16.cint shl N

type
    ParseState* {.importc: "JanetParseState", jantype.} = distinct void

    Parser* {.importc: "JanetParser", jantype.} = object
        args*:       ptr Janet
        error*:      cstring
        states*:     ptr ParseState
        buf*:        ptr uint8
        argcount*:   csize
        argcap*:     csize
        statecount*: csize
        statecap*:   csize
        bufcount*:   csize
        bufcap*:     csize
        line*:       csize
        column*:     csize
        pending*:    csize
        lookback*:   cint
        flag*:       cint

when JANET_THREADS == true:
    type
        Mailbox* {.importc: "JanetMailbox", jantype.} = distinct pointer

        Thread* {.importc: "JanetThread", jantype.} = object
            mailbox: Mailbox
            encode:  ptr Table

var instructions* {.importc: "janet_instructions", jantype.}: array[JOP_INSTRUCTION_COUNT, InstructionType]

proc init*(parser: ptr Parser) {.importc: "janet_parser_init", janproc.}
proc deinit*(parser: ptr Parser) {.importc: "janet_parser_deinit", janproc.}
proc consume*(parser: ptr Parser; c: uint8) {.importc: "janet_parser_consume", janproc.}
proc status*(parser: ptr Parser): ParserStatus {.importc: "janet_parser_status", janproc.}
proc produce*(parser: ptr Parser): Janet {.importc: "janet_parser_produce", janproc.}
proc error*(parser: ptr Parser): cstring {.importc: "janet_parser_error", janproc.}
proc flush*(parser: ptr Parser) {.importc: "janet_parser_flush", janproc.}
proc eof*(parser: ptr Parser) {.importc: "janet_parser_eof", janproc.}
proc has_more*(parser: ptr Parser): cint {.importc: "janet_parser_has_more", janproc.}

when JANET_ASSEMBLER == true:
    type
        AssembleResult* {.importc: "JanetAssembleResult", jantype.} = object
            funcdef*: ptr FuncDef
            error*:   String
            status*:  AssembleStatus

    proc asmm*(source: Janet; flags: cint): AssembleResult {.importc: "janet_asm".}
    proc disasm*(def: ptr FuncDef): Janet {.importc: "janet_disasm".}
    proc asm_decode_instruction*(instr: uint32): Janet {.importc: "janet_asm_decode_instruction".}

type
    CompileResult* {.importc: "JanetCompileResult", jantype.} = object
        funcdef*:       ptr FuncDef
        error*:         String
        macrofiber*:    ptr Fiber
        error_mapping*: SourceMapping
        status*:        CompileStatus

proc compile*(source: Janet; env: ptr Table; where: String): CompileResult {.importc: "janet_compile", janproc.}
proc core_env*(replacements: ptr Table): ptr Table {.importc: "janet_core_env", janproc.}
proc dobytes*(env: ptr Table; bytes: ptr uint8; len: int32; sourcePath: cstring; outt: ptr Janet): cint {.importc: "janet_dobytes", janproc.}
proc dostring*(env: ptr Table; str: cstring; sourcePath: cstring; outt: ptr Table): cint {.importc: "janet_dostring", janproc.}
proc scan_number*(str: ptr uint8; len: int32; outt: ptr cdouble): cint {.importc: "janet_scan_number", janproc.}
proc debug_break*(def: ptr FuncDef; pc: int32) {.importc: "janet_debug_break", janproc.}
proc debug_unbreak*(def: ptr FuncDef; pc: int32) {.importc: "janet_debug_unbreak", janproc.}
proc debug_find*(def_out: ptr ptr FuncDef; pc_out: ptr int32; source: String; line: int32; column: int32) {.importc: "janet_debug_find", janproc.}

proc default_rng*(): ptr RNG {.importc: "janet_default_rng", janproc.}
proc `seed=`*(rng: ptr RNG; seed: uint32) {.importc: "janet_rng_seed", janproc.}
proc longseed*(rng: ptr RNG; bytes: ptr uint8; len: int32) {.importc: "janet_rng_longseed", janproc.}
proc u32*(rng: ptr RNG): uint32 {.importc: "janet_rng_u32", janproc.}

proc janet_array(capacity: int32): ptr Array {.importc: "janet_array", janproc.}
proc janet_array_n(elements: ptr Janet; n: int32): ptr Array {.importc: "janet_array_n", janproc.}

proc new*(_: typedesc[Array]; capacity: cint): ptr Array =
    return janet_array(capacity.int32)

proc new*(_: typedesc[Array]; elements: ptr Janet; n: cint): ptr Array =
    return janet_array_n(elements, n.int32)

proc ensure*(arr: ptr Array; capacity, growth: int32) {.importc: "janet_array_ensure", janproc.}
proc `count=`*(arr: ptr Array; count: int32) {.importc: "janet_array_setcount", janproc.}
proc push*(arr: ptr Array; x: Janet) {.importc: "janet_array_push", janproc.}
proc pop*(arr: ptr Array): Janet {.importc: "janet_array_pop", janproc.}
proc peek*(arr: ptr Array): Janet {.importc: "janet_array_peek", janproc.}

proc janet_buffer(capacity: int32): ptr Buffer {.importc: "janet_buffer", janproc.}

proc new*(_: typedesc[Buffer]; capacity: cint): ptr Array =
    return janet_buffer(capacity.int32)

proc init*(buffer: ptr Buffer; capacity: int32): ptr Buffer {.importc: "janet_buffer_init".}
proc deinit*(buffer: ptr Buffer) {.importc: "janet_buffer_deinit".}
proc ensure*(buffer: ptr Buffer; capacity: int32; growth: int32) {.importc: "janet_buffer_ensure".}
proc `count=`*(buffer: ptr Buffer; count: int32) {.importc: "janet_buffer_setcount".}
proc `extra=`*(buffer: ptr Buffer; n: int32) {.importc: "janet_buffer_extra".}
proc push*(buffer: ptr Buffer; str: ptr uint8; len: int32) {.importc: "janet_buffer_push_bytes".}
proc push*(buffer: ptr Buffer; str: String) {.importc: "janet_buffer_push_string".}
proc push*(buffer: ptr Buffer; cstr: cstring) {.importc: "janet_buffer_push_cstring".}
proc push*(buffer: ptr Buffer; x: uint8) {.importc: "janet_buffer_push_u8".}
proc push*(buffer: ptr Buffer; x: uint16) {.importc: "janet_buffer_push_u16".}
proc push*(buffer: ptr Buffer; x: uint32) {.importc: "janet_buffer_push_u32".}
proc push*(buffer: ptr Buffer; x: uint64) {.importc: "janet_buffer_push_u64".}

const
    JANET_TUPLE_FLAG_BRACKETCTOR* = 0x10000

proc head*(t: Tuple): ptr TupleHead =
    return cast[ptr TupleHead](cast[int](t) - offsetof(TupleHead, data))

proc length*(t: Tuple): int32 =
    return head(t).length

proc hash*(t: Tuple): int32 =
    return head(t).hash

proc sm_line*(t: Tuple): int32 =
    return head(t).sm_line

proc sm_column*(t: Tuple): int32 =
    return head(t).sm_column

proc flag*(t: Tuple): int32 =
    return head(t).gc.flags

# TODO figure out how tuples are actually made here
proc tuple_begin*(length: int32): ptr Janet {.importc: "janet_tuple_begin".}
proc tuple_end*(tuplee: ptr Janet): Tuple {.importc: "janet_tuple_end".}

proc janet_tuple_n(values: ptr Janet; n: int32): Tuple {.importc: "janet_tuple_n".}

proc new*(_: typedesc[Tuple]; capacity: cint): Tuple =
    return janet_tuple_n(capacity.int32)

proc equal*(lhs, rhs: Tuple): cint {.importc: "janet_tuple_equal".}
proc compare*(lhs, rhs: Tuple): cint {.importc: "janet_tuple_compare".}

proc head*(s: String): ptr StringHead =
    return cast[ptr StringHead](cast[int](s) - offsetof(StringHead, data))

proc length*(s: String): int32 =
    return head(s).length

template len*(s: String): cint = s.length.int

proc hash*(s: String): int32 =
    return head(s).hash

# TODO figure out how tuples are actually made here
proc janet_string_begin*(length: ptr uint8): ptr uint8 {.importc: "janet_string_begin".}
proc janet_string_end*(str: int32): String {.importc: "janet_string_end".}

proc janet_string(buf: ptr uint8; len: int32): String {.importc: "janet_string".}
proc janet_cstring(cstr: cstring): String {.importc: "janet_cstring".}

proc new*(_: typedesc[String]; bytes: ptr uint8; length: cint): String =
    return janet_string(bytes, length.int)

proc new*(_: typedesc[String]; content: cstring): String =
    return janet_cstring(content)

proc compare*(lhs, rhs: String): cint {.importc: "janet_string_compare".}
proc equal*(lhs, rhs: String): cint {.importc: "janet_string_equal".}
proc equal*(lhs: String; rhs: ptr uint8; rlen, rhash: int32): cint {.importc: "janet_string_equalconst".}

proc description*(x: Janet): String {.importc: "janet_description".}
proc to_string*(x: Janet): String {.importc: "janet_to_string".}

# TODO consider flipping these parameters in a template, because this
# order is derpy
proc to_string*(buffer: ptr Buffer; x: Janet) {.importc: "janet_to_string_b".}
proc description*(buffer: ptr Buffer; x: Janet) {.importc: "janet_description_b".}

proc formatc*(format: cstring): String {.varargs, importc: "janet_formatc".}

#proc cstringv*(cstr: cstring): Janet =
#    return wrap_string(janet_cstring(cstr))
#
#proc stringv*(str: ptr uint8; len: cint): Janet =
#    return wrap_string(janet_string(str, len))

# TODO proc formatb*(bufp: string; format: va_list; args: ptr JanetBuffer)

proc janet_symbol(str: ptr uint8; len: int32): Symbol {.importc: "janet_symbol".}
proc janet_csymbol(str: cstring): Symbol {.importc: "janet_csymbol".}
proc janet_symbol_gen(): Symbol {.importc: "janet_symbol_gen".}

proc new*(_: typedesc[Tuple]; str: ptr uint8; len: cint): Symbol =
    return janet_symbol(str, len.int32)

proc new*(_: typedesc[Tuple]; str: cstring): Symbol =
    return janet_csymbol(str)

proc new*(_: typedesc[Tuple]): Symbol =
    return janet_symbol_gen()

#proc symbolv*(str: todo; len: cint): todo =
#    return wrap_symbol(janet_symbol(str, len))
#
#proc csymbolv*(cstr: cstring): todo =
#    return wrap_symbol(janet_csymbol(cstr))

#proc keywordv(str: cstring; len: cint): JanetKeyword =
#    return wrap_keyword(janet_keyword(str, len))
#
#proc ckeywordv(cstr): todo =
#    return wrap_keyword(janet_ckeyword(cstr))

proc head*(t: Struct): ptr StructHead =
    return cast[ptr StructHead](cast[int](t) - offsetof(StructHead, data))

proc length*(t: Struct): int32 =
    return head(t).length

proc capacity*(t: Struct): int32 =
    return head(t).capacity

proc hash*(t: Struct): int32 =
    return head(t).hash

proc struct_begin*(count: int32): ptr KV {.importc: "janet_struct_begin".}
proc struct_end*(st: KV): Struct {.importc: "janet_struct_end".}

proc put*(st: KV; key: Janet; value: Janet) {.importc: "janet_struct_put".}
proc `[]=`*(st: KV; key: Janet; value: Janet) = st.put(key, value)

proc get*(st: Struct; key: Janet): Janet {.importc: "janet_struct_get".}
proc `[]`*(st: Struct; key: Janet): Janet = return st.get(key)

proc to_table*(st: Struct): ptr Table {.importc: "janet_struct_to_table".}
proc equal*(lhs: Struct; rhs: Struct): cint {.importc: "janet_struct_equal".}
proc compare*(lhs: Struct; rhs: Struct): cint {.importc: "janet_struct_compare".}
proc find*(st: Struct; key: Janet): KV {.importc: "janet_struct_find".}

proc janet_table(capacity: int32): ptr Table {.importc: "janet_table".}

proc new*(_: typedesc[Table]; capacity: int): ptr Table =
    return janet_table(capacity.int32)

proc init*(table: ptr Table; capacity: int32): ptr Table {.importc: "janet_table_init".}
proc deinit*(table: ptr Table) {.importc: "janet_table_deinit".}

proc put*(t: ptr Table; key: Janet; value: Janet) {.importc: "janet_table_put".}
proc `[]=`*(t: ptr Table; key: Janet; value: Janet) = t.put(key, value)

proc get*(t: ptr Table; key: Janet): Janet {.importc: "janet_table_get".}
proc `[]`*(t: ptr Table; key: Janet): Janet = return t.get(key)

proc get_ex*(t: ptr Table; key: Janet; which: ptr ptr Table): Janet {.importc: "janet_table_get_ex".}
proc rawget*(t: ptr Table; key: Janet): Janet {.importc: "janet_table_rawget".}
proc remove*(t: ptr Table; key: Janet): Janet {.importc: "janet_table_remove".}
proc to_struct*(t: ptr Table): Struct {.importc: "janet_table_to_struct".}
proc merge*(table: ptr Table; other: ptr Table) {.importc: "janet_table_merge_table".}
proc merge*(table: ptr Table; other: Struct) {.importc: "janet_table_merge_struct".}
proc find*(t: ptr Table; key: Janet): KV {.importc: "janet_table_find".}
proc clone*(table: ptr Table): ptr Table {.importc: "janet_table_clone".}

proc janet_fiber(callee: ptr Function; capacity, argc: int32; argv: ptr Janet): ptr Fiber {.importc: "janet_fiber".}

# XXX this is inconsistent with other procs that do <values, len> which
# rustles my jimmies
proc new*(_: typedesc[Fiber]; callee: ptr Function; capacity, argc: cint; argv: ptr Janet): ptr Fiber =
    janet_fiber(callee, capacity.int32, argv.int32, argv)

proc reset*(fiber: ptr Fiber; callee: ptr Function; argc: int32; argv: ptr Janet): ptr Fiber {.importc: "janet_fiber_reset".}
proc status*(fiber: ptr Fiber): FiberStatus {.importc: "janet_fiber_status".}
proc current_fiber*(): ptr Fiber {.importc: "janet_current_fiber".}

proc indexed_view*(seqq: Janet; data: ptr ptr Janet; len: ptr int32): cint {.importc: "janet_indexed_view".}
proc bytes_view*(str: Janet; data: ptr ptr uint8; len: ptr int32): cint {.importc: "janet_bytes_view".}
proc dictionary_view*(tab: Janet; data: ptr KV; len: ptr int32; cap: ptr int32): cint {.importc: "janet_dictionary_view".}
proc dictionary_get*(data: KV; cap: int32; key: Janet): Janet {.importc: "janet_dictionary_get".}
proc dictionary_next*(kvs: KV; cap: int32; kv: KV): KV {.importc: "janet_dictionary_next".}

proc head*(u: Abstract): ptr AbstractHead =
    return cast[ptr AbstractHead](cast[int](u) - offsetof(AbstractHead, data))

proc typee*(u: Abstract): ptr AbstractType =
    return head(u).typee

proc size*(u: Abstract): csize =
    return head(u).size

# XXX i think these are all deep knowledge voodoo procs
proc janet_abstract_begin*(typee: ptr AbstractType; size: csize): pointer {.importc: "janet_abstract_begin".}
proc janet_abstract_end*(abstractTemplate: pointer): Abstract {.importc: "janet_abstract_end".}

proc janet_abstract(typee: ptr AbstractType; size: csize): Abstract {.importc: "janet_abstract".}

proc new*(_: typedesc[Abstract]; size: uint): Abstract =
    return janet_abstract(size.csize)

proc native*(name: cstring; error: ptr String): Module {.importc: "janet_native".}
proc marshal*(buf: ptr Buffer; x: Janet; rreg: ptr Table; flags: cint) {.importc: "janet_marshal".}
proc unmarshal*(bytes: ptr uint8; len: csize; flags: cint; reg: ptr Table; next: ptr ptr uint8): Janet {.importc: "janet_unmarshal".}
proc env_lookup*(env: ptr Table): ptr Table {.importc: "janet_env_lookup".}
proc env_lookup_into*(renv: ptr Table; env: ptr Table; prefix: ptr char; recurse: cint) {.importc: "janet_env_lookup_into".}
proc mark*(x: Janet) {.importc: "janet_mark".}
proc sweep*() {.importc: "janet_sweep".}
proc collect*() {.importc: "janet_collect".}
proc clear_memory*() {.importc: "janet_clear_memory".}
proc gcroot*(root: Janet) {.importc: "janet_gcroot".}
proc gcunroot*(root: Janet): cint {.importc: "janet_gcunroot".}
proc gcunrootall*(root: Janet): cint {.importc: "janet_gcunrootall".}
proc gclock*(): cint {.importc: "janet_gclock".}
proc gcunlock*(handle: cint) {.importc: "janet_gcunlock".}
proc funcdef_alloc*(): ptr FuncDef {.importc: "janet_funcdef_alloc".}
proc thunk*(def: ptr FuncDef): ptr Function {.importc: "janet_thunk".}
proc verify*(def: ptr FuncDef): cint {.importc: "janet_verify".}
proc pretty*(buffer: ptr Buffer; depth: cint; flags: cint; x: Janet): ptr Buffer {.importc: "janet_pretty".}
proc equals*(x, y: Janet): cint {.importc: "janet_equals".}
proc hash*(x: Janet): int32 {.importc: "janet_hash".}
proc compare*(x, y: Janet): cint {.importc: "janet_compare".}
proc cstrcmp*(str: String; other: cstring): cint {.importc: "janet_cstrcmp".}
proc inn*(ds: Janet; key: Janet): Janet {.importc: "janet_in".}
proc get*(ds: Janet; key: Janet): Janet {.importc: "janet_get".}
proc getindex*(ds: Janet; index: int32): Janet {.importc: "janet_getindex".}
proc length*(x: Janet): int32 {.importc: "janet_length".}
proc lengthv*(x: Janet): Janet {.importc: "janet_lengthv".}
proc put*(ds, key, value: Janet) {.importc: "janet_put".}
proc putindex*(ds: Janet; index: int32; value: Janet) {.importc: "janet_putindex".}
proc wrap_number_safe*(x: cdouble): Janet {.importc: "janet_wrap_number_safe".}
proc keyeq*(x: Janet; cstr: cstring): cint {.importc: "janet_keyeq".}
proc streq*(x: Janet; cstr: cstring): cint {.importc: "janet_streq".}

proc flag_at*(F, I: uint): uint {.inline.} =
    return (F and (1'u shl I))

proc symeq*(x: Janet; cstr: cstring): cint {.importc: "janet_symeq".}
proc init*(): cint {.importc: "janet_init".}
proc deinit*() {.importc: "janet_deinit".}
proc continuee*(fiber: ptr Fiber; inn: Janet; outt: ptr Janet): Signal {.importc: "janet_continue".}
proc pcall*(fun: ptr Function; argn: int32; argv: ptr Janet; outt: ptr Janet; f: ptr Fiber): Signal {.importc: "janet_pcall".}
proc step*(fiber: ptr Fiber; inn: Janet; outt: ptr Janet): Signal {.importc: "janet_step".}
proc call*(fun: ptr Function; argc: int32; argv: ptr Janet): Janet {.importc: "janet_call".}
proc mcall*(name: cstring; argc: int32; argv: ptr Janet): Janet {.importc: "janet_mcall".}
proc stacktrace*(fiber: ptr Fiber; err: Janet) {.importc: "janet_stacktrace".}

type
    ScratchFinalizer* = proc(pointy: pointer) {.cdecl.}

proc smalloc*(size: csize): pointer {.importc: "janet_smalloc".}
proc srealloc*(mem: pointer; size: csize): pointer {.importc: "janet_srealloc".}
proc sfinalizer*(mem: pointer; finalizer: ScratchFinalizer) {.importc: "janet_sfinalizer".}
proc sfree*(mem: pointer) {.importc: "janet_sfree".}
proc def*(env: ptr Table; name: cstring; val: Janet; documentation: cstring) {.importc: "janet_def".}
proc varr*(env: ptr Table; name: cstring; val: Janet; documentation: cstring) {.importc: "janet_var".}
proc cfuns*(env: ptr Table; regprefix: cstring; cfuns: ptr Reg) {.importc: "janet_cfuns".}
proc resolve*(env: ptr Table; sym: Symbol; outt: ptr Janet): BindingType {.importc: "janet_resolve".}
proc register*(name: cstring; cfun: CFunction) {.importc: "janet_register".}
proc resolve_core*(name: cstring): Janet {.importc: "janet_resolve_core".}

const
    JANET_ENTRY_NAME* = "_janet_init"

when JANET_MODULE_ENTRY == true:
    # TODO figure out what we want to do with this
    static: assert(false)
    # XXX called _janet_mod_config in C
    proc mod_config(): JanetBuildConfig =
        return config_current()

    # JANET_API void JANET_ENTRY_NAME

proc panic*(message: Janet) {.importc: "janet_panicv".}
proc panic*(message: cstring) {.importc: "janet_panic".}
proc panic*(message: String) {.importc: "janet_panics".}
proc panicf*(format: cstring) {.varargs, importc: "janet_panicf".}
proc dynprintf*(name: cstring; dflt_file: ptr FILE; format: cstring) {.varargs, importc: "janet_dynprintf".}

# TODO; but not important since nim has its own
#define janet_printf(...) janet_dynprintf("out", stdout, __VA_ARGS__)
proc panic_type*(x: Janet; n: int32; expected: cint) {.importc: "janet_panic_type".}
proc panic_abstract*(x: Janet; n: int32; at: ptr AbstractType) {.importc: "janet_panic_abstract".}
proc arity*(arity: int32; min: int32; max: int32) {.importc: "janet_arity".}
proc fixarity*(arity: int32; fix: int32) {.importc: "janet_fixarity".}
proc getmethod*(methodd: Keyword; methods: ptr Method; outt: ptr Janet): cint {.importc: "janet_getmethod".}
proc getnumber*(argv: ptr Janet; n: int32): cdouble {.importc: "janet_getnumber".}
proc getarray*(argv: ptr Janet; n: int32): ptr Array {.importc: "janet_getarray".}
proc gettuple*(argv: ptr Janet; n: int32): Tuple {.importc: "janet_gettuple".}
proc gettable*(argv: ptr Janet; n: int32): ptr Table {.importc: "janet_gettable".}
proc getstruct*(argv: ptr Janet; n: int32): Struct {.importc: "janet_getstruct".}
proc getstring*(argv: ptr Janet; n: int32): String {.importc: "janet_getstring".}
proc getcstring*(argv: ptr Janet; n: int32): cstring {.importc: "janet_getcstring".}
proc getsymbol*(argv: ptr Janet; n: int32): Symbol {.importc: "janet_getsymbol".}
proc getkeyword*(argv: ptr Janet; n: int32): Keyword {.importc: "janet_getkeyword".}
proc getbuffer*(argv: ptr Janet; n: int32): ptr Buffer {.importc: "janet_getbuffer".}
proc getfiber*(argv: ptr Janet; n: int32): ptr Fiber {.importc: "janet_getfiber".}
proc getfunction*(argv: ptr Janet; n: int32): ptr Function {.importc: "janet_getfunction".}
proc getcfunction*(argv: ptr Janet; n: int32): CFunction {.importc: "janet_getcfunction".}
proc getboolean*(argv: ptr Janet; n: int32): cint {.importc: "janet_getboolean".}
proc getpointer*(argv: ptr Janet; n: int32): pointer {.importc: "janet_getpointer".}
proc getnat*(argv: ptr Janet; n: int32): int32 {.importc: "janet_getnat".}
proc getinteger*(argv: ptr Janet; n: int32): int32 {.importc: "janet_getinteger".}
proc getinteger64*(argv: ptr Janet; n: int32): int64 {.importc: "janet_getinteger64".}
proc getsize*(argv: ptr Janet; n: int32): csize {.importc: "janet_getsize".}
proc getindexed*(argv: ptr Janet; n: int32): View {.importc: "janet_getindexed".}
proc getbytes*(argv: ptr Janet; n: int32): ByteView {.importc: "janet_getbytes".}
proc getdictionary*(argv: ptr Janet; n: int32): DictView {.importc: "janet_getdictionary".}
proc getabstract*(argv: ptr Janet; n: int32; at: ptr AbstractType): pointer {.importc: "janet_getabstract".}
proc getslice*(argc: int32; argv: ptr Janet): Range {.importc: "janet_getslice".}
proc gethalfrange*(argv: ptr Janet; n, length: int32; which: cstring): int32 {.importc: "janet_gethalfrange".}
proc getargindex*(argv: ptr Janet; n, length: int32; which: cstring): int32 {.importc: "janet_getargindex".}
proc getflags*(argv: int32; n: cstring; flags: ptr Janet): uint64 {.importc: "janet_getflags".}
proc optnumber*(argv: ptr Janet; argc: int32; n: int32; dflt: cdouble): cdouble {.importc: "janet_optnumber".}
proc opttuple*(argv: ptr Janet; argc: int32; n: int32; dflt: Tuple): Tuple {.importc: "janet_opttuple".}
proc optstruct*(argv: ptr Janet; argc: int32; n: int32; dflt: Struct): Struct {.importc: "janet_optstruct".}
proc optstring*(argv: ptr Janet; argc: int32; n: int32; dflt: String): String {.importc: "janet_optstring".}
proc optcstring*(argv: ptr Janet; argc: int32; n: int32; dflt: cstring): cstring {.importc: "janet_optcstring".}
proc optsymbol*(argv: ptr Janet; argc: int32; n: int32; dflt: String): Symbol {.importc: "janet_optsymbol".}
proc optkeyword*(argv: ptr Janet; argc: int32; n: int32; dflt: String): Keyword {.importc: "janet_optkeyword".}
proc optfiber*(argv: ptr Janet; argc: int32; n: int32; dflt: ptr Fiber): ptr Fiber {.importc: "janet_optfiber".}
proc optfunction*(argv: ptr Janet; argc: int32; n: int32; dflt: ptr Function): ptr Function {.importc: "janet_optfunction".}
proc optcfunction*(argv: ptr Janet; argc: int32; n: int32; dflt: CFunction): CFunction {.importc: "janet_optcfunction".}
proc optboolean*(argv: ptr Janet; argc: int32; n: int32; dflt: cint): cint {.importc: "janet_optboolean".}
proc optpointer*(argv: ptr Janet; argc: int32; n: int32; dflt: pointer): pointer {.importc: "janet_optpointer".}
proc optnat*(argv: ptr Janet; argc: int32; n: int32; dflt: int32): int32 {.importc: "janet_optnat".}
proc optinteger*(argv: ptr Janet; argc: int32; n: int32; dflt: int32): int32 {.importc: "janet_optinteger".}
proc optinteger64*(argv: ptr Janet; argc: int32; n: int32; dflt: int64): int64 {.importc: "janet_optinteger64".}
proc optsize*(argv: ptr Janet; argc: int32; n: int32; dflt: csize): csize {.importc: "janet_optsize".}
proc optabstract*(argv: ptr Janet; argc: int32; n: int32; att: ptr AbstractType; dflt: Abstract): Abstract {.importc: "janet_optabstract".}
proc optbuffer*(argv: ptr Janet; argc: int32; n: int32; dflt_len: int32): ptr Buffer {.importc: "janet_optbuffer".}
proc opttable*(argv: ptr Janet; argc: int32; n: int32; dflt_len: int32): ptr Table {.importc: "janet_opttable".}
proc optarray*(argv: ptr Janet; argc: int32; n: int32; dflt_len: int32): ptr Array {.importc: "janet_optarray".}
proc dyn*(name: cstring): Janet {.importc: "janet_dyn".}
proc setdyn*(name: cstring; value: Janet) {.importc: "janet_setdyn".}
proc getfile*(argv: ptr Janet; n: int32; flags: ptr cint): ptr FILE {.importc: "janet_getfile".}
proc dynfile*(name: cstring; def: ptr FILE): ptr FILE {.importc: "janet_dynfile".}

proc marshal*(ctx: ptr MarshalContext; value: csize) {.importc: "janet_marshal_size".}
proc marshal*(ctx: ptr MarshalContext; value: int32) {.importc: "janet_marshal_int".}
proc marshal*(ctx: ptr MarshalContext; value: int64) {.importc: "janet_marshal_int64".}
proc marshal*(ctx: ptr MarshalContext; value: uint8) {.importc: "janet_marshal_byte".}
proc marshal*(ctx: ptr MarshalContext; bytes: ptr uint8; len: csize) {.importc: "janet_marshal_bytes".}
proc marshal*(ctx: ptr MarshalContext; x: Janet) {.importc: "janet_marshal_janet".}
proc marshal*(ctx: ptr MarshalContext; abstract: Abstract) {.importc: "janet_marshal_abstract".}

proc unmarshal_ensure*(ctx: ptr MarshalContext; size: csize) {.importc: "janet_unmarshal_ensure".}
proc unmarshal_size*(ctx: ptr MarshalContext): csize {.importc: "janet_unmarshal_size".}
proc unmarshal_int*(ctx: ptr MarshalContext): int32 {.importc: "janet_unmarshal_int".}
proc unmarshal_int64*(ctx: ptr MarshalContext): int64 {.importc: "janet_unmarshal_int64".}
proc unmarshal_byte*(ctx: ptr MarshalContext): uint8 {.importc: "janet_unmarshal_byte".}
proc unmarshal_bytes*(ctx: ptr MarshalContext; dest: ptr uint8; len: csize) {.importc: "janet_unmarshal_bytes".}
proc unmarshal_janet*(ctx: ptr MarshalContext): Janet {.importc: "janet_unmarshal_janet".}
proc unmarshal_abstract*(ctx: ptr MarshalContext; size: csize): Abstract {.importc: "janet_unmarshal_abstract".}
proc register_abstract_type*(at: ptr AbstractType) {.importc: "janet_register_abstract_type".}
proc get_abstract_type*(key: Janet): ptr AbstractType {.importc: "janet_get_abstract_type".}

when JANET_TYPED_ARRAY == true:
    type
        TArrayBuffer* {.importc: "JanetTArrayBuffer", jantype.} = object
            data:  ptr uint8
            size:  csize
            flags: int32

        TArrayViewAs* {.union.} = object
            pointerr: pointer
            u8: ptr uint8
            s8: ptr int8
            u16: ptr uint16
            s16: ptr int16
            u32: ptr uint32
            s32: ptr int32
            u64: ptr uint64
            s64: ptr int64
            f32: ptr cfloat
            f64: ptr cdouble

        TArrayView* {.importc: "JanetTArrayView", jantype.} = object
            ass*:    TArrayViewAs
            buffer*: ptr TArrayBuffer
            size*:   csize
            stride*: csize
            typee*:  TArrayType

    proc tarray_buffer*(size: csize): ptr TArrayBuffer {.importc: "janet_tarray_buffer".}
    proc tarray_view*(typee: TArrayType; size: csize; stride: csize; offset: csize; buffer: ptr TArrayBuffer): ptr TArrayView {.importc: "janet_tarray_view".}
    proc is_tarray_view*(x: Janet; typee: TArrayType): cint {.importc: "janet_is_tarray_view".}
    proc gettarray_buffer*(argv: ptr Janet; n: int32): ptr TArrayBuffer {.importc: "janet_gettarray_buffer".}
    proc gettarray_view*(argv: ptr Janet; n: int32; typee: TArrayType): ptr TArrayView {.importc: "janet_gettarray_view".}
    proc gettarray_any*(argv: ptr Janet; n: int32): ptr TArrayView {.importc: "janet_gettarray_any".}

when JANET_INT_TYPES == true:
    proc is_int*(x: Janet): IntType {.importc: "janet_is_int".}
    proc wrap*(x: int64): Janet {.importc: "janet_wrap_s64".}
    proc wrap*(x: uint64): Janet {.importc: "janet_wrap_u64".}
    proc unwrap_s64*(x: Janet): int64 {.importc: "janet_unwrap_s64".}
    proc unwrap_u64*(x: Janet): uint64 {.importc: "janet_unwrap_u64".}
    proc scan_int64*(str: ptr uint8; len: int32; outt: ptr int64): cint {.importc: "janet_scan_int64".}
    proc scan_uint64*(str: ptr uint8; len: int32; outt: ptr uint64): cint {.importc: "janet_scan_uint64".}
