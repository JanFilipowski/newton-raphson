library TestPoly;

uses
  IntervalArithmetic32and64,
  SysUtils;

type
  interval = IntervalArithmetic32and64.interval;

function fabs(const x: interval): interval;
begin
  if x.a >= 0 then begin
    Result.a := x.a;
    Result.b := x.b;
  end else if x.b <= 0 then begin
    Result.a := -x.b;
    Result.b := -x.a;
  end else begin
    Result.a := 0;
    if -x.a > x.b then
      Result.b := -x.a
    else
      Result.b := x.b;
  end;
end;

// Funkcje zmiennoprzecinkowe
function f(x: Extended): Extended; stdcall;
begin
  Result := Sqr(Sqr(x)) - 5 * Sqr(x) + 4;
end;

function df(x: Extended): Extended; stdcall;
begin
  Result := 4 * x * Sqr(x) - 10 * x;
end;

function d2f(x: Extended): Extended; stdcall;
begin
  Result := 12 * Sqr(x) - 10;
end;

// Funkcje przedziałowe
function iFu(x: interval): interval; stdcall;
var
  stTemp: Integer;
begin
  Result := iax(fabs(x), 4, stTemp) - 5 * iax(fabs(x), 2, stTemp) + 4;
  if stTemp = 3 then
    Result := fabs(x)*fabs(x)*fabs(x)*fabs(x) - 5 * fabs(x)*fabs(x) + 4;
end;

function iDf(x: interval): interval; stdcall;
begin
  Result := 4 * (x * x * x) - 10 * x;
end;

function iD2f(x: interval): interval; stdcall;
var
  stTemp: Integer;
begin
  Result := 12 * iax(fabs(x), 2, stTemp) - 10;
  if stTemp = 3 then
    Result := 12 * fabs(x)*fabs(x) - 10;
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
