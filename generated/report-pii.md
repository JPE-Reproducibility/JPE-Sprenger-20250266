## Potential Personal Identifiable Information (PII)

⚠️ We found the following instances of potentially personally identifying information. This may be completely legitimate but might be worth checking. *As a reminder, privacy legislation in many countries (e.g. GDPR in EU) prohibits the dissemination of personal identifiable information without prior (and documented) consent of individuals.* If indeed you want to publish such information with your replication package, you should probably have obtained IRB approval for this - please check!

**Summary:**
- Data files with PII indicators: 3
- Variables flagged in data: 5
- Code files with PII references: 17
- PII references in code: 391

### Summary of Flagged Files

| File Type | File | Variables/References | PII Categories |
|-----------|------|----------------------|----------------|
| Data | `README.txt` | 1 | lat |
| Data | `demographics-anonymized.csv` | 2 | sex, country |
| Data | `qualtrics-raw.csv` | 2 | son, block, loc |
| Code | `clean_data.do` | 55 | block, loc, son, lat, lon, name, second, school, gender, sex, country |
| Code | `functions.R` | 11 | lat |
| Code | `mainR.R` | 7 | lat, son, name, minute, second |
| Code | `mainS.do` | 5 | second, loc, name, lon |
| Code | `makeAppendixFigures.do` | 20 | loc, lat |
| Code | `makeAppendixTables.do` | 102 | lat, sex, degree, country, loc, lname, name, minute, lon |
| Code | `makeFigure1.m` | 17 | son, lat, loc, location |
| Code | `makeFigure9.m` | 10 | son, name, lat |
| Code | `makeFigureD1.R` | 1 | lat |
| Code | `makeFigureE1.m` | 10 | son, lat |
| Code | `makeFigures3-7.do` | 43 | loc, lat, lon, name |
| Code | `makeTable2.do` | 9 | lat, loc, name |
| Code | `makeTableD1.R` | 3 | lat, name |
| Code | `makeTableD2.R` | 3 | lat, name |
| Code | `reducedForm.R` | 27 | lon, lat, lname, name |
| Code | `statsInText.do` | 13 | son, lon, loc, lat |
| Code | `structuralEstimates.m` | 55 | son, name, lat, block, loc, location, degree |

*See [Appendix](report-pii-appendix.md) for detailed listing of all flagged instances.*
