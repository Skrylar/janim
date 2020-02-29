
type
    Signal* {.importc: "JanetSignal", jantype.} = distinct cint
const
    JANET_SIGNAL_OK* = 0.Signal
    JANET_SIGNAL_ERROR* = 1.Signal
    JANET_SIGNAL_DEBUG* = 2.Signal
    JANET_SIGNAL_YIELD* = 3.Signal
    JANET_SIGNAL_USER0* = 4.Signal
    JANET_SIGNAL_USER1* = 5.Signal
    JANET_SIGNAL_USER2* = 6.Signal
    JANET_SIGNAL_USER3* = 7.Signal
    JANET_SIGNAL_USER4* = 8.Signal
    JANET_SIGNAL_USER5* = 9.Signal
    JANET_SIGNAL_USER6* = 10.Signal
    JANET_SIGNAL_USER7* = 11.Signal
    JANET_SIGNAL_USER8* = 12.Signal
    JANET_SIGNAL_USER9* = 13.Signal

type
    FiberStatus* {.importc: "JanetFiberStatus", jantype.} = distinct cint
const
    JANET_STATUS_DEAD* = 0.FiberStatus
    JANET_STATUS_ERROR* = 1.FiberStatus
    JANET_STATUS_DEBUG* = 2.FiberStatus
    JANET_STATUS_PENDING* = 3.FiberStatus
    JANET_STATUS_USER0* = 4.FiberStatus
    JANET_STATUS_USER1* = 5.FiberStatus
    JANET_STATUS_USER2* = 6.FiberStatus
    JANET_STATUS_USER3* = 7.FiberStatus
    JANET_STATUS_USER4* = 8.FiberStatus
    JANET_STATUS_USER5* = 9.FiberStatus
    JANET_STATUS_USER6* = 10.FiberStatus
    JANET_STATUS_USER7* = 11.FiberStatus
    JANET_STATUS_USER8* = 12.FiberStatus
    JANET_STATUS_USER9* = 13.FiberStatus
    JANET_STATUS_NEW* = 14.FiberStatus
    JANET_STATUS_ALIVE* = 15.FiberStatus

type
    JanetType* {.importc: "JanetType", jantype.} = distinct cint
const
    JANET_NUMBER* = 0.JanetType
    JANET_NIL* = 1.JanetType
    JANET_BOOLEAN* = 2.JanetType
    JANET_FIBER* = 3.JanetType
    JANET_STRING* = 4.JanetType
    JANET_SYMBOL* = 5.JanetType
    JANET_KEYWORD* = 6.JanetType
    JANET_ARRAY* = 7.JanetType
    JANET_TUPLE* = 8.JanetType
    JANET_TABLE* = 9.JanetType
    JANET_STRUCT* = 10.JanetType
    JANET_BUFFER* = 11.JanetType
    JANET_FUNCTION* = 12.JanetType
    JANET_CFUNCTION* = 13.JanetType
    JANET_ABSTRACT* = 14.JanetType
    JANET_POINTER* = 15.JanetType

type
    ParserStatus* {.importc: "JanetParserStatus", jantype.} = distinct cint
const
    JANET_PARSE_ROOT* = 0.ParserStatus
    JANET_PARSE_ERROR* = 1.ParserStatus
    JANET_PARSE_PENDING* = 2.ParserStatus
    JANET_PARSE_DEAD* = 3.ParserStatus

type
    OpArgType* {.importc: "JanetOpArgType", jantype.} = distinct cint
const
    JANET_OAT_SLOT* = 0.OpArgType
    JANET_OAT_ENVIRONMENT* = 1.OpArgType
    JANET_OAT_CONSTANT* = 2.OpArgType
    JANET_OAT_INTEGER* = 3.OpArgType
    JANET_OAT_TYPE* = 4.OpArgType
    JANET_OAT_SIMPLETYPE* = 5.OpArgType
    JANET_OAT_LABEL* = 6.OpArgType
    JANET_OAT_FUNCDEF* = 7.OpArgType

type
    InstructionType* {.importc: "JanetInstructionType", jantype.} = distinct cint
const
    JINT_0* = 0.InstructionType
    JINT_S* = 1.InstructionType
    JINT_L* = 2.InstructionType
    JINT_SS* = 3.InstructionType
    JINT_SL* = 4.InstructionType
    JINT_ST* = 5.InstructionType
    JINT_SI* = 6.InstructionType
    JINT_SD* = 7.InstructionType
    JINT_SU* = 8.InstructionType
    JINT_SSS* = 9.InstructionType
    JINT_SSI* = 10.InstructionType
    JINT_SSU* = 11.InstructionType
    JINT_SES* = 12.InstructionType
    JINT_SC* = 13.InstructionType

type
    OpCode* {.importc: "JanetOpCode", jantype.} = distinct cint
const
    JOP_NOOP* = 0.OpCode
    JOP_ERROR* = 1.OpCode
    JOP_TYPECHECK* = 2.OpCode
    JOP_RETURN* = 3.OpCode
    JOP_RETURN_NIL* = 4.OpCode
    JOP_ADD_IMMEDIATE* = 5.OpCode
    JOP_ADD* = 6.OpCode
    JOP_SUBTRACT* = 7.OpCode
    JOP_MULTIPLY_IMMEDIATE* = 8.OpCode
    JOP_MULTIPLY* = 9.OpCode
    JOP_DIVIDE_IMMEDIATE* = 10.OpCode
    JOP_DIVIDE* = 11.OpCode
    JOP_BAND* = 12.OpCode
    JOP_BOR* = 13.OpCode
    JOP_BXOR* = 14.OpCode
    JOP_BNOT* = 15.OpCode
    JOP_SHIFT_LEFT* = 16.OpCode
    JOP_SHIFT_LEFT_IMMEDIATE* = 17.OpCode
    JOP_SHIFT_RIGHT* = 18.OpCode
    JOP_SHIFT_RIGHT_IMMEDIATE* = 19.OpCode
    JOP_SHIFT_RIGHT_UNSIGNED* = 20.OpCode
    JOP_SHIFT_RIGHT_UNSIGNED_IMMEDIATE* = 21.OpCode
    JOP_MOVE_FAR* = 22.OpCode
    JOP_MOVE_NEAR* = 23.OpCode
    JOP_JUMP* = 24.OpCode
    JOP_JUMP_IF* = 25.OpCode
    JOP_JUMP_IF_NOT* = 26.OpCode
    JOP_GREATER_THAN* = 27.OpCode
    JOP_GREATER_THAN_IMMEDIATE* = 28.OpCode
    JOP_LESS_THAN* = 29.OpCode
    JOP_LESS_THAN_IMMEDIATE* = 30.OpCode
    JOP_EQUALS* = 31.OpCode
    JOP_EQUALS_IMMEDIATE* = 32.OpCode
    JOP_COMPARE* = 33.OpCode
    JOP_LOAD_NIL* = 34.OpCode
    JOP_LOAD_TRUE* = 35.OpCode
    JOP_LOAD_FALSE* = 36.OpCode
    JOP_LOAD_INTEGER* = 37.OpCode
    JOP_LOAD_CONSTANT* = 38.OpCode
    JOP_LOAD_UPVALUE* = 39.OpCode
    JOP_LOAD_SELF* = 40.OpCode
    JOP_SET_UPVALUE* = 41.OpCode
    JOP_CLOSURE* = 42.OpCode
    JOP_PUSH* = 43.OpCode
    JOP_PUSH_2* = 44.OpCode
    JOP_PUSH_3* = 45.OpCode
    JOP_PUSH_ARRAY* = 46.OpCode
    JOP_CALL* = 47.OpCode
    JOP_TAILCALL* = 48.OpCode
    JOP_RESUME* = 49.OpCode
    JOP_SIGNAL* = 50.OpCode
    JOP_PROPAGATE* = 51.OpCode
    JOP_IN* = 52.OpCode
    JOP_GET* = 53.OpCode
    JOP_PUT* = 54.OpCode
    JOP_GET_INDEX* = 55.OpCode
    JOP_PUT_INDEX* = 56.OpCode
    JOP_LENGTH* = 57.OpCode
    JOP_MAKE_ARRAY* = 58.OpCode
    JOP_MAKE_BUFFER* = 59.OpCode
    JOP_MAKE_STRING* = 60.OpCode
    JOP_MAKE_STRUCT* = 61.OpCode
    JOP_MAKE_TABLE* = 62.OpCode
    JOP_MAKE_TUPLE* = 63.OpCode
    JOP_MAKE_BRACKET_TUPLE* = 64.OpCode
    JOP_NUMERIC_LESS_THAN* = 65.OpCode
    JOP_NUMERIC_LESS_THAN_EQUAL* = 66.OpCode
    JOP_NUMERIC_GREATER_THAN* = 67.OpCode
    JOP_NUMERIC_GREATER_THAN_EQUAL* = 68.OpCode
    JOP_NUMERIC_EQUAL* = 69.OpCode
    JOP_INSTRUCTION_COUNT* = 70.OpCode

type
    AssembleStatus* {.importc: "JanetAssembleStatus", jantype.} = distinct cint
const
    JANET_ASSEMBLE_OK* = 0.AssembleStatus
    JANET_ASSEMBLE_ERROR* = 1.AssembleStatus

type
    CompileStatus* {.importc: "JanetCompileStatus", jantype.} = distinct cint
const
    JANET_COMPILE_OK* = 0.CompileStatus
    JANET_COMPILE_ERROR* = 1.CompileStatus

type
    BindingType* {.importc: "JanetBindingType", jantype.} = distinct cint
const
    JANET_BINDING_NONE* = 0.BindingType
    JANET_BINDING_DEF* = 1.BindingType
    JANET_BINDING_VAR* = 2.BindingType
    JANET_BINDING_MACRO* = 3.BindingType

type
    TArrayType* {.importc: "JanetTArrayType", jantype.} = distinct cint
const
    JANET_TARRAY_TYPE_U8* = 0.TArrayType
    JANET_TARRAY_TYPE_S8* = 1.TArrayType
    JANET_TARRAY_TYPE_U16* = 2.TArrayType
    JANET_TARRAY_TYPE_S16* = 3.TArrayType
    JANET_TARRAY_TYPE_U32* = 4.TArrayType
    JANET_TARRAY_TYPE_S32* = 5.TArrayType
    JANET_TARRAY_TYPE_U64* = 6.TArrayType
    JANET_TARRAY_TYPE_S64* = 7.TArrayType
    JANET_TARRAY_TYPE_F32* = 8.TArrayType
    JANET_TARRAY_TYPE_F64* = 9.TArrayType

type
    IntType* {.importc: "JanetIntType", jantype.} = distinct cint
const
    JANET_INT_NONE* = 0.IntType
    JANET_INT_S64* = 1.IntType
    JANET_INT_U64* = 2.IntType
