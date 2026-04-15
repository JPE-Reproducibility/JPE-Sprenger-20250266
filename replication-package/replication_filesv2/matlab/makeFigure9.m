%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose: Makes Figure 9 from the main text				   	                                     
% Last edited: 01/16/2026 		                                              
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; close all;
dir = "/Users/jasonsomerville/Desktop/CRP CCP BP/replication_files"; %Set directory
cd(dir)

% Functions and estimates
u     = @(x,a)(x.^a);
alpha_hat = 1;

% Choose which case to run
cases = {'I1', 'I2', 'I3', 'I4', 'I5'};
panels = {'a', 'b', 'c', 'd', 'e'};
for z = 1:size(cases,2)
    caseName = cases{z};  % 'I1', 'I2', 'I3', 'I4', or 'I5'
    
    % Parameters for each case
    switch caseName
        case 'I1'
           M=15;   H=400; k_H = 2142; k_M=720.5; p=0.5;    % I1 - One linear IC, concave left / convex right, fanning-out
        case 'I2'
          M = 15; H = 212; k_M = 150; k_H = 160; p = 0.55; % I2 - Global quasi-convex, global fanning-out
        case 'I3'
            M = 15; H = 60; k_M = 120; k_H = 420; p=0.5;   % I3 - Global quasi-concave, global fanning-out
        case 'I4'
            M = 15; H = 30; k_M = 40;  k_H = 160;  p=0.5;    % I4 - Quasi-concave, fanning-out left, constant slopes right
        case 'I5'
            M = 15; k_M = 35; k_H = 125; H = 22.152; p = 0.55;    % I5 - Quasi-concave, fanning-out left, fanning-in right
        otherwise
            error('Unknown case name.')
    end
    
    % Specify the (q_L, q_H) anchor point for the linear IC in this case
    switch caseName
       case 'I1'
            linearIC_anchor = [3/4, 0];  % known from case I1 parameters
        otherwise
            linearIC_anchor = [];        % no bold IC by default
    end
    
    % Other parameters
    r = 0.25; L = 0;
    
    % Points
    A  = [0,0];
    B  = [1-p,p];
    C  = [1-r,0];
    D  = [1-r*p,r*p];
    Bp = [r*(1-p),r*p];
    E  = [0,1-r];
    F  = [r*p,1-r*p];
    
    % Colors
    red    = [178,34,34]./255;
    blue   = [0,114,178]./255;
    purple = [96,64,135]./255;
    green  = [0,128,0]./255;
    gold   = [255,210,0]./255;
    navy   = [0,45,114]./255;
    orange = [193,5,52]./255;
    
    points = {
        A,  red,    '$A$',       -0.045,  0.030
        B,  blue,   '$B$',       -0.020,  0.030
        Bp, purple, '$B^\prime$',-0.045,  0.020
        C,  green,  '$C$',       -0.030,  0.030
        D,  gold,   '$D$',       -0.015,  0.030
        E,  navy,   '$E$',       -0.030,  0.030
        F,  orange, '$F$',       -0.015,  0.030
    };
    
    % Values and coefficients
    u_M = u(M,alpha_hat);
    u_H = u(H,alpha_hat);
    u_L = u(L,alpha_hat);
    
    c0 = u_M + k_M;
    c1 = (u_H - u_M) + (k_H - k_M);
    c2 = (u_L - u_M) - 2*k_M;
    
    % Anchor points for ICs
    pts = [ ...
        0,     0;
        1/4,   0;
        1/2,   0;
        3/4,   0;
        9/10,  0;
        0,     1/4;
        0,     1/2;
        0,     3/4;
        0,     9/10];
    U = @(qL,qH)(c0 + c1.*qH + c2.*qL + k_M.*qL.^2 - (k_H - k_M).*qL.*qH);
    U_levels = U(pts(:,1), pts(:,2)).';
    
    %% Plotting
    figure('Units','inches','Position',[1 1 7 7]);
    set(groot,'defaultAxesTickLabelInterpreter','latex');
    hold on
    pL = linspace(0,1,10000);
    
    % Triangle boundaries
    plot(pL,1-pL,'k-','LineWidth',2)
    plot(zeros(size(pL)),pL,'k-','LineWidth',2)
    plot(pL,zeros(size(pL)),'k-','LineWidth',2)
    
    
    % ICs
    for j = 1:numel(U_levels)
        pH = (U_levels(j) - c0 - c2.*pL - k_M.*pL.^2) ./ (c1 - (k_H - k_M).*pL);
        keep = isfinite(pH) & (pH >= 0) & (pH <= 1) & (pH + pL <= 1);
    
        % Check if this IC matches the linearIC_anchor
        if ~isempty(linearIC_anchor) && isequal(pts(j,:), linearIC_anchor)
            lw = 3; 
        else
            lw = 1.75;
        end
    
        plot(pL(keep), pH(keep), 'Color', [0.2,0.2,0.2], 'LineWidth', lw);
    end
    
    
    % Points
    for i = 1:size(points,1)
        P   = points{i,1};
        lab = points{i,3};
        dx  = points{i,4};
        dy  = points{i,5};
        scatter(P(1),P(2),20,'k','filled','LineWidth',2)
        text(P(1)+dx, P(2)+dy, lab, ...
            'Color','k', 'FontSize',15, 'Interpreter','latex')
    end
    
    % Format
    xlim([0,1]); ylim([0,1])
    axis square
    xlabel('$q_L$','Interpreter','latex')
    ylabel('$q_H$','Interpreter','latex')
    set(gca,'FontSize',14);
    set(gca,'XTick',[0 1],'YTick',[0 1])
    
    % Export file named by case
    exportgraphics(gcf, sprintf('figures/Figure9%s.pdf', panels{z}));
end
close all;