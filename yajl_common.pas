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

  Tyajl_malloc_func = function(context: pointer; sizeOf: Cardinal): Pointer of object;
  Tyajl_free_func = procedure(context: pointer; ptr: pointer) of object;
  Tyajl_realloc_func = function(context: pointer; ptr: pointer; sizeOf: cardinal): Pointer of object;

  {/** A structure which can be passed to yajl_*_alloc routines to allow the
  *  client to specify memory allocation functions to be used. */}
  {$ALIGN 8}
  yajl_alloc_funcs = record
    yajl_malloc_func: Tyajl_malloc_func;
    yajl_free_func: Tyajl_free_func;
    yajl_realloc_func: Tyajl_realloc_func;
    context: pointer;
  end;

  Pyajl_alloc_funcs = ^yajl_alloc_funcs;

implementation

end.
