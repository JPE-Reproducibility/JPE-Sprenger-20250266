function F = UP(theta, h, p, r, type, kappa)
    % UP  Computes the vector of residuals F(j) = h(j) - h_star(j),
    % where h_star is the root of the relevant equation on [0,∞).
    %
    % Inputs:
    %   theta — parameter vector rho = [rho1,rho2,rho3,rho4]
    %   h, p, r    — data vectors (all length N)
    %   type       — cellstr array of length N, elements 'AB','CD','AB_prime'
    %   kappa      — function handle kappa(z,rho)
    %
    % Output:
    %   F — N×1 residual vector

    rho = theta;
    M   = 30 * p;         
    N   = numel(h);
    F   = zeros(N,1);
    
    for j = 1:N
        % build the zero‐finding function for this j
        switch type{j}
          case 'AB'
            eqn = @(x) M(j) + kappa(M(j),rho) - p(j)*x - p(j)^2 * kappa(x,rho);
          case 'CD'
            eqn = @(x) r(j)*M(j) + r(j)^2 * kappa(M(j),rho) - (r(j)*p(j))*x - (r(j)*p(j))^2 * kappa(x,rho);
          case 'AB_prime'
            eqn = @(x)(M(j) + kappa(M(j),rho) - (r(j)*p(j)*x) - (1-r(j))*M(j) - (r(j)*p(j) + 1 - r(j))*(r(j)*p(j)*kappa(x,rho)+(1-r(j))*kappa(M(j),rho)));
          otherwise
            error('Unknown type "%s"', type{j});
        end

        % bracket root on [lb, ub], with expansion if needed
        lb    = M(j);
        ub    = 100;
        f_lb  = eqn(lb);
        f_ub  = eqn(ub);
        max_ub = 1e4;   % cap to prevent runaway

        % expand ub until we bracket a sign‐change or hit max_ub
        while (f_lb * f_ub > 0) && (ub < max_ub)
            ub = ub * 2;
            f_ub = eqn(ub);
        end

        h_star = fzero(eqn, [lb, ub]);
       
        % build residual
        F(j) = h(j) - h_star;
    end
end



% function F = UP(theta,h,p,r,type,kappa)
% 
% % Parameters
% rho = theta;
% M = p*30;
% N = length(h);
% 
% % Parts
% F = zeros(size(h));
% for j = 1:N
%     if strcmp(type(j),'AB')
%         eqnAB = @(x)(M(j) + kappa(M(j),rho) - p(j)*x - p(j)^2*kappa(x,rho));
%         h_star = fzero(eqnAB,M(j));
%     elseif strcmp(type(j),'CD')
%         eqnCD = @(x)(r(j)*M(j) + r(j)^2*kappa(M(j),rho) - (r(j)*p(j)*x) - (r(j)*p(j))^2*kappa(x,rho));
%         h_star = fzero(eqnCD,M(j));
%     elseif strcmp(type(j),'AB_prime')
%         eqnAB_prime = @(x)(M(j) + kappa(M(j),rho) - (r(j)*p(j)*x) - (1-r(j))*M(j) - (r(j)*p(j) + 1 - r(j))*(r(j)*p(j)*kappa(x,rho)+(1-r(j))*kappa(M(j),rho)));
%         h_star = fzero(eqnAB_prime,M(j));
%     else
%     end
%     % Least squares objective function
%     F(j) = h(j) - h_star; 
% end
% 
% end
