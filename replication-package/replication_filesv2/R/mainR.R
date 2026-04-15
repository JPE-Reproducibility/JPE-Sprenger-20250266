##### McGranaghan et al. (2026)
##### main.R
##### ------------------------
##### This file conducts the maximum likelihood estimation
##### for preference decomposition and then constructs 
##### Table D.1, Table D.2, and Figure D.1. It is composed of
##### 3 parts:
##### 1. Setting Libraries and Reading in Data
##### 2. Performing Calculation and ML Estimation
##### 3. Constructing Tables and Figures

#### 1. Setting Libraries and Reading in Data

# ---- Timing (start) ----
script_start_time <- Sys.time()

#### Set Results, File, and Data Paths (Change Path Accordingly)
#### 1. Setting Libraries and Reading in Data ----
dir <- "/Users/jasonsomerville/Desktop/CRP CCP BP/replication_files"
tables   <- file.path(dir, "tables")
figures  <- file.path(dir, "figures")
filepath <- file.path(dir, "R")
datapath <- file.path(dir, "cleaned-data")
output   <- file.path(dir, "R/output")

# Reproducibility seed
set.seed(1234)

#### Install packages, Set Libraries and Necessary Functions
## Minimal packages actually used by the scripts you shared
pkgs <- c("stats4", "mvtnorm", "dplyr", "kableExtra")
to_install <- setdiff(pkgs, rownames(installed.packages()))
if (length(to_install)) install.packages(to_install)
library(stats4)
library(mvtnorm)
library(dplyr)
library(kableExtra)

source(file.path(filepath, "functions.R"))

#### Read in Master Data Set
dataset_master <- read.csv(file.path(datapath, "part2_cleaned.csv"))

# NOTE (notation alignment):
# The Stata cleaning now outputs paper-aligned valuation names:
#   h_ab, h_abprime, h_cd (and *_repeat).
# The decomposition functions in mcgetal_functions.R expect the legacy names:
#   h_ac, h_ab, h_de (and *_repeat).
# To preserve backwards compatibility without rewriting those functions,
# we create aliases mapping:
#   h_ac        <- h_ab        (paper AB)
#   h_ab        <- h_abprime   (paper AB')
#   h_de        <- h_cd        (paper CD)
# and similarly for repeats.
dataset_master <- dataset_master %>%
  mutate(
    h_ac        = h_ab,
    h_ab        = h_abprime,
    h_de        = h_cd,
    h_ac_repeat = h_ab_repeat,
    h_ab_repeat = h_abprime_repeat,
    h_de_repeat = h_cd_repeat
  )


#### 2. Conduct Calculations of Decomposition Exercise and Construct Expected Preferences ----
#### May be skipped for time consideration and decomposition product read in from prior estimation
source(file.path(filepath, "reducedForm.R"))

#### Read In Decomposition Product
agg_data_mle        <- read.csv(file.path(output, "estimated_output_mle.csv"))
agg_data_calc       <- read.csv(file.path(output, "estimated_output_calc.csv"))
agg_data_mle_levels <- read.csv(file.path(output, "estimated_output_mle_levels.csv"))
agg_data_calc_levels<- read.csv(file.path(output, "estimated_output_calc_levels.csv"))

#### 3. Constructing Tables and Figures
#### Table D.1
source(file.path(filepath,  "makeTableD1.R"))
#### Table D.2
source(file.path(filepath,  "makeTableD2.R"))
#### Figure D.1
source(file.path(filepath, "makeFigureD1.R"))

# ---- Timing (end) ----
script_end_time <- Sys.time()
elapsed <- difftime(script_end_time, script_start_time, units = "secs")
msg <- sprintf(
  "main.R finished.\nStart: %s\nEnd:   %s\nElapsed: %.2f seconds (%.2f minutes)\n",
  format(script_start_time, "%Y-%m-%d %H:%M:%S %Z"),
  format(script_end_time,   "%Y-%m-%d %H:%M:%S %Z"),
  as.numeric(elapsed),
  as.numeric(elapsed) / 60
)

cat(msg)
