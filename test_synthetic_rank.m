clear

% choose simulation parameters
M = 700;  % number of rows (taken from paper)
N = 700;  % number of columns (taken from paper)
r =  10;  % rank of the true matrix
samp_prob =  0.17;  % sampling probability (taken from paper)

eta0 = 0.1;

% true data matrix
Xtrue = randn(M,r)*randn(r,N);
mask = rand(M,N) < samp_prob;
X = Xtrue.*mask;    % observed data

% create mask to sample sampProb percent of entries
r_range = [5:15];
for ii = 1:length(r_range)
    Xhat = lrmc_grouse(X, mask, r_range(ii), eta0);
    esterr(ii) = norm(Xhat-Xtrue,'fro')/norm(Xtrue,'fro')
end

%%
figure('Position', [100, 100, 800, 400]);
semilogy(r_range, esterr, 'o-', 'LineWidth', 2);
grid('on');
set(gca, 'FontSize', 12);
xlabel({'Rank of estimated matrix', '(True rank = 10)'}, 'Interpreter', 'LaTeX', 'FontSize', 14);
ylabel('Estimation Error $\left( \frac{||\hat{X}-X||_F}{||X||_F}\right)$', 'Interpreter', 'LaTeX', 'FontSize', 14);
saveas(gcf, 'synthetic_esterr_vs_estimation_rank.eps', 'epsc');
