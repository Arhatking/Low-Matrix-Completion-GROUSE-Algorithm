%% movielens: fit error vs rank
data = [
    1.0000    0.8511    0.8438    0.9216
    2.0000    0.7601    0.7417    0.8772
    3.0000    0.7142    0.6962    0.8920
    4.0000    0.6846    0.6578    0.9026
    5.0000    0.6526    0.6223    0.9232
    6.0000    0.6199    0.5864    0.9304
    7.0000    0.5908    0.5600    0.9445
    9.0000    0.5438    0.4997    0.9749
   11.0000    0.4987    0.4518    1.0106
   13.0000    0.4583    0.4072    1.0348
   15.0000    0.4252    0.3692    1.0606
   19.0000    0.3643    0.3037    1.0962
   22.0000    0.3231    0.2609    1.1245
   27.0000    0.2633    0.2048    1.1604
   32.0000    0.2193    0.1632    1.1951
   39.0000    0.1657    0.1175    1.2299
   46.0000    0.1309    0.0862    1.2532
   56.0000    0.0939    0.0516    1.2589
   67.0000    0.0642    0.0352    1.2847
   80.0000    0.0439    0.0219    1.2986
   96.0000    0.0295    0.0149    1.3312
  116.0000    0.0194    0.0103    1.3705
  139.0000    0.0106    0.0067    1.3936
  167.0000    0.0079    0.0051    1.4201
  200.0000    0.0047    0.0042    1.4694
];

figure('Position', [100, 100, 800, 400]);
plot(data(:,1), data(:, 2), 'LineWidth', 2);
grid('on');
set(gca, 'FontSize', 12);
xlabel('Rank of completed matrix', 'Interpreter', 'LaTeX', 'FontSize', 13);
ylabel('Estimation Error $\left( \frac{||\Delta_\Omega \hat{X} - \Delta_\Omega X||_F}{||\Delta_\Omega  X||_F}\right)$', 'Interpreter', 'LaTeX', 'FontSize', 13);
saveas(gcf, 'movielens_esterr_vs_estimation_rank.eps', 'epsc');


figure('Position', [100, 100, 800, 400]);
plot(data(:,1), data(:, 3:4), 'LineWidth', 2);
grid('on');
set(gca, 'FontSize', 12);
xlabel('Rank of completed matrix', 'Interpreter', 'LaTeX', 'FontSize', 13);
ylabel('Estimation Error $\left( \frac{||\Delta_\Omega \hat{X} - \Delta_\Omega X||_F}{||\Delta_\Omega X||_F}\right)$', 'Interpreter', 'LaTeX', 'FontSize', 13);
legend({'Training set', 'Test set'}, 'Interpreter', 'LaTeX', 'FontSize', 13, 'Location', 'Best');
saveas(gcf, 'movielens_esterr_and_predictionerr_vs_estimation_rank.eps', 'epsc');


%% OLD DATA
% % movielens: fit error vs rank
% r_range = max(1, (0:5:100));
% estErrAll = [
%     0.3503
%     0.2336
%     0.1824
%     0.1661
%     0.1463
%     0.1387
%     0.1282
%     0.1219
%     0.1146
%     0.1147
%     0.1043
%     0.1006
%     0.0979
%     0.0918
%     0.0886
%     0.0854
%     0.0811
%     0.0771
%     0.0760
%     0.0724
%     0.0690
%     ];
% figure; 
% plot(r_range, estErrAll, 'o-', 'LineWidth', 2); 
% ylim([0, .5])
% xlabel('Rank of the low-rank Matrix');
% ylabel('Mormalized fit-error');
