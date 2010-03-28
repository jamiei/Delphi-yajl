unit yajl_gen;

interface

uses
  classes,

  yajl_common;

type
    {$Z4}
    yajl_gen_status = (
        // /** no error */
        yajl_gen_status_ok = 0,
        { /** at a point where a map key is generated, a function other than
         *  yajl_gen_string was called */  }
        yajl_gen_keys_must_be_strings,
        {/** YAJL's maximum generation depth was exceeded.  see
         *  YAJL_MAX_DEPTH */}
        yajl_max_depth_exceeded,
        {/** A generator function (yajl_gen_XXX) was called while in an error
         *  state */}
        yajl_gen_in_error_state,
        {/** A complete JSON document has been generated */}
        yajl_gen_generation_complete
    );

    Tyajl_gen = THandle;

    {$ALIGN 8}
    yajl_gen_config = record
      {/** generate indented (beautiful) output */}
      beautify: Cardinal;
      {/** an opportunity to define an indent string.  such as \\t or
         *  some number of spaces.  default is four spaces '    '.  This
         *  member is only relevant when beautify is true */}
      indentString: PChar;
    end;

    Pyajl_gen_config = ^yajl_gen_config;

    {    /** allocate a generator handle
     *  \param config a pointer to a structure containing parameters which
     *                configure the behavior of the json generator
     *  \param allocFuncs an optional pointer to a structure which allows
     *                    the client to overide the memory allocation
     *                    used by yajl.  May be NULL, in which case
     *                    malloc/free/realloc will be used.
     *
     *  \returns an allocated handle on success, NULL on failure (bad params)
     */
    yajl_gen YAJL_API yajl_gen_alloc(const yajl_gen_config * config,
                                     const yajl_alloc_funcs * allocFuncs);
    }

    Tyajl_gen_alloc = function (const config: Pyajl_gen_config;
                               allocFuncs: Pyajl_alloc_funcs): Tyajl_gen; cdecl;

    {    /** free a generator handle */
    void YAJL_API yajl_gen_free(yajl_gen handle); }

    Tyajl_gen_free = procedure (handle: Tyajl_gen); cdecl;
    {
    yajl_gen_status YAJL_API yajl_gen_integer(yajl_gen hand, long int number);
    yajl_gen_status YAJL_API yajl_gen_double(yajl_gen hand, double number);
    yajl_gen_status YAJL_API yajl_gen_number(yajl_gen hand,
                                             const char * num,
                                             unsigned int len);
    yajl_gen_status YAJL_API yajl_gen_string(yajl_gen hand,
                                             const unsigned char * str,
                                             unsigned int len);
    yajl_gen_status YAJL_API yajl_gen_null(yajl_gen hand);
    yajl_gen_status YAJL_API yajl_gen_bool(yajl_gen hand, int boolean);
    yajl_gen_status YAJL_API yajl_gen_map_open(yajl_gen hand);
    yajl_gen_status YAJL_API yajl_gen_map_close(yajl_gen hand);
    yajl_gen_status YAJL_API yajl_gen_array_open(yajl_gen hand);
    yajl_gen_status YAJL_API yajl_gen_array_close(yajl_gen hand);  }

    Tyajl_gen_integer =  function (hand: Tyajl_gen; number: LongInt): yajl_gen_status; cdecl;
    Tyajl_gen_double =  function (hand: Tyajl_gen; number: Double): yajl_gen_status; cdecl;
    Tyajl_gen_number =  function (hand: Tyajl_gen;
                                  num: PChar;
                                  len: Cardinal): yajl_gen_status; cdecl;
    Tyajl_gen_string =  function (hand: Tyajl_gen;
                                  str: PChar;
                                  len: Cardinal): yajl_gen_status; cdecl;
    Tyajl_gen_null =  function (hand: Tyajl_gen): yajl_gen_status; cdecl;
    Tyajl_gen_bool =  function (hand: Tyajl_gen; bool: integer): yajl_gen_status; cdecl;
    Tyajl_gen_map_open =  function (hand: Tyajl_gen): yajl_gen_status; cdecl;
    Tyajl_gen_map_close =  function (hand: Tyajl_gen): yajl_gen_status; cdecl;
    Tyajl_gen_array_open =  function (hand: Tyajl_gen): yajl_gen_status; cdecl;
    Tyajl_gen_array_close =  function (hand: Tyajl_gen): yajl_gen_status; cdecl;
    {
    /** access the null terminated generator buffer.  If incrementally
     *  outputing JSON, one should call yajl_gen_clear to clear the
     *  buffer.  This allows stream generation. */
    yajl_gen_status YAJL_API yajl_gen_get_buf(yajl_gen hand,
                                              const unsigned char ** buf,
                                              unsigned int * len);   }
    PByte = ^TByte;
    TByte = array of byte;

    Tyajl_gen_get_buf = function (handle: Tyajl_gen;
                                 var buf: PByte;
                                 len: Cardinal): yajl_gen_status; cdecl;
    {/** clear yajl's output buffer, but maintain all internal generation
     *  state.  This function will not "reset" the generator state, and is
     *  intended to enable incremental JSON outputing. */
    void YAJL_API yajl_gen_clear(yajl_gen hand);}

    Tyajl_gen_clear = procedure (handle: Tyajl_gen); cdecl;

implementation

end.
