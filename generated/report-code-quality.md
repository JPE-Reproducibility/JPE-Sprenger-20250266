## Code Quality

### R

[CRITICAL] Hardcoded absolute path detected — the package will not run on another machine. (mainR.R, line 19)
  → dir <- "/Users/jasonsomerville/Desktop/CRP CCP BP/replication_files"

### Stata

[CRITICAL] Hardcoded absolute path detected — the package will not run on another machine. (mainS.do, line 14)
  → global dir "C:/Users/$user/`folder'"

[CRITICAL] Hardcoded absolute path detected — the package will not run on another machine. (mainS.do, line 17)
  → global dir "/Users/$user/`folder'"

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (clean_data.do, line 204)
  → keep if part == 2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (statsInText.do, line 53)
  → drop if missing(pattern)

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (statsInText.do, line 111)
  → drop if missing(pattern)

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (statsInText.do, line 124)
  → keep if listed

### Unknown

[CRITICAL] Hardcoded absolute path detected — the package will not run on another machine. (makeFigure1.m, line 7)
  → dir = "/Users/jasonsomerville/Desktop/CRP CCP BP/replication_files"; %Set directory

[CRITICAL] Hardcoded absolute path detected — the package will not run on another machine. (makeFigure9.m, line 7)
  → dir = "/Users/jasonsomerville/Desktop/CRP CCP BP/replication_files"; %Set directory

[CRITICAL] Hardcoded absolute path detected — the package will not run on another machine. (makeFigureE1.m, line 7)
  → dir = "/Users/jasonsomerville/Desktop/CRP CCP BP/replication_files"; %Set directory

[CRITICAL] Hardcoded absolute path detected — the package will not run on another machine. (structuralEstimates.m, line 7)
  → dir = "/Users/jasonsomerville/Desktop/CRP CCP BP/replication_files"; %Set directory

