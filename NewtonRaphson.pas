unit NewtonRaphson;

interface

uses
  SysUtils, IntervalArithmetic32and64;

type
  fx = function(x: Extended): Extended;
  ifx = function(x: interval): interval;

function tNewtonRaphson(var x: Extended;
  f, df, d2f: fx;
  mit: Integer;
  eps: Extended;
  var fatx: Extended;
  var it, st: Integer): Extended;

function tiNewtonRaphson(var x: interval;
  f, df, d2f: ifx;
  mit: Integer;
  eps: Extended;
  var fatx: interval;
  var it, st: Integer): interval;

implementation

// Funkcja pomocnicza do obliczania wartości bezwzględnej przedziału
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

// =====================================================
// Funkcja tNewtonRaphson – wersja zmiennoprzecinkowa z debugowaniem
// =====================================================
function tNewtonRaphson(var x: Extended;
                        f, df, d2f: fx;
                        mit: Integer;
                        eps: Extended;
                        var fatx: Extended;
                        var it, st: Integer): Extended;
var
  dfatx, d2fatx, p, v, w, xh, x1, x2: Extended;
begin
  if mit < 1 then
    st := 1
  else
  begin
    st := 3;
    it := 0;
    repeat
      it := it + 1;
      fatx := f(x);
      dfatx := df(x);
      d2fatx := d2f(x);
      Writeln('------------------------------');
      Writeln('ITERACJA ', it);
      Writeln(' Aktualne x       = ', x:0:16);
      Writeln(' f(x)             = ', fatx:0:16);
      Writeln(' f''(x)           = ', dfatx:0:16);
      Writeln(' f''''(x)         = ', d2fatx:0:16);

      p := dfatx * dfatx - 2 * fatx * d2fatx;
      if p < 0 then
        st := 4
      else if d2fatx = 0 then
        st := 2
      else
      begin
        xh := x;
        w := abs(xh);
        p := sqrt(p);
        x1 := x - (dfatx - p) / d2fatx;
        x2 := x - (dfatx + p) / d2fatx;
        Writeln(' Obliczone p      = ', p:0:16);
        Writeln(' Możliwe x1      = ', x1:0:16);
        Writeln(' Możliwe x2      = ', x2:0:16);

        if abs(x2 - xh) > abs(x1 - xh) then
          x := x1
        else
          x := x2;

        v := abs(x);
        if v < w then
          v := w;
        Writeln(' Zaktualizowane x = ', x:0:16);
        Writeln(' v = max(|x|,|poprzednie x|) = ', v:0:16);

        if v = 0 then
          st := 0
        else if abs(x - xh) / v <= eps then
          st := 0;

        Writeln(' Warunek zbieżności: abs(x - xh)/v = ', abs(x - xh)/v:0:16, ' (eps = ', eps:0:16, ')');
      end;
    until (it = mit) or (st <> 3);
  end;
  if (st = 0) or (st = 3) then
  begin
    tNewtonRaphson := x;
    fatx := f(x);
  end;
end;

// =====================================================
// Funkcja tiNewtonRaphson – wersja przedziałowa z debugowaniem
// =====================================================
function tiNewtonRaphson(var x: interval;
                         f, df, d2f: ifx;
                         mit: Integer;
                         eps: Extended;
                         var fatx: interval;
                         var it, st: Integer): interval;
var
  dfatx, d2fatx, p, v, w, xh, x1, x2: interval;
  st_sqrt: Integer;
  leftStr, rightStr: string;
  prev_error, curr_error: Extended;  // przechowujemy błąd z poprzedniej iteracji
  last_x: interval;                  // wartość x z poprzedniej iteracji
  firstIter: Boolean;
begin
  if mit < 1 then
    st := 1
  else
  begin
    st := 3;
    it := 0;
    firstIter := True;
    repeat
      it := it + 1;
      fatx := f(x);
      dfatx := df(x);
      d2fatx := d2f(x);

      iends_to_strings(x, leftStr, rightStr);
      Writeln('------------------------------');
      Writeln('ITERACJA ', it, ' (PRZEDZIAŁOWA)');
      Writeln(' Aktualne x       = [', leftStr, ', ', rightStr, ']');

      iends_to_strings(fatx, leftStr, rightStr);
      Writeln(' f(x)             = [', fatx.a, ', ', fatx.b, ']');
      iends_to_strings(dfatx, leftStr, rightStr);
      Writeln(' f''(x)             = [', leftStr, ', ', rightStr, ']');
      iends_to_strings(d2fatx, leftStr, rightStr);
      Writeln(' f''''(x)             = [', leftStr, ', ', rightStr, ']');

      p := dfatx * dfatx - 2 * fatx * d2fatx;
      if p.b < 0 then
        st := 4
      else if (d2fatx.a <= 0) and (d2fatx.b >= 0) then
        st := 2
      else
      begin
        xh := x;
        w := fabs(xh);
        p := isqrt(p, st_sqrt);
        if st_sqrt = 0 then
        begin
          x1 := x - (dfatx - p) / d2fatx;
          x2 := x - (dfatx + p) / d2fatx;
          iends_to_strings(p, leftStr, rightStr);
          Writeln(' Obliczone p      = [', leftStr, ', ', rightStr, ']');
          iends_to_strings(x1, leftStr, rightStr);
          Writeln(' Możliwe x1      = [', leftStr, ', ', rightStr, ']');
          iends_to_strings(x2, leftStr, rightStr);
          Writeln(' Możliwe x2      = [', leftStr, ', ', rightStr, ']');

          if fabs(x2 - xh).b > fabs(x1 - xh).b then
            x := x1
          else
            x := x2;

          v := fabs(x);
          if v.b < w.a then
            v := w;
          iends_to_strings(x, leftStr, rightStr);
          Writeln(' Zaktualizowane x = [', leftStr, ', ', rightStr, ']');

          // Obliczenie aktualnego błędu zbieżności
          curr_error := ((fabs(x - xh)) / v).b;
          if not firstIter then
          begin
            if curr_error > prev_error then
            begin
              st := 0;
              x := last_x; // przywracamy poprzednią wartość
              Writeln('Błąd zbieżności wzrósł z ', prev_error:0:16, ' do ', curr_error:0:16,
                      '. Zatrzymanie iteracji i przywrócenie poprzedniej wartości.');
              Break;  // przerywamy pętlę
            end;
          end
          else
            firstIter := False;

          // Zapisujemy bieżący stan jako ostatnio zaakceptowany
          prev_error := curr_error;
          last_x := x;

          if curr_error <= eps then
          begin
            st := 0;
            Writeln('Zbieżność osiągnięta: ((fabs(x - xh))/v).b = ', curr_error:0:16, ' <= ', eps:0:16);
          end
          else
            Writeln('Warunek zbieżności: ((fabs(x - xh))/v).b = ', curr_error:0:16, ' (eps = ', eps:0:16, ')');
        end
        else
          st := 4;
      end;
    until (it = mit) or (st <> 3);
  end;
  if (st = 0) or (st = 3) then
  begin
    tiNewtonRaphson := x;
    fatx := f(x);
  end;
end;


end.
