
proc abstract_head*(abstract: pointer): ptr AbstractHead  {.importc: "janet_abstract_head", cdecl.}
proc string_head*  (s: cstring): ptr StringHead           {.importc: "janet_string_head", cdecl.}
proc struct_head*  (st: ptr KV): ptr StructHead           {.importc: "janet_struct_head", cdecl.}
proc tuple_head*   (tuplee: ptr Janet): ptr TupleHead     {.importc: "janet_tuple_head", cdecl.}

proc checktypes*(x: Janet; typeflags: cint): cint  {.importc: "janet_checktypes", cdecl.}
proc checktype* (x: Janet; typee: JanetType): cint {.importc: "janet_checktype", cdecl.}
proc truthy*    (x: Janet): cint                   {.importc: "janet_truthy", cdecl.}
proc typee*     (x: Janet): JanetType              {.importc: "janet_type", cdecl.}

proc unwrap_abstract* (x: Janet): pointer      {.importc: "janet_unwrap_abstract", cdecl.}
proc unwrap_array*    (x: Janet): ptr Array    {.importc: "janet_unwrap_array", cdecl.}
proc unwrap_boolean*  (x: Janet): cint         {.importc: "janet_unwrap_boolean", cdecl.}
proc unwrap_buffer*   (x: Janet): ptr Buffer   {.importc: "janet_unwrap_buffer", cdecl.}
proc unwrap_cfunction*(x: Janet): CFunction    {.importc: "janet_unwrap_cfunction", cdecl.}
proc unwrap_fiber*    (x: Janet): ptr Fiber    {.importc: "janet_unwrap_fiber", cdecl.}
proc unwrap_function* (x: Janet): ptr Function {.importc: "janet_unwrap_function", cdecl.}
proc unwrap_integer*  (x: Janet): int32        {.importc: "janet_unwrap_integer", cdecl.}
proc unwrap_keyword*  (x: Janet): cstring      {.importc: "janet_unwrap_keyword", cdecl.}
proc unwrap_number*   (x: Janet): cdouble      {.importc: "janet_unwrap_number", cdecl.}
proc unwrap_pointer*  (x: Janet): pointer      {.importc: "janet_unwrap_pointer", cdecl.}
proc unwrap_string*   (x: Janet): cstring      {.importc: "janet_unwrap_string", cdecl.}
proc unwrap_struct*   (x: Janet): ptr KV       {.importc: "janet_unwrap_struct", cdecl.}
proc unwrap_symbol*   (x: Janet): cstring      {.importc: "janet_unwrap_symbol", cdecl.}
proc unwrap_table*    (x: Janet): ptr Table    {.importc: "janet_unwrap_table", cdecl.}
proc unwrap_tuple*    (x: Janet): ptr Janet    {.importc: "janet_unwrap_tuple", cdecl.}

proc wrap_abstract* (x: pointer): Janet      {.importc: "janet_wrap_abstract", cdecl.}
proc wrap_array*    (x: ptr Array): Janet    {.importc: "janet_wrap_array", cdecl.}
proc wrap_boolean*  (x: cint): Janet         {.importc: "janet_wrap_boolean", cdecl.}
proc wrap_buffer*   (x: ptr Buffer): Janet   {.importc: "janet_wrap_buffer", cdecl.}
proc wrap_cfunction*(x: CFunction): Janet    {.importc: "janet_wrap_cfunction", cdecl.}
proc wrap_false*    (): Janet                {.importc: "janet_wrap_false", cdecl.}
proc wrap_fiber*    (x: ptr Fiber): Janet    {.importc: "janet_wrap_fiber", cdecl.}
proc wrap_function* (x: ptr Function): Janet {.importc: "janet_wrap_function", cdecl.}
proc wrap_integer*  (x: int32): Janet        {.importc: "janet_wrap_integer", cdecl.}
proc wrap_keyword*  (x: cstring): Janet      {.importc: "janet_wrap_keyword", cdecl.}
proc wrap_nil*      (): Janet                {.importc: "janet_wrap_nil", cdecl.}
proc wrap_number*   (x: cdouble): Janet      {.importc: "janet_wrap_number", cdecl.}
proc wrap_pointer*  (x: pointer): Janet      {.importc: "janet_wrap_pointer", cdecl.}
proc wrap_string*   (x: cstring): Janet      {.importc: "janet_wrap_string", cdecl.}
proc wrap_struct*   (x: ptr KV): Janet       {.importc: "janet_wrap_struct", cdecl.}
proc wrap_symbol*   (x: cstring): Janet      {.importc: "janet_wrap_symbol", cdecl.}
proc wrap_table*    (x: ptr Table): Janet    {.importc: "janet_wrap_table", cdecl.}
proc wrap_true*     (): Janet                {.importc: "janet_wrap_true", cdecl.}
proc wrap_tuple*    (x: ptr Janet): Janet    {.importc: "janet_wrap_tuple", cdecl.}
