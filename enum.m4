m4_define(`iota', `m4_define(`iota_num',m4_eval(iota_num+1))iota_num')m4_dnl
m4_define(`enum', `type
    $1* {.importc: "$2", jantype.} = distinct cint
const
m4_define(`enum_current_name', $1)m4_dnl
m4_define(`iota_num', `-1')m4_dnl')m4_dnl
m4_define(`endenum', `m4_dnl')m4_dnl
m4_define(`elem', `    $1* = iota.enum_current_name')m4_dnl

enum(`Signal', `JanetSignal')
elem(`JANET_SIGNAL_OK')
elem(`JANET_SIGNAL_ERROR')
elem(`JANET_SIGNAL_DEBUG')
elem(`JANET_SIGNAL_YIELD')
elem(`JANET_SIGNAL_USER0')
elem(`JANET_SIGNAL_USER1')
elem(`JANET_SIGNAL_USER2')
elem(`JANET_SIGNAL_USER3')
elem(`JANET_SIGNAL_USER4')
elem(`JANET_SIGNAL_USER5')
elem(`JANET_SIGNAL_USER6')
elem(`JANET_SIGNAL_USER7')
elem(`JANET_SIGNAL_USER8')
elem(`JANET_SIGNAL_USER9')
endenum

enum(`FiberStatus', `JanetFiberStatus')
elem(`JANET_STATUS_DEAD')
elem(`JANET_STATUS_ERROR')
elem(`JANET_STATUS_DEBUG')
elem(`JANET_STATUS_PENDING')
elem(`JANET_STATUS_USER0')
elem(`JANET_STATUS_USER1')
elem(`JANET_STATUS_USER2')
elem(`JANET_STATUS_USER3')
elem(`JANET_STATUS_USER4')
elem(`JANET_STATUS_USER5')
elem(`JANET_STATUS_USER6')
elem(`JANET_STATUS_USER7')
elem(`JANET_STATUS_USER8')
elem(`JANET_STATUS_USER9')
elem(`JANET_STATUS_NEW')
elem(`JANET_STATUS_ALIVE')
endenum

enum(`JanetType', `JanetType')
elem(`JANET_NUMBER')
elem(`JANET_NIL')
elem(`JANET_BOOLEAN')
elem(`JANET_FIBER')
elem(`JANET_STRING')
elem(`JANET_SYMBOL')
elem(`JANET_KEYWORD')
elem(`JANET_ARRAY')
elem(`JANET_TUPLE')
elem(`JANET_TABLE')
elem(`JANET_STRUCT')
elem(`JANET_BUFFER')
elem(`JANET_FUNCTION')
elem(`JANET_CFUNCTION')
elem(`JANET_ABSTRACT')
elem(`JANET_POINTER')
endenum

enum(`ParserStatus', `JanetParserStatus')
elem(`JANET_PARSE_ROOT')
elem(`JANET_PARSE_ERROR')
elem(`JANET_PARSE_PENDING')
elem(`JANET_PARSE_DEAD')
endenum

enum(`OpArgType', `JanetOpArgType')
elem(`JANET_OAT_SLOT')
elem(`JANET_OAT_ENVIRONMENT')
elem(`JANET_OAT_CONSTANT')
elem(`JANET_OAT_INTEGER')
elem(`JANET_OAT_TYPE')
elem(`JANET_OAT_SIMPLETYPE')
elem(`JANET_OAT_LABEL')
elem(`JANET_OAT_FUNCDEF')
endenum

enum(`InstructionType', `JanetInstructionType')
elem(`JINT_0')
elem(`JINT_S')
elem(`JINT_L')
elem(`JINT_SS')
elem(`JINT_SL')
elem(`JINT_ST')
elem(`JINT_SI')
elem(`JINT_SD')
elem(`JINT_SU')
elem(`JINT_SSS')
elem(`JINT_SSI')
elem(`JINT_SSU')
elem(`JINT_SES')
elem(`JINT_SC')
endenum

enum(`OpCode', `JanetOpCode')
elem(`JOP_NOOP')
elem(`JOP_ERROR')
elem(`JOP_TYPECHECK')
elem(`JOP_RETURN')
elem(`JOP_RETURN_NIL')
elem(`JOP_ADD_IMMEDIATE')
elem(`JOP_ADD')
elem(`JOP_SUBTRACT')
elem(`JOP_MULTIPLY_IMMEDIATE')
elem(`JOP_MULTIPLY')
elem(`JOP_DIVIDE_IMMEDIATE')
elem(`JOP_DIVIDE')
elem(`JOP_BAND')
elem(`JOP_BOR')
elem(`JOP_BXOR')
elem(`JOP_BNOT')
elem(`JOP_SHIFT_LEFT')
elem(`JOP_SHIFT_LEFT_IMMEDIATE')
elem(`JOP_SHIFT_RIGHT')
elem(`JOP_SHIFT_RIGHT_IMMEDIATE')
elem(`JOP_SHIFT_RIGHT_UNSIGNED')
elem(`JOP_SHIFT_RIGHT_UNSIGNED_IMMEDIATE')
elem(`JOP_MOVE_FAR')
elem(`JOP_MOVE_NEAR')
elem(`JOP_JUMP')
elem(`JOP_JUMP_IF')
elem(`JOP_JUMP_IF_NOT')
elem(`JOP_GREATER_THAN')
elem(`JOP_GREATER_THAN_IMMEDIATE')
elem(`JOP_LESS_THAN')
elem(`JOP_LESS_THAN_IMMEDIATE')
elem(`JOP_EQUALS')
elem(`JOP_EQUALS_IMMEDIATE')
elem(`JOP_COMPARE')
elem(`JOP_LOAD_NIL')
elem(`JOP_LOAD_TRUE')
elem(`JOP_LOAD_FALSE')
elem(`JOP_LOAD_INTEGER')
elem(`JOP_LOAD_CONSTANT')
elem(`JOP_LOAD_UPVALUE')
elem(`JOP_LOAD_SELF')
elem(`JOP_SET_UPVALUE')
elem(`JOP_CLOSURE')
elem(`JOP_PUSH')
elem(`JOP_PUSH_2')
elem(`JOP_PUSH_3')
elem(`JOP_PUSH_ARRAY')
elem(`JOP_CALL')
elem(`JOP_TAILCALL')
elem(`JOP_RESUME')
elem(`JOP_SIGNAL')
elem(`JOP_PROPAGATE')
elem(`JOP_IN')
elem(`JOP_GET')
elem(`JOP_PUT')
elem(`JOP_GET_INDEX')
elem(`JOP_PUT_INDEX')
elem(`JOP_LENGTH')
elem(`JOP_MAKE_ARRAY')
elem(`JOP_MAKE_BUFFER')
elem(`JOP_MAKE_STRING')
elem(`JOP_MAKE_STRUCT')
elem(`JOP_MAKE_TABLE')
elem(`JOP_MAKE_TUPLE')
elem(`JOP_MAKE_BRACKET_TUPLE')
elem(`JOP_NUMERIC_LESS_THAN')
elem(`JOP_NUMERIC_LESS_THAN_EQUAL')
elem(`JOP_NUMERIC_GREATER_THAN')
elem(`JOP_NUMERIC_GREATER_THAN_EQUAL')
elem(`JOP_NUMERIC_EQUAL')
elem(`JOP_INSTRUCTION_COUNT')
endenum

enum(`AssembleStatus', `JanetAssembleStatus')
elem(`JANET_ASSEMBLE_OK')
elem(`JANET_ASSEMBLE_ERROR')
endenum

enum(`CompileStatus', `JanetCompileStatus')
elem(`JANET_COMPILE_OK')
elem(`JANET_COMPILE_ERROR')
endenum

enum(`BindingType', `JanetBindingType')
elem(`JANET_BINDING_NONE')
elem(`JANET_BINDING_DEF')
elem(`JANET_BINDING_VAR')
elem(`JANET_BINDING_MACRO')
endenum

enum(`TArrayType', `JanetTArrayType')
elem(`JANET_TARRAY_TYPE_U8')
elem(`JANET_TARRAY_TYPE_S8')
elem(`JANET_TARRAY_TYPE_U16')
elem(`JANET_TARRAY_TYPE_S16')
elem(`JANET_TARRAY_TYPE_U32')
elem(`JANET_TARRAY_TYPE_S32')
elem(`JANET_TARRAY_TYPE_U64')
elem(`JANET_TARRAY_TYPE_S64')
elem(`JANET_TARRAY_TYPE_F32')
elem(`JANET_TARRAY_TYPE_F64')
endenum

enum(`IntType', `JanetIntType')
elem(`JANET_INT_NONE')
elem(`JANET_INT_S64')
elem(`JANET_INT_U64')
endenum