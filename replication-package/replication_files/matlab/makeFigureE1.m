%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose: Makes Figure E.1 from the Online Appendix			   	                                     
% Last edited: 01/16/2026 		                                              
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; close all;
dir = "..."; %Set directory
cd(dir)

% Parameters
kappa100 = 100;
qvals = (0:100)/100;
x = 0:100;

% Kappa Function 
kappa =  @(z,rho)(rho(1)*(1./(1+exp((-rho(2))*(z-rho(3))))));

% Compute the primary curve using parameters: rho1=100, rho2=0.1, rho3=60.
y1 = kappa(x, [100, 0.1, 60]);

% Compute quadvals curve
kappaX = kappa(100, [100, 0.1, 60]);  % This is a constant
quadvals = qvals.^2 * kappaX;

% Create figure with 6x6 inch dimensions
figure('Units','inches','Position',[1 1 7 7]);
hold on;

% Plot the kappa function (solid black line)
plot(x, y1, 'k-', 'LineWidth', 1.5);

% Plot the quadratic weighted curve (dashed black line)
plot(x, quadvals, 'k--', 'LineWidth', 1);

% Set axis limits
xlim([0 100]);
ylim([0 150]);

% Add vertical and horizontal gray dashed lines
plot([48 48], [0 150], 'Color', [0.5 0.5 0.5], 'LineStyle', '--');
plot([0 100], [98 98], 'Color', [0.5 0.5 0.5], 'LineStyle', '--');

% Add text annotations using LaTeX for mathematical expressions
text(12,130, '$\kappa(qX) < q^2\kappa(X)$', 'Interpreter','latex', 'Color','k','fontsize', 14);
text(12,120, '$ \Rightarrow \; \; \; C > qX$', 'Interpreter','latex', 'Color','k','fontsize', 14);
text(62,130, '$\kappa(qX) > q^2\kappa(X)$', 'Interpreter','latex', 'Color','k','fontsize', 14);
text(62,120, '$\Rightarrow \; \; C < qX$', 'Interpreter','latex', 'Color','k','fontsize', 14);
text(65,85, '$\kappa(qX)$', 'Interpreter','latex', 'Color','k','fontsize', 14);
text(65,35, '$q^2\kappa(X)$', 'Interpreter','latex', 'Color','k','fontsize', 14);

% Customize the x-axis: set ticks at 0, 48, and 100 with custom labels
set(gca, 'XTick', [0 48 100]);
set(gca, 'XTickLabel', {'0', '$\bar{q}$', '1'}, 'TickLabelInterpreter', 'latex');
xlabel('$q$', 'Interpreter','latex');

% Customize the y-axis: tick at 98 with a custom label
set(gca, 'YTick', 98);
set(gca, 'YTickLabel', {'$\kappa(X)$'}, 'TickLabelInterpreter', 'latex');
set(gca,'fontsize', 14);

box on;
hold off;

% Save the figure as a PDF 
exportgraphics(gcf,'figures/FigureE1.pdf');
close all;