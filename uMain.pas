{ --- uMain.pas ---
Author: jamiei

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT
OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. }
unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ImageHlp,
  yajl_parse, yajl_common, yajl_gen;

type
  TfMain = class(TForm)
    btnLoad: TButton;
    mOutput: TMemo;
    btnAlloc: TButton;
    btnFreeParser: TButton;
    btnParse: TButton;
    eInput: TEdit;
    btnFinParse: TButton;
    btnAllocGen: TButton;
    btnBuildObj: TButton;
    btnGetBuf: TButton;
    btnFreeGen: TButton;
    procedure btnLoadClick(Sender: TObject);
    procedure btnAllocClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnFreeParserClick(Sender: TObject);
    procedure btnParseClick(Sender: TObject);
    procedure btnFinParseClick(Sender: TObject);
    procedure btnAllocGenClick(Sender: TObject);
    procedure btnFreeGenClick(Sender: TObject);
    procedure btnBuildObjClick(Sender: TObject);
  private
    fAllocFuncs: yajl_alloc_funcs;
    callbacks: yajl_callbacks;
    config: yajl_parser_config;

    // Callbacks
    // yajl_boolean: Tyajl_boolean;
    function yajl_null: integer; cdecl;
    function yajl_boolean(boolVal: Integer): integer; cdecl;
    function yajl_double(doubleVal: Double): integer; cdecl;
    function yajl_integer(integerVal: Integer): integer; cdecl;
    function yajl_number(numberVal: PAnsiChar;
      numberLen: Cardinal): integer; cdecl;
    function yajl_string(stringVal: PAnsiChar;
      stringLen: Cardinal): integer; cdecl;
    function yajl_start_map: integer; cdecl;
    function yajl_map_key(stringVal: PAnsiChar; stringLen: Cardinal): integer; cdecl;
    function yajl_end_map: integer; cdecl;
    function yajl_start_array: integer; cdecl;
    function yajl_end_array: integer; cdecl;

    function yajl_malloc_func(sizeOf: Cardinal): Pointer; cdecl;
    procedure yajl_free_func(ptr: pointer); cdecl;
    function yajl_realloc_func(ptr: pointer; sizeOf: cardinal): Pointer; cdecl;

    { Private declarations }
  public
    { Public declarations }
  end;

var
  fMain: TfMain;
  yajlDLLHandle: THandle;
  yajlParserHandle: yajl_handle;
  yajlGenHandle: Tyajl_gen;
  DLLLoaded: Boolean;

implementation

{$R *.dfm}

procedure FreeDLL;
begin
  if (DLLLoaded) then
  begin
    FreeLibrary(yajlDLLHandle);
  end;
end;

procedure LoadDLL;
begin
  if DLLLoaded then Exit;
  yajlDLLHandle := LoadLibrary('yajl.dll');
  if yajlDLLHandle >= 32 then
  begin
    DLLLoaded := True;
  end
  else
  begin
    DLLLoaded := False;
  end;
end;

procedure TfMain.btnAllocClick(Sender: TObject);
var
  yajl_alloc: Tyajl_alloc;
begin
   yajl_alloc := GetProcAddress(yajlDLLHandle, 'yajl_alloc');

   FillChar(config, SizeOf(config), #0);
   config.allowComments := 1;
   config.checkUTF8 := 0;

   FillChar(callbacks, SizeOf(callbacks), #0);
   callbacks.yajl_null := @TfMain.yajl_null;
   callbacks.yajl_boolean := @TfMain.yajl_boolean;
   callbacks.yajl_integer := @TfMain.yajl_integer;
   callbacks.yajl_double := @TfMain.yajl_double;
   callbacks.yajl_number := @TfMain.yajl_number;
   callbacks.yajl_string := @TfMain.yajl_string;
   callbacks.yajl_start_map := @TfMain.yajl_start_map;
   callbacks.yajl_map_key := @TfMain.yajl_map_key;
   callbacks.yajl_end_map := @TfMain.yajl_end_map;
   callbacks.yajl_start_array := @TfMain.yajl_start_array;
   callbacks.yajl_end_array := @TfMain.yajl_end_array;

   fAllocFuncs.yajl_malloc_func := @TfMain.yajl_malloc_func;
   fAllocFuncs.yajl_free_func := @TfMain.yajl_free_func;
   fAllocFuncs.yajl_realloc_func := @TfMain.yajl_realloc_func;
   fAllocFuncs.context := Self;

   {  Tyajl_alloc = function(const callbacks: yajl_callbacks;
                         const config: yajl_parser_config;
                         const allocFuncs: yajl_alloc_funcs;
                         context: pointer): yajl_handle;}

   if Addr(yajl_alloc) <> nil then
   begin
      yajlParserHandle := yajl_alloc(@callbacks, @config, @fAllocFuncs, Self);
      mOutput.Lines.Add('Got Handle for yajl parser: ' + IntToStr(Integer(yajlParserHandle)))
   end
   else
      mOutput.Lines.Add('Could not find function yajl_alloc...');
end;

procedure TfMain.btnAllocGenClick(Sender: TObject);
var
  yajl_gen_alloc: Tyajl_gen_alloc;
  config: yajl_gen_config;
begin
   yajl_gen_alloc := GetProcAddress(yajlDLLHandle, 'yajl_gen_alloc');


   FillChar(config, SizeOf(config), #0);
   config.beautify := 1;
   config.indentString := '    ';


   {  yajl_gen YAJL_API yajl_gen_alloc(const yajl_gen_config * config,
                                     const yajl_alloc_funcs * allocFuncs); }


   if Addr(yajl_gen_alloc) <> nil then
   begin
      yajlGenHandle := yajl_gen_alloc(@config, nil);
      mOutput.Lines.Add('Got Handle for yajl gen: ' + IntToStr(Integer(yajlParserHandle)))
   end
   else
      mOutput.Lines.Add('Could not find function yajl_gen_alloc...');
end;

procedure TfMain.btnBuildObjClick(Sender: TObject);
var
  yajl_gen_string: Tyajl_gen_string;
  status: yajl_gen_status;
  str: PChar;
begin
   @yajl_gen_string := GetProcAddress(yajlDLLHandle, 'yajl_gen_string');
   str := 'Test';

   if Addr(yajl_gen_string) <> nil then
   begin
      status := yajl_gen_string(Cardinal(yajlParserHandle), str, StrLen(str));
      mOutput.Lines.Add('Got status: ' + IntToStr(Ord(status)));
   end
   else
      mOutput.Lines.Add('Could not find function yajl_gen_string...');
end;

procedure TfMain.btnFinParseClick(Sender: TObject);
var
  yajl_parse_complete: Tyajl_parse_complete;
  status: yajl_status;
begin
   @yajl_parse_complete := GetProcAddress(yajlDLLHandle, 'yajl_parse_complete');


   if Addr(yajl_parse_complete) <> nil then
   begin
      status := yajl_parse_complete(yajlParserHandle);
      mOutput.Lines.Add('Got status: ' + IntToStr(Ord(status)));
   end
   else
      mOutput.Lines.Add('Could not find function yajl_free...');
end;

procedure TfMain.btnFreeGenClick(Sender: TObject);
var
  yajl_gen_free: Tyajl_gen_free;
begin
   yajl_gen_free := GetProcAddress(yajlDLLHandle, 'yajl_gen_free');

   if Addr(yajl_gen_free) <> nil then
   begin
      yajl_gen_free(yajlGenHandle);
   end
   else
      mOutput.Lines.Add('Could not find function yajl_gen_free...');
end;

procedure TfMain.btnFreeParserClick(Sender: TObject);
var
  yajl_free: Tyajl_free;
begin
   @yajl_free := GetProcAddress(yajlDLLHandle, 'yajl_free');

   { Tyakl_free = procedure(handle: yajl_handle);}

   if Addr(yajl_free) <> nil then
   begin
      yajl_free(yajlParserHandle);
   end
   else
      mOutput.Lines.Add('Could not find function yajl_free...');
end;

procedure TfMain.btnLoadClick(Sender: TObject);
begin
  LoadDll;
  if DLLLoaded then
  begin
    mOutput.Lines.Add('DLL Sucessfully Loaded');
  end;
end;

procedure TfMain.btnParseClick(Sender: TObject);
var
  yajl_parse: Tyajl_parse;
  status: yajl_status;
  s: AnsiString;
begin
   @yajl_parse := GetProcAddress(yajlDLLHandle, 'yajl_parse');

   if Addr(yajl_parse) <> nil then
   begin
      s := AnsiString(eInput.Text);
      status := yajl_parse(yajlParserHandle, PAnsiChar(s), Length(s));
      mOutput.Lines.Add('Got status: ' + IntToStr(Ord(status)));
   end
   else
      mOutput.Lines.Add('Could not find function yajl_parse...');
end;

procedure TfMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if DLLLoaded then
  begin
    FreeDLL;
  end;
end;

function TfMain.yajl_boolean(boolVal: Integer): integer; cdecl;
begin
  mOutput.Lines.Add('Boolean: ' + IntToStr(boolVal));
  result := 1;
end;

function TfMain.yajl_integer(integerVal: LongInt): integer; cdecl;
begin
  mOutput.Lines.Add('Inteegr: ' + IntToStr(integerVal));
  result := 1;
end;

function TfMain.yajl_malloc_func(sizeOf: Cardinal): Pointer; cdecl;
begin
   Result := GetMemory(sizeOf);
   mOutput.Lines.Add(Format('malloc %d => [0x%x]', [sizeOf, Integer(Result)]));
end;

function TfMain.yajl_map_key(stringVal: PAnsiChar;
  stringLen: Cardinal): integer; cdecl;
begin
  mOutput.Lines.Add('Map Key: ' + String(stringVal));
  result := 1;
end;

function TfMain.yajl_double(doubleVal: Double): integer; cdecl;
begin
  mOutput.Lines.Add('Double: ' + FloatToStr(doubleVal));
  result := 1;
end;

function TfMain.yajl_end_array: integer; cdecl;
begin
  mOutput.Lines.Add('Ended Array');
  result := 1;
end;

function TfMain.yajl_end_map: integer; cdecl;
begin
  mOutput.Lines.Add('Ended Map');
  result := 1;
end;

procedure TfMain.yajl_free_func(ptr: pointer); cdecl;
begin
   mOutput.Lines.Add(Format('free => [0x%x]', [Integer(ptr)]));
   FreeMemory(ptr);
end;

function TfMain.yajl_null: integer; cdecl;
begin
  mOutput.Lines.Add('Null');
  result := 1;
end;

function TfMain.yajl_number(numberVal: PAnsiChar; numberLen: Cardinal): integer; cdecl;
begin
  mOutput.Lines.Add('Number As String: ' + String(numberVal));
  result := 1;
end;

function TfMain.yajl_realloc_func(ptr: pointer; sizeOf: cardinal): Pointer; cdecl;
begin
   Result := ReallocMemory(ptr, sizeOf);
   mOutput.Lines.Add(Format('realloc [0x%x] %d => [0x%x]', [Integer(ptr), sizeOf, Integer(Result)]));
end;

function TfMain.yajl_start_array: integer; cdecl;
begin
  mOutput.Lines.Add('Started array.');
  result := 1;
end;

function TfMain.yajl_start_map: integer; cdecl;
begin
  mOutput.Lines.Add('Started map.');
  result := 1;
end;

function TfMain.yajl_string(stringVal: PAnsiChar; stringLen: Cardinal): integer; cdecl;
begin
  mOutput.Lines.Add('String: ' + String(stringVal));
  result := 1;
end;

end.
