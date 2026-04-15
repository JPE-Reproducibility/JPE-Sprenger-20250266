##### McGranaghan et al. (2024)
##### makeTableD1.R
##### ---------------------

#### MLE Levels Table
agg_data_mle_levels$p <- agg_data_mle_levels$p/100
agg_data_mle_levels$r <- agg_data_mle_levels$r/100
agg_data_mle_levels <- agg_data_mle_levels %>% dplyr::select(-dplyr::any_of("X"))
table_levels_mle <- 
  kbl(
    agg_data_mle_levels, "latex",
    booktabs = TRUE, digits = 2, escape = FALSE,
    col.names = c("p", "r", "$\\hat{\\mu}_{AB}^*$", "$\\hat{\\mu}_{AB'}^*$", "$\\hat{\\mu}_{CD}^*$",
                  "$\\hat{\\theta}^2_{AB}$", "$\\hat{\\theta}^2_{AB'}$", "$\\hat{\\theta}^2_{CD}$",
                  "$\\hat{\\sigma}^2_{AB}$", "$\\hat{\\sigma}^2_{AB'}$", "$\\hat{\\sigma}^2_{CD}$",
                  "$\\hat{\\theta}_{AB, AB'}$", "$\\hat{\\theta}_{AB, CD}$", "$\\hat{\\theta}_{AB',CD}$",
                  "$\\widehat{var(h_{AB}^*)}\\over\\widehat{var(h_{AB})}$",
                  "$\\widehat{var(h_{AB'}^*)}\\over\\widehat{var(h_{AB'})}$",
                  "$\\widehat{var(h_{CD}^*)}\\over\\widehat{var(h_{CD})}$"),
    caption = "Decomposition Calculations (Levels)\\label{apptab:TableD1}"
  ) %>%
  footnote(
    general = "Decomposition estimates from MLE exercise.
            Final line presents averages over all 20 rows.",
    footnote_as_chunk = TRUE,
    escape = FALSE
  ) %>%
  save_kable(file.path(tables, "TableD1.tex"))
