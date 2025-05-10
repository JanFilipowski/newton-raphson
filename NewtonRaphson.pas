unit NewtonRaphson;

interface

uses
  SysUtils, Math, IntervalArithmetic32and64;

type
  fx  = function(x: Extended): Extended;
  ifx = function(x: interval): interval;

function tNewtonRaphson(var x: Extended;
  f, df, d2f: fx;
  mit: Integer;
  eps: Extended;
  var fatx: Extended;
  var it, st: Integer): Extended;

function tiNewtonRaphson(var x: interval; // początkowe przybliżenie pierwiastka
  f, df, d2f: ifx; // funkcja, pochodna i druga pochodna jako typy funkcji przedziałowych
  mit: Integer; // maksymalna liczba iteracji
  eps: Extended; // dokładność
  var fatx: interval; // zmienna pomocnicza - aktualna wartość funkcji
  var it, st: Integer): interval; // zmienne pomocnicze - liczba wykonanych iteracji i status

implementation

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
        w := Abs(xh);
        p := sqrt(p);
        x1 := x - (dfatx - p) / d2fatx;
        x2 := x - (dfatx + p) / d2fatx;
        Writeln(' Obliczone p      = ', p:0:16);
        Writeln(' Możliwe x1       = ', x1:0:16);
        Writeln(' Możliwe x2       = ', x2:0:16);

        if Abs(x2 - xh) > Abs(x1 - xh) then
          x := x1
        else
          x := x2;

        v := Abs(x);
        if v < w then
          v := w;
        Writeln(' Zaktualizowane x = ', x:0:16);
        Writeln(' v = max(|x|,|poprzednie x|) = ', v:0:16);

        if v = 0 then
          st := 0
        else if Abs(x - xh) / v <= eps then
          st := 0;

        Writeln(' Warunek zbieżności: abs(x - xh)/v = ',
                Abs(x - xh)/v:0:16, ' (eps = ', eps:0:16, ')');
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
  dfatx, d2fatx, p, xh, x1, x2: interval;      // zmienne pomocnicze - wartości funkcji dla aktualnego przybliżenia
  v, w: interval;                              // zmienne pomocnicze
  st_sqrt: Integer;                            // zmienna pomocnicza - status operacji pierwiastkowania
  leftStr, rightStr: string;                   // zmienne pomocnicze - potrzebne do debugowania
  err1, err2, curr_error, prev_error: Extended; // zmienne pomocnicze - obliczanie błędu zbieżności, porównywanie błędu z poprzednim błędem
begin
  if mit < 1 then
    st := 1
  else
  begin
    st := 3;
    it := 0;
    prev_error := MaxDouble;  // inicjalizacja dużą wartością
    repeat
      it := it + 1;
      fatx   := f(x);
      dfatx  := df(x);
      d2fatx := d2f(x);

      iends_to_strings(x, leftStr, rightStr);
      Writeln('------------------------------');
      Writeln('ITERACJA ', it, ' (PRZEDZIAŁOWA)');
      Writeln(' Aktualne x       = [', leftStr, ', ', rightStr, ']');

      iends_to_strings(fatx, leftStr, rightStr);
      Writeln(' f(x)             = [', leftStr, ', ', rightStr, ']');
      iends_to_strings(dfatx, leftStr, rightStr);
      Writeln(' f''(x)           = [', leftStr, ', ', rightStr, ']');
      iends_to_strings(d2fatx, leftStr, rightStr);
      Writeln(' f''''(x)         = [', leftStr, ', ', rightStr, ']');

      // Halley: p = df² - 2·f·d2f
      p := dfatx * dfatx - 2 * fatx * d2fatx;
      if p.b < 0 then
        st := 4
      else if (d2fatx.a <= 0) and (d2fatx.b >= 0) then
        st := 2
      else
      begin
        xh := x;

        // przygotowanie do wyboru kroku
        w := iabs(xh);

        // pierwiastek przedziałowy
        p := isqrt(p, st_sqrt);
        if st_sqrt = 0 then
        begin
          x1 := x - (dfatx - p) / d2fatx;
          x2 := x - (dfatx + p) / d2fatx;

          iends_to_strings(p, leftStr, rightStr);
          Writeln(' Obliczone p      = [', leftStr, ', ', rightStr, ']');
          iends_to_strings(x1, leftStr, rightStr);
          Writeln(' Możliwe x1       = [', leftStr, ', ', rightStr, ']');
          iends_to_strings(x2, leftStr, rightStr);
          Writeln(' Możliwe x2       = [', leftStr, ', ', rightStr, ']');

          // wybór kroku: porównanie szerokości przedziałów
          if int_width(x2 - xh) > int_width(x1 - xh) then
            x := x1
          else
            x := x2;

          v := iabs(x);
          if v.b < w.a then
            v := w;

          iends_to_strings(x, leftStr, rightStr);
          Writeln(' Zaktualizowane x = [', leftStr, ', ', rightStr, ']');

          // Obliczenie aktualnego błędu zbieżności
          err1 := Abs(x.b - xh.b) / Max(Abs(x.b), Abs(xh.b));
          err2 := Abs(x.a - xh.a) / Max(Abs(x.a), Abs(xh.a));
          curr_error := Max(err1, err2); // maksymalny błąd krańców

          if it > 1 then
          begin
            // wykrycie wzrostu błędu (niższa dokładność maszynowa)
            if curr_error > prev_error then
            begin
              st := 0;
              x := xh; // przywracamy poprzednią wartość
              Writeln('Błąd zbieżności wzrósł z ', prev_error:0:16,
                      ' do ', curr_error:0:16,
                      '. Zatrzymanie iteracji i przywrócenie poprzedniej wartości.');
              Break;
            end;
          end;
          prev_error := curr_error;

          if curr_error <= eps then
          begin
            st := 0;
            Writeln('Zbieżność osiągnięta: Max(err1, err2) = ',
                    curr_error:0:16, ' <= ', eps:0:16);
          end
          else
            Writeln('Warunek zbieżności = ', curr_error:0:16,
                    ' (eps = ', eps:0:16, ')');
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
