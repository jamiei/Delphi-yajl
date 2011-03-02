{ --- yajl_common.pas ---
Author: jamiei

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT
OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. }
unit yajl_common;

interface

type

  {
  /** pointer to a malloc function, supporting client overriding memory
   *  allocation routines */
  typedef void * (*yajl_malloc_func)(void *ctx, unsigned int sz);

  /** pointer to a free function, supporting client overriding memory
   *  allocation routines */
  typedef void (*yajl_free_func)(void *ctx, void * ptr);

  /** pointer to a realloc function which can resize an allocation. */
  typedef void * (*yajl_realloc_func)(void *ctx, void * ptr, unsigned int sz);
  }

  Tyajl_malloc_func = function(context: pointer; sizeOf: Cardinal): Pointer; cdecl;
  Tyajl_free_func = procedure(context: pointer; ptr: pointer); cdecl;
  Tyajl_realloc_func = function(context: pointer; ptr: pointer; sizeOf: cardinal): Pointer; cdecl;

  {/** A structure which can be passed to yajl_*_alloc routines to allow the
  *  client to specify memory allocation functions to be used. */}
//  {$ALIGN 4}
  yajl_alloc_funcs = record
    yajl_malloc_func: ^Tyajl_malloc_func;
    yajl_realloc_func: ^Tyajl_realloc_func;
    yajl_free_func: ^Tyajl_free_func;
    context: pointer;
  end;

  Pyajl_alloc_funcs = ^yajl_alloc_funcs;

implementation

end.
