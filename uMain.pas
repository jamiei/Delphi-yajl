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
  private
    // Callbacks
    function yajl_boolean(context: pointer; boolVal: Integer): integer; stdcall;
    function yajl_double(context: pointer; doubleVal: Double): integer; stdcall;
    function yajl_integer(context: pointer; integerVal: Integer): integer; stdcall;
    function yajl_number(context: pointer; numberVal: PChar;
      numberLen: Cardinal): integer; stdcall;
    function yajl_string(context: pointer; stringVal: PChar;
      stringLen: Cardinal): integer; stdcall;
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
  Context: pointer;

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
  callbacks: yajl_callbacks;
  config: yajl_parser_config;
  allocFuncs: yajl_alloc_funcs;
begin
   yajl_alloc := GetProcAddress(yajlDLLHandle, 'yajl_alloc');

   FillChar(config, SizeOf(config), #0);
   config.allowComments := 1;
   config.checkUTF8 := 0;

   FillChar(callbacks, SizeOf(callbacks), #0);
   callbacks.yajl_boolean := yajl_boolean;
   callbacks.yajl_integer := yajl_integer;
   callbacks.yajl_double := yajl_double;
   callbacks.yajl_number := yajl_number;
   callbacks.yajl_string := yajl_string;

   FillChar(allocFuncs, SizeOf(allocFuncs), #0);

   {  Tyajl_alloc = function(const callbacks: yajl_callbacks;
                         const config: yajl_parser_config;
                         const allocFuncs: yajl_alloc_funcs;
                         context: pointer): yajl_handle;}

   if Addr(yajl_alloc) <> nil then
   begin
      yajlParserHandle := yajl_alloc(@callbacks, @config, @allocFuncs, Context);
      mOutput.Lines.Add('Got Handle for yajl parser: ' + IntToStr(yajlParserHandle))
   end
   else
      mOutput.Lines.Add('Could not find function yajl_alloc...');
end;

procedure TfMain.btnAllocGenClick(Sender: TObject);
var
  yajl_gen_alloc: Tyajl_gen_alloc;
  config: yajl_gen_config;
  allocFuncs: yajl_alloc_funcs;
begin
   yajl_gen_alloc := GetProcAddress(yajlDLLHandle, 'yajl_gen_alloc');

   FillChar(allocFuncs, SizeOf(allocFuncs), #0);

   FillChar(config, SizeOf(config), #0);
   config.beautify := 1;
   config.indentString := '    ';


   {  Tyajl_alloc = function(const callbacks: yajl_callbacks;
                         const config: yajl_parser_config;
                         const allocFuncs: yajl_alloc_funcs;
                         context: pointer): yajl_handle;}

   if Addr(yajl_gen_alloc) <> nil then
   begin
      yajlGenHandle := yajl_gen_alloc(@config, @allocFuncs);
      mOutput.Lines.Add('Got Handle for yajl gen: ' + IntToStr(yajlParserHandle))
   end
   else
      mOutput.Lines.Add('Could not find function yajl_gen_alloc...');
end;

procedure TfMain.btnFinParseClick(Sender: TObject);
var
  yajl_parse_complete: Tyajl_parse_complete;
  status: yajl_status;
begin
   @yajl_parse_complete := GetProcAddress(yajlDLLHandle, 'yajl_free');

   { Tyakl_free = procedure(handle: yajl_handle);}

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
  yajl_free: Tyajl_gen_free;
begin
   yajl_free := GetProcAddress(yajlDLLHandle, 'yajl_gen_free');

   { Tyakl_free = procedure(handle: yajl_handle);}

   if Addr(yajl_free) <> nil then
   begin
      yajl_free(yajlGenHandle);
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
var
  contextLabel: integer;
begin
  LoadDll;
  if DLLLoaded then
  begin
    mOutput.Lines.Add('DLL Sucessfully Loaded');
    contextLabel := 10101;
    Context := @contextLabel;
  end;
end;

procedure TfMain.btnParseClick(Sender: TObject);
var
  yajl_parse: Tyajl_parse;
  status: yajl_status;
begin
   @yajl_parse := GetProcAddress(yajlDLLHandle, 'yajl_parse');

   { Tyakl_free = procedure(handle: yajl_handle);}

   if Addr(yajl_parse) <> nil then
   begin
      status := yajl_parse(yajlParserHandle, PWideChar(eInput.Text), Length(eInput.Text));
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

function TfMain.yajl_boolean(context: pointer; boolVal: Integer): integer;
begin
  mOutput.Lines.Add('Boolean: ' + IntToStr(boolVal));
  result := 1;
end;

function TfMain.yajl_integer(context: pointer; integerVal: LongInt): integer;
begin
  mOutput.Lines.Add('Inteegr: ' + IntToStr(integerVal));
  result := 1;
end;

function TfMain.yajl_double(context: pointer; doubleVal: Double): integer;
begin
  mOutput.Lines.Add('Double: ' + FloatToStr(doubleVal));
  result := 1;
end;

function TfMain.yajl_number(context: pointer; numberVal: PChar; numberLen: Cardinal): integer;
begin
  mOutput.Lines.Add('Number As String: ' + String(numberVal));
  result := 1;
end;

function TfMain.yajl_string(context: pointer; stringVal: PChar; stringLen: Cardinal): integer;
begin
  mOutput.Lines.Add('String: ' + String(stringVal));
  result := 1;
end;

end.
