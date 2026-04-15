function F = CPT_flex(theta,h,p,r,type,cutoffs)

% Parameters
gamma = theta(1:end-1);
alpha = theta(end);
M = p*30; 

% Parts
partAB       = M.*(1./pi_flex(p,gamma,cutoffs)).^(1/alpha);
partCD       = M.*(pi_flex(r,gamma,cutoffs)./pi_flex(p.*r,gamma,cutoffs)).^(1/alpha);
partAB_prime = M.*((1-pi_flex(r.*p+1-r,gamma,cutoffs)+pi_flex(p.*r,gamma,cutoffs))./pi_flex(p.*r,gamma,cutoffs)).^(1/alpha);

% Objective Function
F = h - (partAB.*(type=="AB")+partAB_prime.*(type=="AB_prime")+partCD.*(type=="CD"));

end
