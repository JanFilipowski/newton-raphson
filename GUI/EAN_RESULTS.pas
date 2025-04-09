unit EAN_RESULTS;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, System.StrUtils, Vcl.ExtCtrls, Vcl.Buttons, Clipbrd,
  NewtonRaphson, IntervalArithmetic32and64;

type
  TTestModule = record
    f: function(x: Extended): Extended;
    df: function(x: Extended): Extended;
    d2f: function(x: Extended): Extended;
    iFu: function(x: interval): interval;
    iDf: function(x: interval): interval;
    iD2f: function(x: interval): interval;
  end;

  TfrmEANResults = class(TForm)
    lbl1: TLabel;
    edt1: TEdit;
    btn1: TButton;
    lbl2: TLabel;
    edt2: TEdit;
    btn2: TButton;
    lbl3: TLabel;
    edt3: TEdit;
    btn3: TButton;
    static_lbstatus: TLabel;
    lbst: TLabel;
    static_lbit: TLabel;
    lbit: TLabel;
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SignalizeError;
  private
    { Private declarations }
  public
    /// Ustawia dane do wyświetlenia w poszczególnych polach.
    /// Parametr dllLoc zawiera ścieżkę do pliku DLL z odpowiednimi funkcjami.
    procedure CalcResults(xA, xB: string;
      isIntervalArithmetic, isIntervalData: Boolean;
      mit: Integer; eps: Extended;
      dllLoc: string);
  end;

var
  frmEANResults: TfrmEANResults;
  intervalArithmetic, intervalData: Boolean;
  x, xA, xB, eps: Extended;
  mit: Integer;

implementation

{$R *.dfm}

procedure TfrmEANResults.FormCreate(Sender: TObject);
begin
  // Inicjalizacja, jeśli potrzebna
end;

procedure TfrmEANResults.btn1Click(Sender: TObject);
begin
  Clipboard.AsText := edt1.Text;
end;

procedure TfrmEANResults.btn2Click(Sender: TObject);
begin
  Clipboard.AsText := edt2.Text;
end;

procedure TfrmEANResults.btn3Click(Sender: TObject);
begin
  Clipboard.AsText := edt3.Text;
end;

procedure TfrmEANResults.SignalizeError;
begin
  edt1.Text := '(błąd obliczeń)';
  edt1.Enabled := False;
  btn1.Enabled := False;
  edt2.Text := '(błąd obliczeń)';
  edt2.Enabled := False;
  btn2.Enabled := False;
  edt3.Text := '(błąd obliczeń)';
  edt3.Enabled := False;
  btn3.Enabled := False;
end;

procedure TfrmEANResults.CalcResults(xA, xB: string;
  isIntervalArithmetic, isIntervalData: Boolean;
  mit: Integer; eps: Extended;
  dllLoc: string);
var
  TestMod: TTestModule;
  LibHandle: THandle;
  // Wersja zmiennoprzecinkowa
  initialX, x_fp, root_fp: Extended;
  fatx_fp: Extended;
  it_fp, st_fp: Integer;
  // Wersja przedziałowa
  X: interval;
  x_int, root_int, fatx_int: interval;
  it_int, st_int: Integer;
  leftStr, rightStr: string;
begin
  // Dynamiczne ładowanie biblioteki DLL
  LibHandle := LoadLibrary(PChar(dllLoc));
  if LibHandle = 0 then
  begin
    ShowMessage('Nie można załadować biblioteki DLL: ' + dllLoc);
    Exit;
  end;

  // Pobranie adresów funkcji
  @TestMod.f    := GetProcAddress(LibHandle, 'f');
  @TestMod.df   := GetProcAddress(LibHandle, 'df');
  @TestMod.d2f  := GetProcAddress(LibHandle, 'd2f');
  @TestMod.iFu  := GetProcAddress(LibHandle, 'iFu');
  @TestMod.iDf  := GetProcAddress(LibHandle, 'iDf');
  @TestMod.iD2f := GetProcAddress(LibHandle, 'iD2f');

  if (not Assigned(TestMod.f)) or (not Assigned(TestMod.df)) or
     (not Assigned(TestMod.d2f)) or (not Assigned(TestMod.iFu)) or
     (not Assigned(TestMod.iDf)) or (not Assigned(TestMod.iD2f)) then
  begin
    ShowMessage('Biblioteka DLL nie zawiera wymaganych funkcji.');
    FreeLibrary(LibHandle);
    Exit;
  end;

  // CZĘŚĆ OBLICZEŃ

  if not isIntervalArithmetic then
  begin
    initialX := StrToFloat(xA);
    Writeln('===================================================');
    Writeln('Test dla x początkowego = ', initialX:0:16);
    Writeln('*** WERSJA ZMIENNOPRZECINKOWA ***');
    x_fp := initialX;
    root_fp := tNewtonRaphson(x_fp, TestMod.f, TestMod.df, TestMod.d2f,
                               mit, eps, fatx_fp, it_fp, st_fp);
    Writeln('Wynik końcowy: x = ', root_fp:0:16);
    Writeln(' f(x) = ', fatx_fp:0:16);
    Writeln(' Status = ', st_fp, ', iteracje = ', it_fp);

    lbst.Caption := IntToStr(st_fp);
    lbit.Caption := IntToStr(it_fp);
    if ((st_fp <> 0) and (st_fp <> 3)) then
    begin
      SignalizeError();
      FreeLibrary(LibHandle);
      Exit;
    end;

    edt1.Text := FormatFloat('0.0000000000000000E+0000', root_fp);
    edt2.Text := FormatFloat('0.0000000000000000E+0000', fatx_fp);
    edt3.Text := '(arytmetyka zmiennoprzecinkowa)';
    edt3.Enabled := False;
    btn3.Enabled := False;
  end
  else  // WERSJA PRZEDZIAŁOWA
  begin
    if isIntervalData then
    begin
      X.a := left_read(xA);
      X.b := right_read(xB);
    end
    else
      X := int_read(xA);

    Writeln('===================================================');
    Writeln('*** WERSJA PRZEDZIAŁOWA ***');
    root_int := tiNewtonRaphson(X, TestMod.iFu, TestMod.iDf, TestMod.iD2f,
                                mit, eps, fatx_int, it_int, st_int);

    lbst.Caption := IntToStr(st_int);
    lbit.Caption := IntToStr(it_int);
    if ((st_int <> 0) and (st_int <> 3)) then
    begin
      SignalizeError();
      FreeLibrary(LibHandle);
      Exit;
    end;

    iends_to_strings(root_int, leftStr, rightStr);
    Writeln('Wynik końcowy: x = [', leftStr, ', ', rightStr, ']');
    edt1.Text := '[' + leftStr + ', ' + rightStr + ']';

    iends_to_strings(fatx_int, leftStr, rightStr);
    Writeln(' f(x) = [', leftStr, ', ', rightStr, ']');
    edt2.Text := '[' + leftStr + ', ' + rightStr + ']';
    edt3.Text := FormatFloat('0.0000000000000000E+0000', int_width(root_int));
    edt3.Enabled := True;
    btn3.Enabled := True;

    Writeln(' Status = ', st_int, ', iteracje = ', it_int);
    Writeln('===================================================');
  end;

  // Zwolnienie biblioteki DLL po zakończeniu obliczeń
  FreeLibrary(LibHandle);
end;

end.

