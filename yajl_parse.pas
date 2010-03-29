{ --- yajl_parse.pas ---
Author: jamiei

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT
OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. }
unit yajl_parse;

interface

uses
  classes,

  yajl_common;

type
  {$Z4}
  yajl_status = (
                  // no error was encountered
                  yajl_status_ok,
                  // a client callback returned zero, stopping the parse
                  yajl_status_client_canceled,
                  {** The parse cannot yet complete because more json input text
                   *  is required, call yajl_parse with the next buffer of input text.
                   *  (pertinent only when stream parsing) *}
                  yajl_status_insufficient_data,
                  {** An error occured during the parse.  Call yajl_get_error for
                   *  more information about the encountered error }
                  yajl_status_error
                );

  yajl_handle = THandle;

  Tyajl_null = function(context: pointer): integer of object; stdcall;
  Tyajl_boolean = function(context: pointer; boolVal: Integer): integer of object; stdcall;
  Tyajl_integer = function(context: pointer; integerVal: LongInt): integer of object; stdcall;
  Tyajl_double = function(context: pointer; doubleVal: Double): integer of object; stdcall;

  {  /** A callback which passes the string representation of the number
   *  back to the client.  Will be used for all numbers when present */    }
  Tyajl_number = function(context: pointer; numberVal: PChar; numberLen: Cardinal): integer of object; stdcall;
  {  /** strings are returned as pointers into the JSON text when,
   * possible, as a result, they are _not_ null padded */   }
  Tyajl_string = function(context: pointer; stringVal: PChar; stringLen: Cardinal): integer of object; stdcall;

  Tyajl_start_map = function(context: pointer): integer of object; stdcall;
  Tyajl_map_key = function(context: pointer; stringVal: PChar; stringLen: Cardinal): integer of object; stdcall;
  Tyajl_end_map = function(context: pointer): integer of object; stdcall;
  Tyajl_start_array = function(context: pointer): integer of object; stdcall;
  Tyajl_end_array = function(context: pointer): integer of object; stdcall;

  {$ALIGN 8}
  yajl_callbacks = record
    yajl_null: Tyajl_null;
    yajl_boolean: Tyajl_boolean;
    yajl_integer: Tyajl_integer;
    yajl_double: Tyajl_double;
    yajl_number: Tyajl_number;
    yajl_string: Tyajl_string;
    yajl_start_map: Tyajl_start_map;
    yajl_map_key: Tyajl_map_key;
    yajl_end_map: Tyajl_end_map;
    yajl_start_array: Tyajl_start_array;
    yajl_end_array: Tyajl_end_array;
  End;

  {$ALIGN 8}
  yajl_parser_config = record
    { /** if nonzero, javascript style comments will be allowed in
        *  the json input, both slash star and slash slash */       }
    allowComments: Cardinal;
    { /** if nonzero, invalid UTF8 strings will cause a parse
         *  error */                                                }
    checkUTF8: Cardinal;
  End;

  // P Structures
  Pyajl_callbacks = ^yajl_callbacks;
  Pyajl_parser_config = ^yajl_parser_config;


  {
    /** allocate a parser handle
     *  \param callbacks  a yajl callbacks structure specifying the
     *                    functions to call when different JSON entities
     *                    are encountered in the input text.  May be NULL,
     *                    which is only useful for validation.
     *  \param config     configuration parameters for the parse.
     *  \param ctx        a context pointer that will be passed to callbacks.
     */
    yajl_handle YAJL_API yajl_alloc(const yajl_callbacks * callbacks,
                                    const yajl_parser_config * config,
                                    const yajl_alloc_funcs * allocFuncs,
                                    void * ctx);
  }

  Tyajl_alloc = function(const callbacks: Pyajl_callbacks;
                         const config: Pyajl_parser_config;
                         const allocFuncs: Pyajl_alloc_funcs;
                         context: pointer): yajl_handle; stdcall;

  {
       /** free a parser handle */
    void YAJL_API yajl_free(yajl_handle handle);
  }

  Tyajl_free = procedure(handle: yajl_handle); stdcall;

  {
       /** Parse some json!
     *  \param hand - a handle to the json parser allocated with yajl_alloc
     *  \param jsonText - a pointer to the UTF8 json text to be parsed
     *  \param jsonTextLength - the length, in bytes, of input text
     */
    yajl_status YAJL_API yajl_parse(yajl_handle hand,
                                    const unsigned char * jsonText,
                                    unsigned int jsonTextLength);
  }

  Tyajl_parse = function(handle: yajl_handle;
                        const jsonText: PChar;
                        const jsonTextLegnth: Integer): yajl_status; stdcall;

  {
       /** Parse any remaining buffered json.
     *  Since yajl is a stream-based parser, without an explicit end of
     *  input, yajl sometimes can't decide if content at the end of the
     *  stream is valid or not.  For example, if "1" has been fed in,
     *  yajl can't know whether another digit is next or some character
     *  that would terminate the integer token.
     *
     *  \param hand - a handle to the json parser allocated with yajl_alloc
     */
    yajl_status yajl_parse_complete(yajl_handle hand);
  }


  Tyajl_parse_complete = function(handle: yajl_handle): yajl_status; stdcall;
  {
      /** get an error string describing the state of the
     *  parse.
     *
     *  If verbose is non-zero, the message will include the JSON
     *  text where the error occured, along with an arrow pointing to
     *  the specific char.
     *
     *  A dynamically allocated string will be returned which should
     *  be freed with yajl_free_error
     */
    unsigned char * YAJL_API yajl_get_error(yajl_handle hand, int verbose,
                                            const unsigned char * jsonText,
                                            unsigned int jsonTextLength);
    }

    Tyajl_get_error = function(handle: yajl_handle;
                               verbose: integer;
                               jsonText: PChar;
                               jsonTextLegnth: Cardinal): PChar; stdcall;
    {
    /** free an error returned from yajl_get_error */
    void YAJL_API yajl_free_error(yajl_handle hand, unsigned char * str);

    }

    Tyajl_free_error = procedure(handle: yajl_handle; str: PChar); stdcall;
implementation

end.
