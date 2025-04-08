program EAN_VCL;

uses
  Vcl.Forms,
  EAN_MAIN in 'EAN_MAIN.pas' {FormMain},
  EAN_RESULTS in 'EAN_RESULTS.pas' {FormResults},
  EAN_DESCRIPTION in 'EAN_DESCRIPTION.pas' {FormDescription};

{$R *.res}

begin
  AssignFile(Output, 'calculations.txt');
  Rewrite(Output);

  Application.Initialize;
  Application.Title := 'N-R';
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TfrmEANResults, frmEANResults);
  Application.CreateForm(TFormDescription, FormDescription);
  Application.Run;
end.
