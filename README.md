# Program do znajdowania rozwiązania równania nieliniowego metodą Newtona-Raphsona

## Opis
Ten projekt jest dedykowany do znajdowania przybliżonego pierwiastka równania nieliniowego 
$
f(x) = 0.
$
Algorytm realizuje iteracyjną metodę Newtona-Raphsona drugiego rzędu, który wykorzystuje zarówno pierwszą, jak i drugą pochodną funkcji do wyznaczenia kolejnych przybliżeń pierwiastka.

## Algorytm
Pierwiastek równania wyznacza się przy pomocy następującej iteracji:
$
x_{i+1} = x_i - \frac{f'(x_i) \pm \sqrt{[f''(x_i)]^2 - 2\,f'(x_i)\,f''(x_i)}}{f''(x_i)}, \quad i = 0,1,\ldots
$
gdzie $x_0$ jest wartością początkową podaną przez użytkownika. Proces iteracyjny zatrzymuje się, gdy:
$
\frac{\lvert x_{i+1} - x_i\rvert}{\max(\lvert x_{i+1}\rvert, \lvert x_{i}\rvert)} < \varepsilon, \quad (x_{i+1} \neq 0 \text{ lub } x_i \neq 0)
$
lub gdy przy kolejnych iteracjach nie zmienia się już wartość $x$.

## Status Algorytmu
Poprawność wykonania algorytmu jest sygnalizowana przez zmienną `st` (status), która przyjmuje jedną z następujących wartości:
$
\texttt{st} = 
\begin{cases}
1, & \text{jeżeli } i = 1,\\[1mm]
2, & \text{gdy podczas obliczeń } f'(x) = 0 \text{ dla pewnej wartości } x,\\[1mm]
3, & \text{jeżeli w } n_I \text{ krokach iteracyjnych nie osiągnięto podanej dokładności},\\[1mm]
4, & \text{gdy } f''(x) - 2\,f'(x)\,f''(x) < 0 \text{ dla pewnej wartości } x,\\[1mm]
5, & \text{w przeciwnym przypadku}.
\end{cases}
$
**Uwaga:** Jeśli $\texttt{st} = 1, 2 \text{ lub } 4$, wartość funkcji nie jest obliczana, a w przypadku $\texttt{st} = 3$ ostatnie przybliżenie pierwiastka jest zwracane.

## Kluczowe Funkcjonalności
- **Metoda Newtona-Raphsona drugiego rzędu**  
  Wykorzystanie zarówno pierwszej, jak i drugiej pochodnej funkcji w celu szybszej i bardziej dokładnej konwergencji.
- **Użycie arytmetyki zmiennopozycyjnej lub przedziałowej**  
  Użytkownik ma możliwość wyboru użycia arytmetyki zmiennopozycyjnej, jak i przedziałowej (wykorzystując bibliotekę IntervalArithmetic32and64 Copyright © 1998-2025 by Andrzej Marciniak)
- **Dynamiczne ładowanie bibliotek DLL**  
  Funkcje definiowane są w zewnętrznych bibliotekach DLL (np. TestPoly.dll, TestTrig.dll). 
  Aplikacja główna ładuje wybraną bibliotekę w trakcie działania, co zwiększa elastyczność rozwiązania.

<!--
## Instalacja i Uruchomienie
1. **Klonowanie repozytorium:**  
   Skopiuj repozytorium z GitHuba:
   https://github.com/JanFilipowski/newton-raphson

2. **Budowanie DLL:**  
   - Otwórz projekt DLL (np. TestPoly i TestTrig) w Delphi.  
   - Upewnij się, że wszystkie jednostki (w tym IntervalArithmetic32and64) są dostępne i poprawnie skonfigurowane.  
   - Skonfiguruj i zbuduj projekty, aby wygenerować odpowiednie pliki .dll.

3. **Budowanie aplikacji głównej:**  
   - Otwórz projekt aplikacji głównej (EAN_MAIN) w Delphi.  
   - Upewnij się, że ścieżki do wygenerowanych DLL są poprawnie ustawione.  
   - Skonfiguruj projekt i zbuduj aplikację.

4. **Uruchomienie:**  
   Po uruchomieniu aplikacji głównej wybierz odpowiednią bibliotekę DLL poprzez okno dialogowe (TOpenDialog).  
   Następnie wprowadź wymagane parametry (np. $x_0$, dokładność $\varepsilon$, liczbę iteracji) i uruchom algorytm.

-->
## Kontakt i Wsparcie
- URL projektu: https://github.com/yourusername/program-do-znajdowania-rozwiazania-rownania-newtona-raphsona
- W razie pytań lub problemów, zgłoś je poprzez Issues na GitHubie.

## Licencja
Ten projekt jest udostępniony na licencji GNU GPL. Szczegóły zawarte są w pliku LICENSE.
