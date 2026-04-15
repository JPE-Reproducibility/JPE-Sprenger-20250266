%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose: Makes Figures 8, A.5, F.1-F.3, G.1-G.6, and Tables F.1 and G.2			   	                                     
% Last edited: 01/17/2026 		                                              
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; close all;
dir = "/Users/jasonsomerville/Desktop/CRP CCP BP/replication_files"; %Set directory
cd(dir)
rng(1234) % Set seed for replication
addpath(dir+'/matlab/functions')
ebblue    =[0,139,188]./255;
cranberry =[193,5,52]./255;
green     =[0,128,0]./255;
gold      =[255,210,0]./255;
navy      =[0,0,128]./255;
purple    =[128,0,128]./255;
red       =[178,34,34]./255;

% Optimizer options (shared)
opts = optimoptions('lsqnonlin', ...
        'Algorithm','trust-region-reflective', ...
        'Display','iter', ...
        'OptimalityTolerance',1e-4, ...
        'StepTolerance',      1e-4);

%% Import and format data
Data = readtable(dir+'/cleaned-data/part1_cleaned.csv');
N = size(Data,1);

% Set Up Data
h_ab       = Data.h_ab;      
h_ab_prime = Data.h_abprime;   
h_cd       = Data.h_cd;        
p          = Data.p;
r          = Data.r;
id         = Data.id;
Nr = length(unique(Data.r));
Np = length(unique(Data.p));

% Set up data inputs for estimation (all ~42K obs)
type = [repmat({'AB'},N,1);repmat({'AB_prime'},N,1);repmat({'CD'},N,1)];
p = [p;p;p];
r = [r;r;r];
h = [h_ab; h_ab_prime; h_cd];
all_probs    = unique(round([p;p.*r;r;1-r],3));

% Utility function
u = @(x,a)(x.^a);

% Actual values for prediction
Rs = repmat(unique(r),[Np,1]);
Ps = repelem(unique(p),Nr);
mean_h_ab = zeros(Nr*Np,1);
mean_h_cd = zeros(Nr*Np,1);
mean_h_ab_prime = zeros(Nr*Np,1);
for j = 1:20
    mean_h_ab(j)       = mean(h(all([r==Rs(j),p==Ps(j),strcmp(type,'AB')],2)));
    mean_h_cd(j)       = mean(h(all([r==Rs(j),p==Ps(j),strcmp(type,'CD')],2)));
    mean_h_ab_prime(j) = mean(h(all([r==Rs(j),p==Ps(j),strcmp(type,'AB_prime')],2)));
end

% Mean differences
mean_Delta_CR = mean_h_ab - mean_h_cd;
mean_Delta_CC = mean_h_ab_prime - mean_h_cd;
mean_Delta_MX = mean_h_ab - mean_h_ab_prime;

% Set up data inputs for estimation
h = [mean_h_ab; mean_h_ab_prime; mean_h_cd];
p = [Ps;Ps;Ps];
r = [Rs;Rs;Rs];
type = [repmat({'AB'},Np*Nr,1);repmat({'AB_prime'},Np*Nr,1);repmat({'CD'},Np*Nr,1)];
all_outcomes = unique(round([p.*30,h],3));


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% UP MODELS 
%   flex2  -> Table F.1(1), FigureF1
%   flex1  -> Table F.1(2), Figure8a + FigureA5a + FigureF2
%   param1 -> Table F.1(3), Figure8b + FigureA5b + FigureF3
%   param2 -> Table F.1(4), no figures
%   param3 -> Table F.1(5), no figures
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ---- Define UP model list (5 specs) ----
UPspec = struct([]);

% (1) Flexible non-parametric form 2  -> Table F.1(1), Figure F.1
UPspec(1).name     = "UP_flex2";
UPspec(1).kind     = "flex2";
UPspec(1).col      = 1;
UPspec(1).x0       = [1.6,3.9,6.6,7.1,-0.2,2];
UPspec(1).cutoffs  = [9,15,24,27,36];
UPspec(1).LB       = [];
UPspec(1).UB       = [];
UPspec(1).fig8     = "none";     % no Figure 8
UPspec(1).fig3     = "F1";       % 3-panel export: FigureF1 only
UPspec(1).title3   = "\textbf{Upside Potential - Flexible 2}";

% (2) Flexible non-parametric form 1  -> Table F.1(2), Figure 8a, A5a, F2
UPspec(2).name     = "UP_flex1";
UPspec(2).kind     = "flex1";
UPspec(2).col      = 2;
UPspec(2).x0       = [1.6,3.9,6.6,7.1,1];
UPspec(2).cutoffs  = [9,15,24,27];
UPspec(2).LB       = [0, 0, 0, 0, 0];
UPspec(2).UB       = [Inf, Inf, Inf, Inf, Inf];
UPspec(2).fig8     = "8a";       % Figure8a
UPspec(2).fig3     = "A5aF2";    % 3-panel export: FigureA5a + FigureF2
UPspec(2).title3   = "\textbf{Upside Potential - Flexible 1}";

% (3) Parametric form 1 -> Table F.1(3), Figure 8b, A5b, F3
UPspec(3).name     = "UP_form1";
UPspec(3).kind     = "param";
UPspec(3).col      = 3;
UPspec(3).x0       = [25, 3, 5];
UPspec(3).LB       = [0, 0, 0];
UPspec(3).UB       = [Inf, Inf, Inf];
UPspec(3).kappa    = @(z,rho) (rho(1) * (1 ./ (1 + exp((-rho(2)) * (z - rho(3))))));
UPspec(3).fig8     = "8b";       % Figure8b
UPspec(3).fig3     = "A5bF3";    % 3-panel export: FigureA5b + FigureF3
UPspec(3).title3   = "\textbf{Upside Potential - Parametric}";

% (4) Parametric form 2 -> Table F.1(4), no figures
UPspec(4).name     = "UP_form2";
UPspec(4).kind     = "param";
UPspec(4).col      = 4;
UPspec(4).x0       = [1.0, 0.20, 0.024, 0.010];
UPspec(4).LB       = [0, 0, 0, 0];
UPspec(4).UB       = [Inf, Inf, Inf, Inf];
UPspec(4).kappa    = @(z,rho) (rho(1) .* (z).^(rho(4)) ./ (1 + exp(-rho(2) .* (z - rho(3)))));
UPspec(4).fig8     = "none";
UPspec(4).fig3     = "none";
UPspec(4).title3   = "";

% (5) Parametric form 3 -> Table F.1(5), no figures
UPspec(5).name     = "UP_form3";
UPspec(5).kind     = "param";
UPspec(5).col      = 5;
UPspec(5).x0       = [25, 3, 5];
UPspec(5).LB       = [0, 0, 0];
UPspec(5).UB       = [Inf, Inf, Inf];
UPspec(5).kappa    = @(z,rho) (rho(1) * (1 ./ (1 + exp((-rho(2)) * (z - rho(3))))) ...
                          - rho(1) * (1 ./ (1 + exp((-rho(2)) * (0 - rho(3))))));
UPspec(5).fig8     = "none";
UPspec(5).fig3     = "none";
UPspec(5).title3   = "";

% Storage for Table F.1
% (1)=Flex 2, (2)=Flex 1, (3)=Parametric 1, (4)=Parametric 2, (5)=Parametric 3
theta_tbl = NaN(6,5);
se_tbl    = NaN(6,5);
obs_tbl   = NaN(1,5);
dof_tbl   = NaN(1,5);
mseL_tbl  = NaN(1,5);
r2L_tbl   = NaN(1,5);
rhoL_tbl  = NaN(1,5);
mseD_tbl  = NaN(1,5);
r2D_tbl   = NaN(1,5);
rhoD_tbl  = NaN(1,5);


% Main UP loop
for s = 1:numel(UPspec)

    x0 = UPspec(s).x0;
    LB = UPspec(s).LB;
    UB = UPspec(s).UB;
    col = UPspec(s).col;

    % ----------------------------
    % Estimation + kappa evaluator
    % ----------------------------
    if UPspec(s).kind == "param"
        kappa = UPspec(s).kappa;

        [theta_hat, resnorm, residual, ~, ~, ~, J] = ...
            lsqnonlin(@(x) UP(x,h,p,r,type,kappa), x0, LB, UB, opts);

        kappa_eval = @(zz) kappa(zz, theta_hat);

    elseif UPspec(s).kind == "flex1"
        cutoffs = UPspec(s).cutoffs;

        [theta_hat, resnorm, residual, ~, ~, ~, J] = ...
            lsqnonlin(@(x) UP_flex1(x,h,p,r,type,cutoffs), x0, LB, UB, opts);

        kappa_eval = @(zz) kappa_flex1(zz, theta_hat, cutoffs);

    else % flex2
        cutoffs = UPspec(s).cutoffs;

        [theta_hat, resnorm, residual, ~, ~, ~, J] = ...
            lsqnonlin(@(x) UP_flex2(x,h,p,r,type,cutoffs), x0, LB, UB, opts);

        kappa_eval = @(zz) kappa_flex2(zz, theta_hat, cutoffs);
    end

    % ----------------------------
    % Compute SEs
    % ----------------------------
    n  = length(residual);
    df = length(theta_hat);
    sigma2 = resnorm / (n - df);
    cov_theta = sigma2 * ((J' * J) \ eye(df));
    SEs = sqrt(diag(cov_theta));

    % ----------------------------
    % Predicted h's (param uses vpasolve; flex uses fzero)
    % ----------------------------
    h_ab_hat       = zeros(Nr*Np,1);
    h_ab_prime_hat = zeros(Nr*Np,1);
    h_cd_hat       = zeros(Nr*Np,1);

    if UPspec(s).kind == "param"
        syms x
        for j = 1:Nr*Np
            eqn_AB = Ps(j)*30 + kappa_eval(Ps(j)*30) - Ps(j)*x - Ps(j)^2*kappa_eval(x) == 0;
            h_ab_hat(j) = vpasolve(eqn_AB,x);

            eqn_AB_prime = Ps(j)*30 + kappa_eval(Ps(j)*30) ...
                - (Rs(j)*Ps(j)*x) - (1-Rs(j))*Ps(j)*30 ...
                - (Rs(j)*Ps(j)+1-Rs(j))*(Rs(j)*Ps(j)*kappa_eval(x) + (1-Rs(j))*kappa_eval(Ps(j)*30)) == 0;
            h_ab_prime_hat(j) = vpasolve(eqn_AB_prime,x);

            eqn_CD = Rs(j)*Ps(j)*30 + Rs(j)^2*kappa_eval(Ps(j)*30) ...
                - (Rs(j)*Ps(j)*x) - (Rs(j)*Ps(j))^2*kappa_eval(x) == 0;
            h_cd_hat(j) = vpasolve(eqn_CD,x);
        end
    else
        for j = 1:Nr*Np
            eqnAB = @(xx)(Ps(j)*30 + kappa_eval(Ps(j)*30) - Ps(j)*xx - Ps(j)^2*kappa_eval(xx));
            h_ab_hat(j) = fzero(eqnAB,[Ps(j)*30,100]);

            eqnCD = @(xx)(Rs(j)*Ps(j)*30 + Rs(j)^2*kappa_eval(Ps(j)*30) - (Rs(j)*Ps(j)*xx) - (Rs(j)*Ps(j))^2*kappa_eval(xx));
            h_cd_hat(j) = fzero(eqnCD,[Ps(j)*30,100]);

            eqnAB_prime = @(xx)(Ps(j)*30 + kappa_eval(Ps(j)*30) ...
                - (Rs(j)*Ps(j)*xx) - (1-Rs(j))*Ps(j)*30 ...
                - (Rs(j)*Ps(j) + 1 - Rs(j))*(Rs(j)*Ps(j)*kappa_eval(xx) + (1-Rs(j))*kappa_eval(Ps(j)*30)));
            h_ab_prime_hat(j) = fzero(eqnAB_prime,[Ps(j)*30,100]);
        end
    end

    h_ab_hat       = double(h_ab_hat);
    h_ab_prime_hat = double(h_ab_prime_hat);
    h_cd_hat       = double(h_cd_hat);

    % ----------------------------
    % Differences
    % ----------------------------
    Delta_CR_hat = h_ab_hat - h_cd_hat;
    Delta_CC_hat = h_ab_prime_hat - h_cd_hat;
    Delta_MX_hat = h_ab_hat - h_ab_prime_hat;

    % ----------------------------
    % Fit stats
    % ----------------------------
    mse_levels = mean([(h_ab_hat-mean_h_ab).^2;(h_cd_hat-mean_h_cd).^2;(h_ab_prime_hat-mean_h_ab_prime).^2]);
    rss_levels = sum([(h_ab_hat-mean_h_ab);(h_cd_hat-mean_h_cd);(h_ab_prime_hat-mean_h_ab_prime)].^2);
    tss_levels = sum(([mean_h_ab;mean_h_cd;mean_h_ab_prime] - mean([mean_h_ab;mean_h_cd;mean_h_ab_prime])).^2);
    r2_levels  = 1 - (rss_levels/tss_levels);
    rho_levels = corr([h_ab_hat;h_cd_hat;h_ab_prime_hat],[mean_h_ab;mean_h_cd;mean_h_ab_prime]);

    mse_differences = mean([(Delta_CR_hat-mean_Delta_CR).^2;(Delta_CC_hat-mean_Delta_CC).^2;(Delta_MX_hat-mean_Delta_MX).^2]);
    rss_differences  = sum([(Delta_CR_hat-mean_Delta_CR);(Delta_CC_hat-mean_Delta_CC);(Delta_MX_hat-mean_Delta_MX)].^2);
    tss_differences  = sum(([mean_Delta_CR;mean_Delta_CC;mean_Delta_MX] - mean([mean_Delta_CR;mean_Delta_CC;mean_Delta_MX])).^2);
    r2_differences   = 1 - (rss_differences/tss_differences);
    rho_differences  = corr([Delta_CR_hat;Delta_CC_hat;Delta_MX_hat],[mean_Delta_CR;mean_Delta_CC;mean_Delta_MX]);

    % ----------------------------
    % Store Table F.1 (col depends on spec)
    % ----------------------------
    theta_tbl(1:length(theta_hat),col) = theta_hat(:);
    se_tbl(1:length(SEs),col)          = SEs(:);
    obs_tbl(col)   = n;
    dof_tbl(col)   = n - df;
    mseL_tbl(col)  = mse_levels;
    r2L_tbl(col)   = r2_levels;
    rhoL_tbl(col)  = rho_levels;
    mseD_tbl(col)  = mse_differences;
    r2D_tbl(col)   = r2_differences;
    rhoD_tbl(col)  = rho_differences;

    % ============================================================
    % Figure 8(A/B) - only for flex1 and param1
    % ============================================================
    if UPspec(s).fig8 == "8a" || UPspec(s).fig8 == "8b"

        figure('Units','inches','Position',[1 1 7 7]);
        set(groot,'defaultAxesTickLabelInterpreter','latex');
        hold on
        xx = 0:0.1:50;
        plot(xx,kappa_eval(xx),'k-','LineWidth',2);

        % only Figure 8(A) had cutoff markers
        if UPspec(s).fig8 == "8a"
            scatter(UPspec(s).cutoffs, kappa_eval(UPspec(s).cutoffs), 65, 'k','filled');
        end

        xlabel("Outcome z",'Interpreter','Latex'); xticks(0:5:50);
        ylabel("$\kappa(z;\theta)$",'Interpreter','Latex');
        set(gca,'fontsize', 14);
        scatter(all_outcomes,kappa_eval(all_outcomes),'filled', 'MarkerFaceColor',red,'MarkerFaceAlpha',0.55);
        text(35,40,['MSE: ',num2str(round(mse_levels,2))],'FontSize',14,'Interpreter','Latex')
        text(35,30,['$R^2$: ',num2str(round(r2_levels,2))],'FontSize',14,'Interpreter','Latex')
        text(35,20,['$\rho(h,\hat{h})$: ',num2str(round(rho_levels,2))],'FontSize',14,'Interpreter','Latex')
        text(35,10,['$\rho(\Delta,\hat{\Delta})$: ',num2str(round(rho_differences,2))],'FontSize',14,'Interpreter','Latex')
        xlim([0,50]); ylim([0,170])
        axis("square")
        hold off

        if UPspec(s).fig8 == "8a"
            exportgraphics(gcf,'figures/Figure8a.pdf','Resolution',300)
        else
            exportgraphics(gcf,'figures/Figure8b.pdf','Resolution',300)
        end
        close(gcf);
    end

    % ============================================================
    % Shared 3-panel figures (A.5 / F.1 -- F.3)
    % ============================================================
    if UPspec(s).fig3 ~= "none"

        % ----- model-specific settings for the shared 3-panel block -----
        fig_title_left = UPspec(s).title3;
        f_eval         = kappa_eval;
        xscatter       = all_outcomes;

        % x-range depends on your originals (42 for A.5/F.* panels)
        xgrid = 0:0.1:42;

        left_xlabel    = "$z$";
        left_ylabel    = "$\kappa(z;\theta)$";
        draw_diagonal  = false;

        show_cutoffs   = (UPspec(s).kind ~= "param"); % flex1/flex2 only in A.5/F.* panel
        if show_cutoffs
            cutoff_pts = UPspec(s).cutoffs;
        else
            cutoff_pts = [];
        end

        % unify stat names expected by the shared block
        mse_levels_or_mse = mse_levels;
        r2_levels_or_r2   = r2_levels;

        % export file list
        if UPspec(s).fig3 == "A5aF2"
            exportFiles = {'figures/FigureA5a.pdf','figures/FigureF2.pdf'};
        elseif UPspec(s).fig3 == "A5bF3"
            exportFiles = {'figures/FigureA5b.pdf','figures/FigureF3.pdf'};
        else % "F1"
            exportFiles = {'figures/FigureF1.pdf'};
        end

        % ----- 3-panel figures-----
        figure('Renderer','painters','Position',[10 10 1800 450])
        set(groot,'defaultAxesTickLabelInterpreter','latex');

        % Panel 1: kappa function
        subplot(1,3,1); hold on
        plot(xgrid, f_eval(xgrid), 'k-','LineWidth',1.5);

        scatter(xscatter, f_eval(xscatter), 'filled', ...
            'MarkerFaceColor', red, 'MarkerFaceAlpha', 0.55);

        if show_cutoffs
            scatter(cutoff_pts, f_eval(cutoff_pts), [], 'k', 'filled', 'LineWidth', 2);
        end

        title(fig_title_left,'Interpreter','Latex');
        xlabel(left_xlabel,'Interpreter','Latex'); xticks(0:5:42);
        ylabel(left_ylabel,'Interpreter','Latex');
        set(gca,'fontsize',14);

        % use your UP text placement
        text(32,22,['MSE: ',num2str(round(mse_levels_or_mse,2))],'FontSize',14,'Interpreter','Latex')
        text(33,12,['$R^2$: ',num2str(round(r2_levels_or_r2,2))],'FontSize',14,'Interpreter','Latex')

        xlim([0,42]); ylim([0,160]);
        axis("square");
        hold off

        % Panel 2: levels
        subplot(1,3,2); hold on
        plot(20:0.01:45,20:0.01:45,'--','Color',[0.7,0.7,0.7],'LineWidth',1.5);
        scatter(h_ab_hat,mean_h_ab,[],green,'filled','MarkerFaceAlpha',1)
        scatter(h_ab_prime_hat,mean_h_ab_prime,[],gold,'filled','MarkerFaceAlpha',1)
        scatter(h_cd_hat,mean_h_cd,[],navy,'filled','MarkerFaceAlpha',0.7)
        xlim([20,45]); ylim([20,45])
        xlabel("Predicted",'Interpreter','Latex'); ylabel("Actual",'Interpreter','Latex');
        title("\textbf{In-Sample Fit - Levels}",'Interpreter','Latex');
        text(37,23,['$\rho(h,\hat{h})$ = ',num2str(round(rho_levels,2))],'FontSize',14,'Interpreter','Latex')
        set(gca,'fontsize',14);
        legend({'',"$h_{AB}$","$h_{AB'}$",'$h_{CD}$'},'Location','northwest','Interpreter','Latex');
        axis("square")
        hold off

        % Panel 3: differences
        subplot(1,3,3); hold on
        plot(-20:0.01:20,-20:0.01:20,'--','Color',[0.7,0.7,0.7],'LineWidth',1.5);
        scatter(Delta_CR_hat,mean_Delta_CR,[],red,'filled','MarkerFaceAlpha',1)
        scatter(Delta_CC_hat,mean_Delta_CC,[],ebblue,'filled','MarkerFaceAlpha',1)
        scatter(Delta_MX_hat,mean_Delta_MX,[],purple,'filled','MarkerFaceAlpha',0.7)
        xlim([-12,20]); ylim([-12,20])
        xlabel("Predicted",'Interpreter','Latex'); ylabel("Actual",'Interpreter','Latex');
        title("\textbf{In-Sample Fit - Differences}",'Interpreter','Latex');
        text(10,-8,['$\rho(\Delta,\hat{\Delta})$ = ',num2str(round(rho_differences,2))],'FontSize',14,'Interpreter','Latex')
        set(gca,'fontsize',14);
        axis("square");
        legend({'','$\Delta_{CR}$',"$\Delta_{CC}$",'$\Delta_{MX}$'},'Location','northwest','Interpreter','Latex');
        hold off

        aa=subplot(132); aa.Position(1)=0.3825;
        aa=subplot(133); aa.Position(1)=0.635;

        for k = 1:numel(exportFiles)
            exportgraphics(gcf, exportFiles{k}, 'Resolution',300);
        end
        close(gcf);
    end

end

% ---------- Write Table F.1 (TeX) from stored arrays ----------
texDir = fullfile(dir,'tables');
if ~exist(texDir,'dir')
    [ok,msg] = mkdir(texDir);
    if ~ok
        error('Could not create tables directory: %s\nPath: %s', msg, texDir);
    end
end
texFile = fullfile(texDir,'TableF1.tex');

% use char() for compatibility; check fid
[fid,errmsg] = fopen(char(texFile),'w');
if fid == -1
    error('Could not open %s for writing.\nReason: %s', texFile, errmsg);
end
fprintf(fid,'\\\\\n');

for i = 1:6
    % Coefficient row
    fprintf(fid,'\\quad $\\theta_%d$', i);
    for c = 1:5
        if isnan(theta_tbl(i,c))
            fprintf(fid,' & ');
        else
            fprintf(fid,' & %.2f', theta_tbl(i,c));
        end
    end
    fprintf(fid,' \\\\\n');

    % SE row
    fprintf(fid,' ');
    for c = 1:5
        if isnan(se_tbl(i,c))
            fprintf(fid,' & ');
        else
            fprintf(fid,' & (%.2f)', se_tbl(i,c));
        end
    end
    fprintf(fid,' \\\\\n');
end
fprintf(fid,'\\\\\n');

% Observations
fprintf(fid,'Observations');
for c = 1:5
    if isnan(obs_tbl(c)), fprintf(fid,' & ');
    else, fprintf(fid,' & %.0f', obs_tbl(c));
    end
end
fprintf(fid,' \\\\\n');

% Degrees of Freedom
fprintf(fid,'Degrees of Freedom');
for c = 1:5
    if isnan(dof_tbl(c)), fprintf(fid,' & ');
    else, fprintf(fid,' & %.0f', dof_tbl(c));
    end
end
fprintf(fid,' \\\\\n');

% MSE levels
fprintf(fid,'MSE -- $h_{XY}$ levels');
for c = 1:5
    if isnan(mseL_tbl(c)), fprintf(fid,' & ');
    else, fprintf(fid,' & %.2f', mseL_tbl(c));
    end
end
fprintf(fid,' \\\\\n');

% R^2 levels
fprintf(fid,'$R^2$ -- $h_{XY}$ levels');
for c = 1:5
    if isnan(r2L_tbl(c)), fprintf(fid,' & ');
    else, fprintf(fid,' & %.2f', r2L_tbl(c));
    end
end
fprintf(fid,' \\\\\n');

% rho levels
fprintf(fid,'$\\rho(h_{XY}, \\hat{h}_{XY})$');
for c = 1:5
    if isnan(rhoL_tbl(c)), fprintf(fid,' & ');
    else, fprintf(fid,' & %.2f', rhoL_tbl(c));
    end
end
fprintf(fid,' \\\\\n');

% MSE differences
fprintf(fid,'MSE -- $\\Delta$ Differences');
for c = 1:5
    if isnan(mseD_tbl(c)), fprintf(fid,' & ');
    else, fprintf(fid,' & %.2f', mseD_tbl(c));
    end
end
fprintf(fid,' \\\\\n');

% R^2 differences
fprintf(fid,'$R^2$ -- $\\Delta$ Differences');
for c = 1:5
    if isnan(r2D_tbl(c)), fprintf(fid,' & ');
    else, fprintf(fid,' & %.2f', r2D_tbl(c));
    end
end
fprintf(fid,' \\\\\n');

% rho differences
fprintf(fid,'$\\rho(\\Delta, \\hat{\\Delta})$ -- $\\Delta$ Differences');
for c = 1:5
    if isnan(rhoD_tbl(c)), fprintf(fid,' & ');
    else, fprintf(fid,' & %.2f', rhoD_tbl(c));
    end
end
fprintf(fid,' \\\\\n');
fclose(fid);


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CPT / OPT MODELS  (Table G.1; Figures G1–G6, A5c, G3)
%   * (1) CPT – Parametric 1 (TK)   -> Table G.1(1), FigureG1
%   * (2) CPT – Parametric 2 (LBW)  -> Table G.1(2), FigureG2
%   * (3) CPT – Flexible            -> Table G.1(3), FigureA5c + FigureG3
%   * (4) OPT – Parametric 1 (TK)   -> Table G.1(4), FigureG4
%   * (5) OPT – Parametric 2 (LBW)  -> Table G.1(5), FigureG5
%   * (6) OPT – Flexible            -> Table G.1(6), FigureG6
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- CPT flexible cutoffs / init ---
cutoffs_CPT = [0.1, 0.3, 0.5, 0.7, 0.9];
gamma0      = [0,1,1,1,1,1,1];

% --- OPT flexible cutoffs (different) ---
cutoffs_OPT = [0.1, 0.3, 0.5, 0.7, 0.8];
 
% Define 6 model specs (columns 1..6)
models = struct([]);

% (1) CPT - Parametric 1 (TK)
models(1).family   = "CPT";
models(1).mode     = "param";
models(1).name     = "CPT_TK92";
models(1).title_txt= "\textbf{CPT Parametric Weighting (TK '92)}";
models(1).outfile1 = "figures/FigureG1.pdf";
models(1).outfile2 = "";
models(1).pi       = @(p,g) (p.^g) ./ (p.^g + (1-p).^g).^(1/g);
models(1).x0       = [0.8, 1];

% (2) CPT - Parametric 2 (LBW)
models(2).family   = "CPT";
models(2).mode     = "param";
models(2).name     = "CPT_LBW92";
models(2).title_txt= "\textbf{CPT Parametric Weighting (LBW '92)}";
models(2).outfile1 = "figures/FigureG2.pdf";
models(2).outfile2 = "";
models(2).pi       = @(p,g) (g(1).*(p.^g(2))) ./ ((g(1).*(p.^g(2))) + ((1-p).^g(2)));
models(2).x0       = [0.8, 1, 1];

% (3) CPT - Flexible
models(3).family   = "CPT";
models(3).mode     = "flex";
models(3).name     = "CPT_FLEX";
models(3).title_txt= "\textbf{CPT Flexible Weighting}";
models(3).outfile1 = "figures/FigureA5c.pdf";
models(3).outfile2 = "figures/FigureG3.pdf";
models(3).cutoffs  = cutoffs_CPT;
models(3).x0       = [gamma0, 1];

% (4) OPT - Parametric 1 (TK)
models(4).family   = "OPT";
models(4).mode     = "param";
models(4).name     = "OPT_TK92";
models(4).title_txt= "\textbf{OPT Parametric Weighting (TK '92)}";
models(4).outfile1 = "figures/FigureG4.pdf";
models(4).outfile2 = "";
models(4).pi       = @(p,g) (p.^g) ./ (p.^g + (1-p).^g).^(1/g);
models(4).x0       = [0.8, 1];

% (5) OPT - Parametric 2 (LBW)
models(5).family   = "OPT";
models(5).mode     = "param";
models(5).name     = "OPT_LBW92";
models(5).title_txt= "\textbf{OPT Parametric Weighting (LBW '92)}";
models(5).outfile1 = "figures/FigureG5.pdf";
models(5).outfile2 = "";
models(5).pi       = @(p,g) (g(1).*(p.^g(2))) ./ ((g(1).*(p.^g(2))) + ((1-p).^g(2)));
models(5).x0       = [0.8, 1, 1];

% (6) OPT - Flexible
models(6).family   = "OPT";
models(6).mode     = "flex";
models(6).name     = "OPT_FLEX";
models(6).title_txt= "\textbf{OPT Flexible Weighting}";
models(6).outfile1 = "figures/FigureG6.pdf";
models(6).outfile2 = "";
models(6).cutoffs  = cutoffs_OPT;
models(6).x0       = [gamma0, 1];

% =======================================================================
% Storage for Table G.1 (cols 1..6, theta_1..theta_7)
% =======================================================================
theta_tbl = NaN(7,6);   % theta_1..theta_7 (max)
se_tbl    = NaN(7,6);   % SEs for theta_1..theta_7
alpha_tbl = NaN(1,6);
alpha_se  = NaN(1,6);

obs_tbl   = NaN(1,6);
dof_tbl   = NaN(1,6);

mseH_tbl  = NaN(1,6);
r2H_tbl   = NaN(1,6);
rhoH_tbl  = NaN(1,6);

mseD_tbl  = NaN(1,6);
r2D_tbl   = NaN(1,6);
rhoD_tbl  = NaN(1,6);

% Main loop (estimate + plot + store table stats)
for m = 1:numel(models)

    % ---------- Estimation ----------
    if models(m).family == "CPT"
        if models(m).mode == "param"
            pi = models(m).pi;
            x0 = models(m).x0;

            [theta_hat, resnorm, residual, ~, ~, ~, J] = ...
                lsqnonlin(@(x) CPT(x,h,p,r,pi,type), x0, [], [], opts);

            gamma_hat = theta_hat(1:end-1);
            alpha_hat = theta_hat(end);
            pi_eval   = @(pp) pi(pp, gamma_hat);

        else % CPT flex
            cutoffs = models(m).cutoffs;
            x0      = models(m).x0;

            [theta_hat, resnorm, residual, ~, ~, ~, J] = ...
                lsqnonlin(@(x) CPT_flex(x,h,p,r,type,cutoffs), x0, [], [], opts);

            gamma_hat = theta_hat(1:end-1);
            alpha_hat = theta_hat(end);
            pi_eval   = @(pp) pi_flex(pp, gamma_hat, cutoffs);
        end

    else % OPT
        if models(m).mode == "param"
            pi = models(m).pi;
            x0 = models(m).x0;

            [theta_hat, resnorm, residual, ~, ~, ~, J] = ...
                lsqnonlin(@(x) OPT(x,h,p,r,pi,type), x0, [], [], opts);

            gamma_hat = theta_hat(1:end-1);
            alpha_hat = theta_hat(end);
            pi_eval   = @(pp) pi(pp, gamma_hat);

        else % OPT flex
            cutoffs = models(m).cutoffs;
            x0      = models(m).x0;

            [theta_hat, resnorm, residual, ~, ~, ~, J] = ...
                lsqnonlin(@(x) OPT_flex(x,h,p,r,type,cutoffs), x0, [], [], opts);

            gamma_hat = theta_hat(1:end-1);
            alpha_hat = theta_hat(end);
            pi_eval   = @(pp) pi_flex(pp, gamma_hat, cutoffs);
        end
    end

    % ---------- Compute SEs ----------
    n  = length(residual);
    df = length(theta_hat);
    sigma2 = resnorm / (n - df);
    cov_theta = sigma2 * ((J' * J) \ eye(df));
    SEs = sqrt(diag(cov_theta));

    % ---------- Predicted vs Actual ----------
    h_ab_hat = Ps*30 ./ (pi_eval(Ps)).^(1/alpha_hat);
    h_cd_hat = Ps*30 .* (pi_eval(Rs) ./ pi_eval(Ps.*Rs)).^(1/alpha_hat);

    if models(m).family == "CPT"
        h_ab_prime_hat = Ps*30 .* ((1 - pi_eval(Rs.*Ps + 1 - Rs) + pi_eval(Ps.*Rs)) ./ pi_eval(Ps.*Rs)).^(1/alpha_hat);
    else
        h_ab_prime_hat = Ps*30 .* ((1 - pi_eval(1 - Rs)) ./ pi_eval(Ps.*Rs)).^(1/alpha_hat);
    end

    Delta_CR_hat = h_ab_hat - h_cd_hat;
    Delta_CC_hat = h_ab_prime_hat - h_cd_hat;
    Delta_MX_hat = h_ab_hat - h_ab_prime_hat;

    % ---------- Fit stats ----------
    mseH = mean([(h_ab_hat-mean_h_ab).^2;(h_cd_hat-mean_h_cd).^2;(h_ab_prime_hat-mean_h_ab_prime).^2]);
    rssH = sum([(h_ab_hat-mean_h_ab);(h_cd_hat-mean_h_cd);(h_ab_prime_hat-mean_h_ab_prime)].^2);
    tssH = sum(([mean_h_ab;mean_h_cd;mean_h_ab_prime] - mean([mean_h_ab;mean_h_cd;mean_h_ab_prime])).^2);
    r2H  = 1 - (rssH/tssH);

    rhoH = corr([h_ab_hat;h_cd_hat;h_ab_prime_hat],[mean_h_ab;mean_h_cd;mean_h_ab_prime]);

    mseD = mean([(Delta_CR_hat-mean_Delta_CR).^2;(Delta_CC_hat-mean_Delta_CC).^2;(Delta_MX_hat-mean_Delta_MX).^2]);
    rssD = sum([(Delta_CR_hat-mean_Delta_CR);(Delta_CC_hat-mean_Delta_CC);(Delta_MX_hat-mean_Delta_MX)].^2);
    tssD = sum(([mean_Delta_CR;mean_Delta_CC;mean_Delta_MX] - mean([mean_Delta_CR;mean_Delta_CC;mean_Delta_MX])).^2);
    r2D  = 1 - (rssD/tssD);

    rhoD = corr([Delta_CR_hat;Delta_CC_hat;Delta_MX_hat],[mean_Delta_CR;mean_Delta_CC;mean_Delta_MX]);

    % ---------- Store Table G.1 columns ----------
    col = m;

    % alpha + SE
    alpha_tbl(col) = alpha_hat;
    alpha_se(col)  = SEs(end);

    % theta_1..theta_7 = gamma_hat entries (var length); store into 7x6
    for k = 1:min(7, numel(gamma_hat))
        theta_tbl(k,col) = gamma_hat(k);
        se_tbl(k,col)    = SEs(k);
    end

    % stats
    obs_tbl(col)  = n;
    dof_tbl(col)  = n - df;

    mseH_tbl(col) = mseH;
    r2H_tbl(col)  = r2H;
    rhoH_tbl(col) = rhoH;

    mseD_tbl(col) = mseD;
    r2D_tbl(col)  = r2D;
    rhoD_tbl(col) = rhoD;

    figure('Renderer','painters','Position',[10 10 1800 450])
    set(groot,'defaultAxesTickLabelInterpreter','latex');

    subplot(1,3,1); hold on
    if models(m).mode == "flex"
        xx = 0.005:0.001:0.995;
    else
        xx = 0:0.001:1;
    end
    plot(xx, pi_eval(xx), 'k-','LineWidth',1.5);
    plot(xx, xx, '--','Color',[0.5,0.5,0.5],'LineWidth',1.5);
    scatter(all_probs, pi_eval(all_probs),'filled','MarkerFaceColor',red,'MarkerFaceAlpha',0.55);

    if models(m).mode == "flex"
        cutoffs = models(m).cutoffs;
        scatter(cutoffs, pi_eval(cutoffs), [], 'k', 'filled')
        scatter([0,1], pi_eval([0.00001,0.999999]), [], 'k', 'LineWidth', 2)
        scatter([0,1], pi_eval([0,1]), [], 'k', 'filled', 'LineWidth', 2)
    end

    title(models(m).title_txt,'Interpreter','Latex');
    xlabel("Probability",'Interpreter','Latex'); xticks(0:0.1:1);
    ylabel("Probability Weight",'Interpreter','Latex');
    set(gca,'fontsize',14);
    text(0.72,0.2,['MSE: ',num2str(round(mseH,2))],'FontSize',14,'Interpreter','Latex')
    text(0.75,0.13,['$R^2$: ',num2str(round(r2H,2))],'FontSize',14,'Interpreter','Latex')
    axis("square"); hold off

    subplot(1,3,2); hold on
    plot(20:0.01:45,20:0.01:45,'--','Color',[0.7,0.7,0.7],'LineWidth',1.5);
    scatter(h_ab_hat,mean_h_ab,[],green,'filled','MarkerFaceAlpha',1)
    scatter(h_ab_prime_hat,mean_h_ab_prime,[],gold,'filled','MarkerFaceAlpha',1)
    scatter(h_cd_hat,mean_h_cd,[],navy,'filled','MarkerFaceAlpha',0.7)
    xlim([20,45]); ylim([20,45])
    xlabel("Predicted",'Interpreter','Latex'); ylabel("Actual",'Interpreter','Latex');
    title("\textbf{In-Sample Fit - Levels}",'Interpreter','Latex');
    text(37,23,['$\rho(h,\hat{h})$ = ',num2str(round(rhoH,2))],'FontSize',14,'Interpreter','Latex')
    set(gca,'fontsize',14);
    legend({'',"$h_{AB}$","$h_{AB'}$",'$h_{CD}$'},'Location','northwest','Interpreter','Latex');
    axis("square"); hold off

    subplot(1,3,3); hold on
    plot(-20:0.01:20,-20:0.01:20,'--','Color',[0.7,0.7,0.7],'LineWidth',1.5);
    scatter(Delta_CR_hat,mean_Delta_CR,[],red,'filled','MarkerFaceAlpha',1)
    scatter(Delta_CC_hat,mean_Delta_CC,[],ebblue,'filled','MarkerFaceAlpha',1)
    scatter(Delta_MX_hat,mean_Delta_MX,[],purple,'filled','MarkerFaceAlpha',0.7)
    xlim([-12,20]); ylim([-12,20])
    xlabel("Predicted",'Interpreter','Latex'); ylabel("Actual",'Interpreter','Latex');
    title("\textbf{In-Sample Fit - Differences}",'Interpreter','Latex');
    text(10,-8,['$\rho(\Delta,\hat{\Delta})$ = ',num2str(round(rhoD,2))],'FontSize',14,'Interpreter','Latex')
    set(gca,'fontsize',14);
    axis("square")
    legend({'','$\Delta_{CR}$',"$\Delta_{CC}$",'$\Delta_{MX}$'},'Location','northwest','Interpreter','Latex');
    hold off

    aa=subplot(132); aa.Position(1)=0.3825;
    aa=subplot(133); aa.Position(1)=0.635;

    exportgraphics(gcf, models(m).outfile1, 'Resolution', 300);
    if models(m).outfile2 ~= ""
        exportgraphics(gcf, models(m).outfile2, 'Resolution', 300);
    end
    close(gcf);

end


% ---------- Write Table G.1 (TeX) from stored arrays ----------

% Create tables directory if needed
texDir = fullfile(pwd,'tables');
if ~exist(texDir,'dir')
    [ok,msg] = mkdir(texDir);
    if ~ok
        error('Could not create tables directory: %s\nPath: %s', msg, texDir);
    end
end

texFile = fullfile(texDir,'TableG1.tex');
[fid,errmsg] = fopen(char(texFile),'w');
if fid == -1
    error('Could not open %s for writing.\nReason: %s', texFile, errmsg);
end

% Header spacer rows
fprintf(fid,'& & & & & & \\\\\n');
fprintf(fid,'Utility Curvature & & & & & & \\\\\n');

% alpha row
fprintf(fid,'\\quad $\\alpha$');
for c = 1:6
    if isnan(alpha_tbl(c))
        fprintf(fid,' & ');
    else
        fprintf(fid,' & $%.2f$', alpha_tbl(c));
    end
end
fprintf(fid,' \\\\\n');

% alpha SE row
fprintf(fid,' ');
for c = 1:6
    if isnan(alpha_se(c))
        fprintf(fid,' & ');
    else
        fprintf(fid,' & $(%.2f)$', alpha_se(c));
    end
end
fprintf(fid,' \\\\\n');

fprintf(fid,'& & & & & & \\\\\n');
fprintf(fid,'Weighting Parameters & & & & & & \\\\\n');

% theta_1..theta_7 (with SE rows)
for i = 1:7
    fprintf(fid,'\\quad $\\theta_%d$', i);
    for c = 1:6
        if isnan(theta_tbl(i,c))
            fprintf(fid,' & ');
        else
            fprintf(fid,' & $%.2f$', theta_tbl(i,c));
        end
    end
    fprintf(fid,' \\\\\n');

    fprintf(fid,' ');
    for c = 1:6
        if isnan(se_tbl(i,c))
            fprintf(fid,' & ');
        else
            fprintf(fid,' & $(%.2f)$', se_tbl(i,c));
        end
    end
    fprintf(fid,' \\\\\n');
end

fprintf(fid,'& & & & & & \\\\\n');

% Observations
fprintf(fid,'Observations');
for c = 1:6
    if isnan(obs_tbl(c))
        fprintf(fid,' & ');
    else
        fprintf(fid,' & $%.0f$', obs_tbl(c));
    end
end
fprintf(fid,' \\\\\n');

% Degrees of Freedom
fprintf(fid,'Degrees of Freedom');
for c = 1:6
    if isnan(dof_tbl(c))
        fprintf(fid,' & ');
    else
        fprintf(fid,' & $%.0f$', dof_tbl(c));
    end
end
fprintf(fid,' \\\\\n');

% hXY-MSE
fprintf(fid,'$h_{XY}$-MSE');
for c = 1:6
    if isnan(mseH_tbl(c))
        fprintf(fid,' & ');
    else
        fprintf(fid,' & $%.2f$', mseH_tbl(c));
    end
end
fprintf(fid,' \\\\\n');

% hXY-R2
fprintf(fid,'$h_{XY}$-$R^2$');
for c = 1:6
    if isnan(r2H_tbl(c))
        fprintf(fid,' & ');
    else
        fprintf(fid,' & $%.2f$', r2H_tbl(c));
    end
end
fprintf(fid,' \\\\\n');

% rho levels
fprintf(fid,'$\\rho(h_{XY}, \\hat{h}_{XY})$');
for c = 1:6
    if isnan(rhoH_tbl(c))
        fprintf(fid,' & ');
    else
        fprintf(fid,' & $%.2f$', rhoH_tbl(c));
    end
end
fprintf(fid,' \\\\\n');

% Delta-MSE
fprintf(fid,'$\\Delta$-MSE');
for c = 1:6
    if isnan(mseD_tbl(c))
        fprintf(fid,' & ');
    else
        fprintf(fid,' & $%.2f$', mseD_tbl(c));
    end
end
fprintf(fid,' \\\\\n');

% Delta-R2
fprintf(fid,'$\\Delta$-$R^2$');
for c = 1:6
    if isnan(r2D_tbl(c))
        fprintf(fid,' & ');
    else
        fprintf(fid,' & $%.2f$', r2D_tbl(c));
    end
end
fprintf(fid,' \\\\\n');

% rho diffs
fprintf(fid,'$\\rho(\\Delta, \\hat{\\Delta})$');
for c = 1:6
    if isnan(rhoD_tbl(c))
        fprintf(fid,' & ');
    else
        fprintf(fid,' & $%.2f$', rhoD_tbl(c));
    end
end
fprintf(fid,' \\\\\n');
fclose(fid);
