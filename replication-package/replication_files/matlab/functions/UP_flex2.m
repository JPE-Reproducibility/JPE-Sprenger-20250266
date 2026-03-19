function F = UP_flex2(theta,h,p,r,type,cutoffs)

% Parameters
rho = theta;
M = p*30;
N = length(h);

% Parts
F = zeros(size(h));
for j = 1:N
    if strcmp(type(j),'AB')
        eqnAB = @(x)(M(j) + kappa_flex2(M(j),rho,cutoffs) - p(j)*x - p(j)^2*kappa_flex2(x,rho,cutoffs));
        h_star = fzero(eqnAB,[M(j),100]);
    elseif strcmp(type(j),'CD')
        eqnCD = @(x)(r(j)*M(j) + r(j)^2*kappa_flex2(M(j),rho,cutoffs) - (r(j)*p(j)*x) - (r(j)*p(j))^2*kappa_flex2(x,rho,cutoffs));
        h_star = fzero(eqnCD,[M(j),100]);
    elseif strcmp(type(j),'AB_prime')
        eqnAB_prime = @(x)(M(j) + kappa_flex2(M(j),rho,cutoffs) - (r(j)*p(j)*x) - (1-r(j))*M(j) - (r(j)*p(j) + 1 - r(j))*(r(j)*p(j)*kappa_flex2(x,rho,cutoffs)+(1-r(j))*kappa_flex2(M(j),rho,cutoffs)));
        h_star = fzero(eqnAB_prime,[M(j),100]);
    else
    end
    % Least squares objective function
    F(j) = h(j) - h_star; 
end

end
