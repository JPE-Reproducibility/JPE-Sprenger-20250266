## Potentially Hardcoded Numeric Constants


We found the following set of hard coded numbers. This may be completely legitimate (parameter input, thresholds for computations, etc), and is hence only for information.

**/var/folders/5q/yhcyv3z55wvg6lhgc3h22kk00000gq/T/20250266-1/replication-package/replication_files/stata/statsInText.do**

- Line 207, : 5) "Risk aversion significantly correlated with CR preferences ... Fisher p<0.001"
- Line 208, : 6) "we find that for risk tolerant observations ... 48% exhibit P1 ... while 21% of risk averse observations exhibit P1 ... (p < 0.001)"
- Line 210, : P2, P3, or P4 ... (p < 0.001)"

**/var/folders/5q/yhcyv3z55wvg6lhgc3h22kk00000gq/T/20250266-1/replication-package/replication_files/matlab/makeFigure1.m**

- Line 119, : text(0.785,0.09,"2,500",'Interpreter','latex','fontsize', 12)
- Line 120, : text(0.655,0.09,"500",'Interpreter','latex','fontsize', 12)

**/var/folders/5q/yhcyv3z55wvg6lhgc3h22kk00000gq/T/20250266-1/replication-package/replication_files/stata/makeAppendixFigures.do**

- Line 55, : twoway (hist pattern, start(1) width(0.999) freq lalign(center) fcolor(white%0)) ///
- Line 56, : (hist pattern if inlist(pattern,1,14,27), start(1) width(0.999) freq  lalign(center) fcolor(green%30)) ///
- Line 57, : (hist pattern if inlist(pattern,19), start(1) width(0.999) freq  lalign(center) fcolor(grey%20)), ///
- Line 108, : twoway (hist pattern, start(1) width(0.999) freq lalign(center) fcolor(white%0)) ///
- Line 109, : (hist pattern if inlist(pattern,1,14,27), start(1) width(0.999) freq  lalign(center) fcolor(green%30)) ///
- Line 110, : (hist pattern if inlist(pattern,19), start(1) width(0.999) freq  lalign(center) fcolor(grey%20)), ///
- Line 157, : twoway (hist pattern, start(1) width(0.999) freq lalign(center) fcolor(white%0)) ///
- Line 158, : (hist pattern if inlist(pattern,1,14,27), start(1) width(0.999) freq  lalign(center) fcolor(green%30)) ///
- Line 159, : (hist pattern if inlist(pattern,19), start(1) width(0.999) freq  lalign(center) fcolor(grey%20)), ///

**/var/folders/5q/yhcyv3z55wvg6lhgc3h22kk00000gq/T/20250266-1/replication-package/replication_files/stata/makeAppendixTables.do**

- Line 132, : if (`r(p)' < 0.05 &  ((`r(p_u)'< 0.025 & `mu_diff'>0) | (`r(p_l)'< 0.025 & `mu_diff'<0))){
- Line 136, : else if (`r(p)' < 0.05 & ((`r(p_u)'< 0.025 & `mu_diff'<0) | (`r(p_l)'< 0.025 & `mu_diff'>0))){

**/var/folders/5q/yhcyv3z55wvg6lhgc3h22kk00000gq/T/20250266-1/replication-package/replication_files/matlab/makeFigure9.m**

- Line 31, : M = 15; k_M = 35; k_H = 125; H = 22.152; p = 0.55;    % I5 - Quasi-concave, fanning-out left, fanning-in right
- Line 66, : A,  red,    '$A$',       -0.045,  0.030
- Line 67, : B,  blue,   '$B$',       -0.020,  0.030
- Line 68, : Bp, purple, '$B^\prime$',-0.045,  0.020
- Line 69, : C,  green,  '$C$',       -0.030,  0.030
- Line 70, : D,  gold,   '$D$',       -0.015,  0.030
- Line 71, : E,  navy,   '$E$',       -0.030,  0.030
- Line 72, : F,  orange, '$F$',       -0.015,  0.030

**/var/folders/5q/yhcyv3z55wvg6lhgc3h22kk00000gq/T/20250266-1/replication-package/replication_files/matlab/structuralEstimates.m**

- Line 127, : UPspec(4).x0       = [1.0, 0.20, 0.024, 0.010];
- Line 415, : aa=subplot(132); aa.Position(1)=0.3825;
- Line 416, : aa=subplot(133); aa.Position(1)=0.635;
- Line 760, : xx = 0.005:0.001:0.995;
- Line 762, : xx = 0:0.001:1;
- Line 771, : scatter([0,1], pi_eval([0.00001,0.999999]), [], 'k', 'LineWidth', 2)
- Line 810, : aa=subplot(132); aa.Position(1)=0.3825;
- Line 811, : aa=subplot(133); aa.Position(1)=0.635;

**/var/folders/5q/yhcyv3z55wvg6lhgc3h22kk00000gq/T/20250266-1/replication-package/replication_files/stata/makeFigures3-7.do**

- Line 132, : twoway (hist pattern, start(1) width(0.999) freq lalign(center) fcolor(white%0)) ///
- Line 133, : (hist pattern if inlist(pattern,1,14,27), start(1) width(0.999) freq  lalign(center) fcolor(green%30)) ///
- Line 134, : (hist pattern if inlist(pattern,19), start(1) width(0.999) freq  lalign(center) fcolor(grey%20)), ///
- Line 147, : twoway (hist pattern, start(1) width(0.999) freq lalign(center) fcolor(white%0)) ///
- Line 148, : (hist pattern if inlist(pattern,5,6,9,10,15,16,18,20,22,23,28,29,32,33), start(1) width(0.999) freq  lalign(center) fcolor(gray%25)) ///
- Line 149, : (hist pattern if inlist(pattern,1,3,11,27), start(1) width(0.999) freq  lalign(center) fcolor(ebblue%80)) ///
- Line 150, : (hist pattern if inlist(pattern,19), start(1) width(0.999) freq  lalign(center) fcolor(grey%50)) ///
- Line 151, : (hist pattern if inlist(pattern,2,7,14), start(1) width(0.999) freq  lalign(center) fcolor(ebblue%35)), ///

