function kappa_z = kappa_flex2(z, rho, cutoffs)

% Initialize the output array
kappa_z = zeros(size(z));

% Define the boundary points
k1 = cutoffs(1);
k2 = cutoffs(2);
k3 = cutoffs(3);
k4 = cutoffs(4);
k5 = cutoffs(5);

% Define the function using piecewise conditional statements
for j = 1:length(z)
    if z(j) >= 0 && z(j) <= k1
        kappa_z(j) = rho(1) * z(j);
    elseif z(j) > k1 && z(j) <= k2
        kappa_z(j) = rho(1) * k1 + rho(2) * (z(j) - k1);
    elseif z(j) > k2 && z(j) <= k3
        kappa_z(j) = rho(1) * k1 + rho(2) * (k2 - k1) + rho(3) * (z(j) - k2);
    elseif z(j) > k3 && z(j) <= k4
        kappa_z(j) = rho(1) * k1 + rho(2) * (k2 - k1) + rho(3) * (k3 - k2) + rho(4) * (z(j) - k3);
    elseif z(j) > k4 && z(j) <= k5
        kappa_z(j) = rho(1) * k1 + rho(2) * (k2 - k1) + rho(3) * (k3 - k2) + rho(4) * (k4 - k3) + rho(5) * (z(j) - k4);
    elseif z(j) > k5
        kappa_z(j) = rho(1) * k1 + rho(2) * (k2 - k1) + rho(3) * (k3 - k2) + rho(4) * (k4 - k3) + rho(5) * (k5 - k4) + rho(6) * (z(j) - k5);
    else
        error('Invalid value for z.');
    end
end


end

