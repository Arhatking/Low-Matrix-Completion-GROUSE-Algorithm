clear

% choose simulation parameters
M = 700;  % number of rows (taken from paper)
N = 700;  % number of columns (taken from paper)
r =  10;  % true rank
eta0 = 0.1;

% true data matrix
Xtrue = randn(M,r)*randn(r,N);

% create mask to sample sampProb percent of entries
samp_prob_range = [0.1:0.2:0.9];
for ii = 1:length(samp_prob_range)
    samp_prob = samp_prob_range(ii);
    mask = rand(M,N) < samp_prob;
    X = Xtrue.*mask;    % observed data

    Xhat = lrmc_grouse(X, mask, r, eta0);
    esterr(ii) = norm(Xhat-Xtrue,'fro')/norm(Xtrue,'fro')
end

%%
figure('Position', [100, 100, 800, 400]);
semilogy(samp_prob_range, esterr, 'o-', 'LineWidth', 2);
grid('on');
set(gca, 'FontSize', 12);
xlabel('Sample reveal probability', 'Interpreter', 'LaTeX', 'FontSize', 14);
ylabel('Estimation Error $\left( \frac{||\hat{X}-X||_F}{||X||_F}\right)$', 'Interpreter', 'LaTeX', 'FontSize', 14);
saveas(gcf, 'synthetic_esterr_vs_sampling_probability.eps', 'epsc');
