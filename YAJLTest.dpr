program YAJLTest;

uses
  Forms,
  uMain in 'uMain.pas' {fMain},
  yajl_parse in 'yajl_parse.pas',
  yajl_common in 'yajl_common.pas',
  yajl_gen in 'yajl_gen.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfMain, fMain);
  Application.Run;
end.
