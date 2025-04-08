unit EAN_MAIN;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, System.StrUtils, Vcl.ExtCtrls, Vcl.Buttons, EAN_RESULTS, EAN_DESCRIPTION;

type
  TFormMain = class(TForm)
    grpArithmetic: TGroupBox;
    rbArithmeticStd: TRadioButton;
    rbArithmeticInterval: TRadioButton;
    grpData: TGroupBox;
    rbDataStd: TRadioButton;
    rbDataInterval: TRadioButton;
    lblX: TLabel;
    editX: TEdit;
    editXA: TEdit;
    editXB: TEdit;
    grpAdvanced: TGroupBox;
    lblMit: TLabel;
    editMit: TEdit;
    lblEps: TLabel;
    editEps: TEdit;
    btnSolve: TButton;
    BitBtnClose: TBitBtn;
    Label1: TLabel;
    BitBtnInfo: TBitBtn;
    OpenDialog1: TOpenDialog;
    Button1: TButton;
    btnLoad: TButton;
    procedure FormCreate(Sender: TObject);
    procedure RadioClick(Sender: TObject);
    procedure EditFloatExit(Sender: TObject);
    procedure EditIntExit(Sender: TObject);
    procedure btnSolveClick(Sender: TObject);
    procedure BitBtnInfoClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
  private
    procedure UpdateVisibility;
    function ValidateFloat(Edit: TEdit) : Boolean;
    procedure ValidateInt(Edit: TEdit);
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;
  isIntervalArithmetic, isIntervalData: Boolean;
  x, xA, xB, dllLoc : string;
  eps: Extended;
  mit, chosenEquation: Integer;

implementation

{$R *.dfm}

{ **************************************************************************** }
{                       Procedury pomocnicze i zdarzenia                       }
{ **************************************************************************** }

procedure TFormMain.FormCreate(Sender: TObject);
begin
  rbArithmeticStd.Checked := True;
  rbDataStd.Checked := True;

  UpdateVisibility;
end;



procedure TFormMain.RadioClick(Sender: TObject);
begin
  if rbArithmeticStd.Checked then
  begin
    rbDataInterval.Enabled := False;
    rbDataStd.Checked := True;
  end
  else
  begin
    rbDataInterval.Enabled := True;
  end;

  UpdateVisibility;
end;

procedure TFormMain.UpdateVisibility;
begin
  if rbDataStd.Checked then
  begin
    lblX.Caption := 'Podaj wartość x';
    editX.Visible := True;
    editXA.Visible := False;
    editXB.Visible := False;
  end
  else
  begin
    lblX.Caption := 'Podaj wartość końców przedziału x.a x.b';
    editX.Visible := False;
    editXA.Visible := True;
    editXB.Visible := True;
  end;


end;

function TFormMain.ValidateFloat(Edit: TEdit) : Boolean;
var
  Value: Extended;
  TextVal: string;
  fs: TFormatSettings;
begin
  TextVal := Trim(Edit.Text);

  if TextVal = '' then
  begin
    ShowMessage('Pole "' + Edit.Name + '" jest puste. Wpisz liczbę zmiennoprzecinkową.');
    Edit.SetFocus;
    Exit;
  end
  else
  begin

    TextVal := StringReplace(TextVal, ',', '.', [rfReplaceAll]);
    fs := TFormatSettings.Create;
    fs.DecimalSeparator := '.';

    if TryStrToFloat(TextVal, Value, fs) then
      Result := True
    else begin
      ShowMessage('Błędny format liczby zmiennoprzecinkowej: "' + Edit.Text + '"');
      Edit.SetFocus;
      Result := False;
      Exit;
    end;
  end;
end;

procedure TFormMain.ValidateInt(Edit: TEdit);
var
  Value: Integer;
  TextVal: string;
begin
  TextVal := Trim(Edit.Text);

  if TextVal = '' then
  begin
    ShowMessage('Pole "' + Edit.Name + '" jest puste. Wpisz liczbę całkowitą.');
    Edit.SetFocus;
    //raise Exception.Create('Pole puste');
  end;

  if not TryStrToInt(TextVal, Value) then
  begin  
    ShowMessage('Błędny format liczby całkowitej: "' + Edit.Text + '"');
    Edit.SetFocus;
    //raise Exception.Create('Błędny format integer');
  end else if StrToInt(TextVal) <= 0 then
  begin
    ShowMessage('Liczba iteracji musi być większa od zera');
    Edit.SetFocus;
  end;
           
end;

procedure TFormMain.EditFloatExit(Sender: TObject);
begin
  ValidateFloat(TEdit(Sender));
end;

procedure TFormMain.EditIntExit(Sender: TObject);
begin
  ValidateInt(TEdit(Sender));
end;


procedure TFormMain.BitBtnInfoClick(Sender: TObject);
var
  frmDesc: TFormDescription;
begin
  frmDesc := TFormDescription.Create(Self);
  try
    frmDesc.ShowModal;
  finally
    frmDesc.Free;
  end;
end;


procedure TFormMain.btnLoadClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
    dllLoc := OpenDialog1.FileName;
end;
procedure TFormMain.btnSolveClick(Sender: TObject);
var
  frmResults: TfrmEANResults;
begin
  FormatSettings.DecimalSeparator := '.';

  isIntervalArithmetic := rbArithmeticInterval.Checked;
  isIntervalData := rbDataInterval.Checked;

  if not isIntervalData then
  begin
    if ValidateFloat(editX) then
    begin
      xA := StringReplace(editX.Text, ',', '.', [rfReplaceAll]);
      xB := xA;
    end
    else Exit;
  end
  else
  begin
    if (ValidateFloat(editXA) and ValidateFloat(editXB)) then
    begin
      xA := StringReplace(editXA.Text, ',', '.', [rfReplaceAll]);
      xB := StringReplace(editXB.Text, ',', '.', [rfReplaceAll]);
      if StrToFloat(xA) > StrToFloat(xB) then
      begin
        ShowMessage('Prawy koniec przedziału jest mniejszy niż lewy koniec przedziału');
        Exit;
      end;
    end
    else Exit;
  end;

  mit := StrToInt(editMit.Text);
  eps := StrToFloat(StringReplace(editEps.Text, ',', '.', [rfReplaceAll]));


  // Utworzenie i wyświetlenie okna wyników
  frmResults := TfrmEANResults.Create(Self);
  try
    frmResults.CalcResults(xA, xB, isIntervalArithmetic, isIntervalData, mit, eps, dllLoc);
    frmResults.ShowModal;
  finally
    frmResults.Free;
  end;

  // Właściwe obliczenia możesz umieścić tutaj...
end;


end.
