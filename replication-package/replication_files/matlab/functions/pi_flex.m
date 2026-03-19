function pi_q = pi_flex(q, gamma, cutoffs)
    % Initialize the output array
    pi_q = zeros(size(q));
    
    % Define the boundary points
    q1 = cutoffs(1);
    q2 = cutoffs(2);
    q3 = cutoffs(3);
    q4 = cutoffs(4);
    q5 = cutoffs(5);

    % Define the function using piecewise conditional statements
    for j = 1:length(q)
        if q(j) == 0
            pi_q(j) = 0;
        elseif q(j) > 0 && q(j) <= q1
            pi_q(j) = gamma(1) + gamma(2) * q(j);
        elseif q(j) > q1 && q(j) <= q2
            pi_q(j) = gamma(1) + gamma(2) * q1 + gamma(3) * (q(j) - q1);
        elseif q(j) > q2 && q(j) <= q3
            pi_q(j) = gamma(1) + gamma(2) * q1 + gamma(3) * (q2 - q1) + gamma(4) * (q(j) - q2);
        elseif q(j) > q3 && q(j) <= q4
            pi_q(j) = gamma(1) + gamma(2) * q1 + gamma(3) * (q2 - q1) + gamma(4) * (q3 - q2) + gamma(5) * (q(j) - q3);
        elseif q(j) > q4 && q(j) <= q5
            pi_q(j) = gamma(1) + gamma(2) * q1 + gamma(3) * (q2 - q1) + gamma(4) * (q3 - q2) + gamma(5) * (q4 - q3) + gamma(6) * (q(j) - q4);
        elseif q(j) > q5 && q(j) < 1
            pi_q(j) = gamma(1) + gamma(2) * q1 + gamma(3) * (q2 - q1) + gamma(4) * (q3 - q2) + gamma(5) * (q4 - q3) + gamma(6) * (q5 - q4) + gamma(7) * (q(j) - q5);
        elseif q(j) == 1
            pi_q(j) = 1;
        else
            error('Invalid value for q.');
        end
    end
end