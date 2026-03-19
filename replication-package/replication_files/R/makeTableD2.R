##### McGranaghan et al. (2026)
##### makeTableD2.R
##### ---------------------

#### MLE Differences Table
agg_data_mle$p <- agg_data_mle$p/100
agg_data_mle$r <- agg_data_mle$r/100
agg_data_mle_levels <- agg_data_mle_levels %>% dplyr::select(-dplyr::any_of("X"))
table_diffs_mle <- 
  kbl(
    agg_data_mle, "latex",
    booktabs = TRUE, digits = 2, escape = FALSE,
    col.names = c("p", "r", "$\\hat{\\Delta}_{CR}^{**}$", "$\\hat{\\Delta}_{CC}^{**}$", "$\\hat{\\Delta}_{MX}^{**}$",
                  "$\\widehat{var(\\Delta_{CR}^*)}$", "$\\widehat{var(\\Delta_{CC}^*)}$", "$\\widehat{var(\\Delta_{MX}^*)}$",
                  "$\\widehat{var(\\Delta_{CR})}$", "$\\widehat{var(\\Delta_{CC})}$", "$\\widehat{var(\\Delta_{MX})}$",
                  "$\\widehat{var(\\Delta_{CR}^*)} \\over \\widehat{var(\\Delta_{CR})}$",
                  "$\\widehat{var(\\Delta_{CC}^*)} \\over \\widehat{var(\\Delta_{CC})}$",
                  "$\\widehat{var(\\Delta_{MX}^*)} \\over \\widehat{var(\\Delta_{MX})}$"),
    caption = "Decomposition Calculations (Differences)\\label{apptab:TableD2}"
  ) %>%
  footnote(
    general = "Decomposition estimates calculated from from MLE exercise.
            Final line presents averages over all 20 rows.",
    footnote_as_chunk = TRUE,
    escape = FALSE
  ) %>%
  save_kable(file.path(tables, "TableD2.tex"))
