%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose: Makes Figure 1 from the main text				   	                                     
% Last edited: 01/16/2026 		                                              
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; close all;
dir = "/Users/jasonsomerville/Desktop/CRP CCP BP/replication_files"; %Set directory
cd(dir)
blue=[0,114,178]./255;
red=[178,34,34]./255;
grey=[100,100,100]./255;
white=[255,255,255]./255;

%% Panel A -- MM Triangle
p1=0:0.01:1;
p = 0.6;
r = 0.4;               % Common Ratio 

% Plot 
set(groot,'defaultAxesTickLabelInterpreter','latex');  
figure('Units','inches','Position',[1 1 7 7]);
hold on

% Add connecting lines
slope = (1-p)/p;

% A -> B
p3 = slope*p1;
include=(p1+p3<=1);
plot(p3(include),p1(include),'--','Color',grey,'LineWidth',1)

% C -> D
p3 = slope*p1+(1-r);
include=(p1+p3<=1);
plot(p3(include),p1(include),'--','Color',grey,'LineWidth',1.5)


% Add triangle
plot(p1,1-p1,'k-','LineWidth',2)
plot(zeros(size(p1)),p1,'k-','LineWidth',2)
plot(p1,zeros(size(p1)),'k-','LineWidth',2)


% Add points 

% A 
scatter(0,0,80,grey,'filled') 
scatter(0,0,80,grey,'LineWidth',2) 
text(0.02,0+0.02,'$A$','Color','k','Fontsize', 15,'Interpreter','latex')

% B'
scatter(r*(1-p),r*p,80,grey,'filled')
scatter(r*(1-p),r*p,80,grey,'LineWidth',2)
text((1-p)*r+0.02,r*p+0.02,'$B^\prime$','Color','k','Fontsize', 15,'Interpreter','latex')

% B
scatter(1-p,p,80,grey,'filled')
scatter(1-p,p,80,grey,'LineWidth',2)
text(1-p+0.02,p+0.02,'$B$','Color','k','Fontsize', 15,'Interpreter','latex')

% C
scatter(1-r,0,80,grey,'filled')
scatter(1-r,0,80,grey,'LineWidth',2)
text(1-r+0.02,0.02,'$C$','Color','k','Fontsize', 15,'Interpreter','latex')

% D
scatter(1-r*p,r*p,80,grey,'filled')
scatter(1-r*p,r*p,80,grey,'LineWidth',2)
text(1-r*p+0.02,r*p+0.02,'$D$','Color','k','Fontsize', 15,'Interpreter','latex')


% Format and label
xlim([0,1]); ylim([0,1])
xlabel('$q_L$','Interpreter','latex')
ylabel('$q_H$','Interpreter','latex')
set(gca,'fontsize', 14);
xticks(1-r)
xticklabels({'$1 - r$'})
yticks([p*r,p])
yticklabels({'$pr$','$p$'})
axis('square')
exportgraphics(gcf,'figures/Figure1a.pdf')


%% Panel B -- Prior Litertature Data

% Import the data
Data = readtable(dir+'/cleaned-data/ExperimentData.csv');
Data(Data.MXtest==1,:)=[]; % Drop MX tests

% Collapse to p,r, study, prior lit level
D=unique([Data.p,Data.r,Data.CCtest,Data.prior_lit],'rows');
N = zeros(size(D,1),1);
for j = 1:size(N,1)
    N(j)=sum(Data.N(all([Data.p,Data.r,Data.CCtest,Data.prior_lit] == D(j,:),2)));
end

% Plot
p = D(:,1);
r = D(:,2);
cce_study = D(:,3);
prior_lit = D(:,4);

% For consistent sizing of dots
D= [D;[ones(6,1)*1.1,ones(6,1)*1.1,repmat([0;1],[3,1]),[0,0,0,0,1,1]']];
N=[N;repmat([max(N);min(N)],[3,1])];

% Plot
set(groot,'defaultAxesTickLabelInterpreter','latex');  
figure('Units','inches','Position',[1 1 7.6 7.6]);
hold on
scatter(r(cce_study==0 & prior_lit==1),p(cce_study==0 & prior_lit==1),N(cce_study==0 & prior_lit==1),'filled','MarkerFaceColor',red,'MarkerEdgeColor',red,'MarkerFaceAlpha',0.4,'MarkerEdgeAlpha',0.8,'LineWidth',1.5)
scatter(r(cce_study==1 & prior_lit==1),p(cce_study==1 & prior_lit==1),N(cce_study==1 & prior_lit==1),'filled','MarkerFaceColor',blue,'MarkerEdgeColor',blue,'MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.8,'LineWidth',1.5)
scatter(r(prior_lit==0),p(prior_lit==0),N(prior_lit==0),'MarkerEdgeColor','k','MarkerEdgeAlpha',0.8,'LineWidth',1.5)
scatter([0.62,0.74,0.93,1.1,1.1]',ones(5,1)*0.09,[100,500,2500,min(N),max(N)]','filled','MarkerFaceColor',grey,'MarkerEdgeColor',grey,'MarkerFaceAlpha',.3,'MarkerEdgeAlpha',.8,'LineWidth',1.5)

% Add scaling legend
text(0.5,0.09,"$N$:",'Interpreter','latex','fontsize', 12)
text(0.785,0.09,"2,500",'Interpreter','latex','fontsize', 12)
text(0.655,0.09,"500",'Interpreter','latex','fontsize', 12)
text(0.55,0.09,"100",'Interpreter','latex','fontsize', 12)
rectangle('Position',[0.48 0 0.52 .18],'LineWidth',1)

xlim([-0.02 1.02]); ylim([-0.02 1.02]);
set(gca,'fontsize', 14);
xticks(0:0.1:1)

xlabel('$r$','Interpreter','latex')
ylabel('$p$','Interpreter','latex')
lgd=legend({'CR Study','CC Study'},'Location','southoutside','NumColumns',3,'FontSize',14,'Interpreter','latex');
axis('square')
hold off
exportgraphics(gcf,'figures/Figure1b.pdf')

