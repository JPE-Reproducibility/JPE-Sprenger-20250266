## Filepaths Analysis Details

**/var/folders/5q/yhcyv3z55wvg6lhgc3h22kk00000gq/T/20250266-2/replication-package/replication_filesv2/stata/mainS.do**

- Line 8, unix : Last edited: 01/19/2026

**/var/folders/5q/yhcyv3z55wvg6lhgc3h22kk00000gq/T/20250266-2/replication-package/replication_filesv2/stata/clean_data.do**

- Line 3, unix : Last edited: 01/08/26
- Line 485, unix : replace p=p/100
- Line 486, unix : replace r=r/100

**/var/folders/5q/yhcyv3z55wvg6lhgc3h22kk00000gq/T/20250266-2/replication-package/replication_filesv2/stata/makeAppendixTables.do**

- Line 3, unix : Last edited: 01/18/2026
- Line 39, unix : replace  timetaken=timetaken/60
- Line 46, unix : forvalues j = 1/4 {
- Line 159, unix : replace p_condition = p_condition/100
- Line 160, unix : replace r_condition = r_condition/100

**/var/folders/5q/yhcyv3z55wvg6lhgc3h22kk00000gq/T/20250266-2/replication-package/replication_filesv2/R/functions.R**

- Line 168, unix : var_CRP/var_CRE_hat, var_CCP/var_CCE_hat, var_MXP/var_MXE_hat),2)
- Line 249, unix : var_CRP/var_CRE_hat, var_CCP/var_CCE_hat, var_MXP/var_MXE_hat),2)
- Line 521, unix : #### Data/Preference Component
- Line 528, unix : #### Data/Preference Component with repeats

**/var/folders/5q/yhcyv3z55wvg6lhgc3h22kk00000gq/T/20250266-2/replication-package/replication_filesv2/matlab/makeFigure9.m**

- Line 3, unix : % Last edited: 01/16/2026
- Line 39, unix : linearIC_anchor = [3/4, 0];  % known from case I1 parameters
- Line 87, unix : 1/4,   0;
- Line 88, unix : 1/2,   0;
- Line 89, unix : 3/4,   0;
- Line 90, unix : 9/10,  0;
- Line 91, unix : 0,     1/4;
- Line 92, unix : 0,     1/2;
- Line 93, unix : 0,     3/4;
- Line 94, unix : 0,     9/10];
- Line 146, unix : exportgraphics(gcf, sprintf('figures/Figure9%s.pdf', panels{z}));

**/var/folders/5q/yhcyv3z55wvg6lhgc3h22kk00000gq/T/20250266-2/replication-package/replication_filesv2/stata/makeFigures3-7.do**

- Line 3, unix : Last edited: 01/18/2026

**/var/folders/5q/yhcyv3z55wvg6lhgc3h22kk00000gq/T/20250266-2/replication-package/replication_filesv2/matlab/makeFigureE1.m**

- Line 3, unix : % Last edited: 01/16/2026
- Line 49, windows : text(65,35, '$q^2\kappa(X)$', 'Interpreter','latex', 'Color','k','fontsize', 14);
- Line 65, unix : exportgraphics(gcf,'figures/FigureE1.pdf');

**/var/folders/5q/yhcyv3z55wvg6lhgc3h22kk00000gq/T/20250266-2/replication-package/replication_filesv2/stata/statsInText.do**

- Line 3, unix : Last edited: 01/18/2026
- Line 16, unix : I) Page 33 : Risk tolerance/aversion and Proposition 2 pattern predictions

**/var/folders/5q/yhcyv3z55wvg6lhgc3h22kk00000gq/T/20250266-2/replication-package/replication_filesv2/R/mainR.R**

- Line 88, windows : "main.R finished.\nStart: %s\nEnd:   %s\nElapsed: %.2f seconds (%.2f minutes)\n",

**/var/folders/5q/yhcyv3z55wvg6lhgc3h22kk00000gq/T/20250266-2/replication-package/replication_filesv2/matlab/makeFigure1.m**

- Line 3, unix : % Last edited: 01/16/2026
- Line 82, unix : exportgraphics(gcf,'figures/Figure1a.pdf')
- Line 88, unix : Data = readtable(dir+'/cleaned-data/ExperimentData.csv');
- Line 133, unix : exportgraphics(gcf,'figures/Figure1b.pdf')

**/var/folders/5q/yhcyv3z55wvg6lhgc3h22kk00000gq/T/20250266-2/replication-package/replication_filesv2/stata/makeTable2.do**

- Line 3, unix : Last edited: 01/18/2026

**/var/folders/5q/yhcyv3z55wvg6lhgc3h22kk00000gq/T/20250266-2/replication-package/replication_filesv2/matlab/structuralEstimates.m**

- Line 3, unix : % Last edited: 01/17/2026
- Line 10, unix : addpath(dir+'/matlab/functions')
- Line 27, unix : Data = readtable(dir+'/cleaned-data/part1_cleaned.csv');
- Line 261, unix : r2_levels  = 1 - (rss_levels/tss_levels);
- Line 267, unix : r2_differences   = 1 - (rss_differences/tss_differences);
- Line 285, unix : % Figure 8(A/B) - only for flex1 and param1
- Line 313, unix : exportgraphics(gcf,'figures/Figure8a.pdf','Resolution',300)
- Line 315, unix : exportgraphics(gcf,'figures/Figure8b.pdf','Resolution',300)
- Line 350, unix : exportFiles = {'figures/FigureA5a.pdf','figures/FigureF2.pdf'};
- Line 352, unix : exportFiles = {'figures/FigureA5b.pdf','figures/FigureF3.pdf'};
- Line 354, unix : exportFiles = {'figures/FigureF1.pdf'};
- Line 431, windows : error('Could not create tables directory: %s\nPath: %s', msg, texDir);
- Line 569, unix : models(1).pi       = @(p,g) (p.^g) ./ (p.^g + (1-p).^g).^(1/g);
- Line 599, unix : models(4).pi       = @(p,g) (p.^g) ./ (p.^g + (1-p).^g).^(1/g);
- Line 719, unix : r2H  = 1 - (rssH/tssH);
- Line 726, unix : r2D  = 1 - (rssD/tssD);
- Line 829, windows : error('Could not create tables directory: %s\nPath: %s', msg, texDir);

**/var/folders/5q/yhcyv3z55wvg6lhgc3h22kk00000gq/T/20250266-2/replication-package/replication_filesv2/stata/makeAppendixFigures.do**

- Line 3, unix : Last edited: 01/18/2026

