##### McGranaghan et al. (2026)
##### makeFigureD1.R
##### ---------------------


#### Figure Relating MLE and Calculated Values
pdf(file = file.path(figures, "FigureD1.pdf"), width = 10, height = 10)
split.screen(c(2,2))

screen(1)
hvec_calc <- c(agg_data_calc_levels$mean_h_ac_star, agg_data_calc_levels$mean_h_ab_star, agg_data_calc_levels$mean_h_de_star)
hvec_mle <- c(agg_data_mle_levels$mean_h_ac_star, agg_data_mle_levels$mean_h_ab_star, agg_data_mle_levels$mean_h_de_star)
rho_h <- round(cor(hvec_calc, hvec_mle, use="complete.obs"),2)
model_h <- lm(hvec_mle~hvec_calc)
plot(hvec_calc, hvec_mle, xlab=expression(paste(hat(mu)[XY],"-calc")), ylab="", main="Panel A: Levels",
     xlim=c(20,50), ylim=c(20,50))
abline(a= 0, b= 1, lty=2, col="gray")
abline(a=coef(model_h)[1], b=coef(model_h)[2])
text(x=37, y=30, label= paste("Corr = ", rho_h ))
text(x=37, y=28.5, label= paste("y = ", round(coef(model_h)[2],2), "x", round(coef(model_h)[1],2) ))
mtext(expression(paste(hat(mu)[XY],"-mle")), side = 2, line =2)

screen(2)
sigmavec_calc <- sqrt(c(agg_data_calc_levels$sigma2_ac, agg_data_calc_levels$sigma2_ab, agg_data_calc_levels$sigma2_de))
sigmavec_mle <- sqrt(c(agg_data_mle_levels$sigma2_ac, agg_data_mle_levels$sigma2_ab, agg_data_mle_levels$sigma2_de))
rho_sigma <- round(cor(sigmavec_calc, sigmavec_mle, use="complete.obs"),2)
model_sigma <- lm(sigmavec_mle~sigmavec_calc)
plot(sigmavec_calc, sigmavec_mle, xlab=expression(paste(hat(sigma)[XY],"-calc")), 
     ylab="", main="Panel B: Noise",
     xlim=c(5,15), ylim =c(5,15))
abline(a= 0, b= 1, lty=2, col="gray")
abline(a=coef(model_sigma)[1], b=coef(model_sigma)[2])
text(x=12, y=9, label=paste("Corr =", rho_sigma)  )
text(x=12, y=8.5, label= paste("y = ", round(coef(model_sigma)[2],2), "x", round(coef(model_sigma)[1],2) ))
mtext(expression(paste(hat(sigma)[XY],"-mle")), side = 2, line =2)


screen(3)
thetavec_calc <- sqrt(c(agg_data_calc_levels$theta2_ac, agg_data_calc_levels$theta2_ab, agg_data_calc_levels$theta2_de))
thetavec_mle <- sqrt(c(agg_data_mle_levels$theta2_ac, agg_data_mle_levels$theta2_ab, agg_data_mle_levels$theta2_de))
rho_theta <- round(cor(thetavec_calc, thetavec_mle, use="complete.obs"),2)
model_theta <- lm(thetavec_mle~thetavec_calc)
plot(thetavec_calc, thetavec_mle, xlab=expression(paste(hat(theta)[XY],"-calc")), 
     ylab="" , main="Panel C: Heterogeneity" ,
     xlim=c(5,15), ylim =c(5,15))
abline(a= 0, b= 1, lty=2, col="gray")
abline(a=coef(model_theta)[1], b=coef(model_theta)[2])
text(x=12, y=9, label=paste("Corr =", rho_theta)  )
text(x=12, y=8.5, label= paste("y = ", round(coef(model_theta)[2],2), "x +", round(coef(model_theta)[1],2) ))
mtext(expression(paste(hat(theta)[XY],"-mle")), side = 2, line =2)


screen(4)
covvec_calc <- (c(agg_data_calc_levels$theta_acab, agg_data_calc_levels$theta_acde, agg_data_calc_levels$theta_abde))
covvec_mle <- (c(agg_data_mle_levels$theta_acab, agg_data_mle_levels$theta_acde, agg_data_mle_levels$theta_abde))
rho_cov <- round(cor(covvec_calc, covvec_mle, use="complete.obs"),2)
model_cov<- lm(covvec_mle~covvec_calc)
plot(covvec_calc, covvec_mle, xlab=expression(paste(hat(theta)[paste("XY,","WZ")],"-calc")), 
     ylab="" , 
     main="Panel D: Covariances", xlim = c(20,140), ylim= c(20, 140)   )
abline(a= 0, b= 1, lty=2, col="gray")
abline(a=coef(model_cov)[1], b=coef(model_cov)[2])
text(x=100, y=60, label=paste("Corr =", rho_cov)  )
text(x=100, y=54, label= paste("y = ", round(coef(model_cov)[2],2), "x +", round(coef(model_cov)[1],2) ))
mtext(expression(paste(hat(theta)[paste("XY,","WZ")],"-mle")) , side = 2, line =2)


close.screen(all=TRUE)
dev.off()
