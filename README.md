# Program do znajdowania rozwiązania równania nieliniowego metodą Newtona-Raphsona

## Opis
<<<<<<< HEAD
Ten projekt jest dedykowany do znajdowania przybliżonego pierwiastka równania nieliniowego $f(x) = 0$. Algorytm realizuje iteracyjną metodę Newtona-Raphsona drugiego rzędu, który wykorzystuje zarówno pierwszą, jak i drugą pochodną funkcji do wyznaczenia kolejnych przybliżeń pierwiastka.

## Algorytm
Pierwiastek równania wyznacza się przy pomocy następującej iteracji:

$$x_{i+1} = x_i - \frac{f'(x_i) \pm \sqrt{[f''(x_i)]^2 - 2\,f'(x_i)\,f''(x_i)}}{f''(x_i)}, \quad i = 0,1,\ldots$$

Gdzie $x_0$ jest wartością początkową podaną przez użytkownika. Proces iteracyjny zatrzymuje się, gdy:

$$\frac{\lvert x_{i+1} - x_i\rvert}{\max(\lvert x_{i+1}\rvert, \lvert x_{i}\rvert)} < \varepsilon, \quad (x_{i+1} \neq 0 \text{ lub } x_i \neq 0)$$

lub gdy przy kolejnych iteracjach nie zmienia się już wartość $x$.
=======
Ten projekt jest dedykowany do znajdowania przybliżonego pierwiastka równania nieliniowego $f(x) = 0$,
Algorytm realizuje iteracyjną metodę Newtona-Raphsona drugiego rzędu, który wykorzystuje zarówno pierwszą, jak i drugą pochodną funkcji do wyznaczenia kolejnych przybliżeń pierwiastka.

## Algorytm
Pierwiastek równania wyznacza się przy pomocy następującej iteracji:

$x_{i+1} = x_i - \frac{f'(x_i) \pm \sqrt{[f''(x_i)]^2 - 2\,f'(x_i)\,f''(x_i)}}{f''(x_i)}, \quad i = 0,1,\ldots$


gdzie $x_0$ jest wartością początkową podaną przez użytkownika. Proces iteracyjny zatrzymuje się, gdy:

$\frac{\lvert x_{i+1} - x_i\rvert}{\max(\lvert x_{i+1}\rvert, \lvert x_{i}\rvert)} < \varepsilon, \quad (x_{i+1} \neq 0 \text{ lub } x_i \neq 0)$


lub gdy przy kolejnych iteracjach nie zmienia się już wartość $x$.

## Status Algorytmu
Poprawność wykonania algorytmu jest sygnalizowana przez zmienną `st` (status), która przyjmuje jedną z następujących wartości:

| Wartość `st` | Warunek                                                                 |
|--------------|-------------------------------------------------------------------------|
| 1            | jeżeli `miti = 1`                                                       |
| 2            | gdy podczas obliczeń `f'(x) = 0` dla pewnej wartości `x`               |
| 3            | jeżeli w `n_I` krokach iteracyjnych nie osiągnięto podanej dokładności |
| 4            | gdy `f''(x) - 2 f'(x) f''(x) < 0` dla pewnej wartości `x`              |
| 0            | w przeciwnym przypadku                                                  |

**Uwaga:** Jeśli $\texttt{st} = 1, 2 \text{ lub } 4$, wartość funkcji nie jest obliczana, a w przypadku $\texttt{st} = 3$ ostatnie przybliżenie pierwiastka jest zwracane.
>>>>>>> f28a033e7534338577528b2e12e6cb39c6745e8b

## Kluczowe Funkcjonalności
- **Metoda Newtona-Raphsona drugiego rzędu**  
  Wykorzystanie zarówno pierwszej, jak i drugiej pochodnej funkcji w celu szybszej i dokładniejszej zbieżności.
- **Użycie arytmetyki zmiennopozycyjnej lub przedziałowej**  
  Użytkownik ma możliwość wyboru użycia arytmetyki zmiennopozycyjnej, jak i przedziałowej (wykorzystując bibliotekę `IntervalArithmetic32and64` © 1998-2025 by Andrzej Marciniak).
- **Graficzny Interfejs Użytkownika z dynamicznym ładowaniem bibliotek**  
  Funkcje definiowane są w zewnętrznych bibliotekach DLL (np. `TestPoly.dll`, `TestTrig.dll`). Aplikacja ładuje wybraną bibliotekę w trakcie działania, co zwiększa elastyczność rozwiązania.

## Struktura projektu
- **NewtonRaphson.pas** – główny moduł zawierający implementację algorytmu Newtona-Raphsona oraz definicje funkcji numerycznych.
- **IntervalArithmetic32and64** – biblioteka Andrzeja Marciniaka, obsługująca arytmetykę przedziałową.
- **GUI/** – katalog zawierający projekt Delphi RAD Studio 12 z graficznym interfejsem użytkownika. Do poprawnego działania projektu wymagane jest umieszczenie modułów `NewtonRaphson.pas` i `IntervalArithmetic32and64` w katalogu projektu. Zalecany jest kompilator **Windows 32-bit**, aby zachować obsługę 80-bitowego typu Extended.
- **tests/** – katalog zawierający dynamicznie ładowane biblioteki przykładowych funkcje: wielomianowe i trygonometryczne przeznaczone do testowania niniejszego algorytmu (Pliki DLL zostały skomilowane orzy użyciu kompilatora Windows 32-bit). W katalogu znajduje się również kod źródłowy tych bibliotek.

## Implementacja algorytmu
Całość implementacji funkcji znajduje się w pliku `NewtonRaphson.pas`.

### Dostępne funkcje:

```pascal
function tNewtonRaphson(var x: Extended;
  f, df, d2f: fx;
  mit: Integer;
  eps: Extended;
  var fatx: Extended;
  var it, st: Integer): Extended;
```

- `x` – początkowe przybliżenie pierwiastka.
- `f, df, d2f` – funkcje przyjmujące liczby rzeczywiste i zwracające liczby rzeczywiste (kolejno: funkcja, pierwsza pochodna, druga pochodna).
- `mit` – maksymalna liczba iteracji.
- `eps` – żądana dokładność wyznaczania miejsca zerowego.

```pascal
function tiNewtonRaphson(var x: interval;
  f, df, d2f: ifx;
  mit: Integer;
  eps: Extended;
  var fatx: interval;
  var it, st: Integer): interval;
```

- `x` – początkowe przybliżenie pierwiastka.
- `f, df, d2f` – funkcje przyjmujące przedziały i zwracające przedziały (kolejno: funkcja, pierwsza pochodna, druga pochodna).
- `mit` – maksymalna liczba iteracji.
- `eps` – żądana dokładność wyznaczania miejsca zerowego.


### Dane wyjściowe
- wynik –Przybliżenie pierwiastka.
- `it` – liczba wykonanych iteracji.
- `st` – Status wykonania algorytmu.

### Status Algorytmu
Poprawność wykonania algorytmu jest sygnalizowana przez zmienną `st` (status):

| Wartość `st` | Warunek                                                                 |
|--------------|-------------------------------------------------------------------------|
| 1            | jeżeli `mit = 1`                                                        |
| 2            | gdy podczas obliczeń `f'(x) = 0` dla pewnej wartości `x`                |
| 3            | jeżeli w `mit` krokach iteracyjnych nie osiągnięto podanej dokładności  |
| 4            | gdy `f''(x) - 2 f'(x) f''(x) < 0` dla pewnej wartości `x`               |
| 0            | w przeciwnym przypadku                                                  |

**Uwaga:** Jeśli `st = 1, 2 lub 4`, wartość funkcji nie jest obliczana, a w przypadku `st = 3` zwracane jest ostatnie przybliżenie pierwiastka.

## Graficzny Interfejs Użytkownika
Graficzny interfejs umożliwia pełną obsługę funkcji zawartych w module `NewtonRaphson.pas`. Wyniki obliczeń zapisywane są w pliku `calculations.txt`.

### Tworzenie biblioteki DLL
Funkcje użytkownika powinny być zaimplementowane w osobnych bibliotekach DLL, zgodnych z konwencją używaną w przykładach (`TestPoly.dll`, `TestTrig.dll`).

## Kontakt i Wsparcie
- URL projektu: [https://github.com/yourusername/program-do-znajdowania-rozwiazania-rownania-newtona-raphsona](https://github.com/yourusername/program-do-znajdowania-rozwiazania-rownania-newtona-raphsona)
- W razie pytań lub problemów zgłaszaj je poprzez Issues na GitHubie.

## Licencja
Projekt udostępniony na licencji GNU GPL. Szczegóły zawarte są w pliku `LICENSE`.

