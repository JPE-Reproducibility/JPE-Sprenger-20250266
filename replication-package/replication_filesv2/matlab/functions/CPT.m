function F = CPT(theta,h,p,r,pi,type)

% Parameters
gamma = theta(1:end-1);
alpha = theta(end);
M = p*30;

% Parts
partAB       = M.*(1./pi(p,gamma)).^(1/alpha);
partCD       = M.*(pi(r,gamma)./pi(p.*r,gamma)).^(1/alpha);
partAB_prime = M.*((1-pi(r.*p+1-r,gamma)+pi(p.*r,gamma))./pi(p.*r,gamma)).^(1/alpha);

% % Objective Function
F = h - (partAB.*(type=="AB")+partAB_prime.*(type=="AB_prime")+partCD.*(type=="CD"));

end


