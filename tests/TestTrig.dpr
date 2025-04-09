library TestTrigDLL;

uses
  Math,
  IntervalArithmetic32and64,
  SysUtils;

type
  interval = IntervalArithmetic32and64.interval;

// Funkcje zmiennoprzecinkowe
function f(x: Extended): Extended; stdcall;
begin
  Result := Sin(x)*Sin(x) + 0.5 * Sin(x) - 0.5;
end;

function df(x: Extended): Extended; stdcall;
begin
  Result := Sin(2*x) + 0.5 * Cos(x);
end;

function d2f(x: Extended): Extended; stdcall;
begin
  Result := 2 * Cos(2*x) - 0.5 * Sin(x);
end;

// Funkcje przedziałowe
function iFu(x: interval): interval; stdcall;
var
  funct_result: Integer;
begin
  Result := isin(x, funct_result)*isin(x, funct_result) + 0.5 * isin(x, funct_result) - 0.5;
end;

function iDf(x: interval): interval; stdcall;
var
  funct_result: Integer;
begin
  Result := isin(2*x, funct_result) + 0.5 * icos(x, funct_result);
end;

function iD2f(x: interval): interval; stdcall;
var
  funct_result: Integer;
begin
  Result := 2 * icos(2*x, funct_result) - 0.5 * isin(x, funct_result);
end;

// Eksportowanie funkcji
exports
  f,
  df,
  d2f,
  iFu,
  iDf,
  iD2f;

begin
end.