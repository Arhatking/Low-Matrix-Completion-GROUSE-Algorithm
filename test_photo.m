clear

load('cameraman.mat');

%%
Xtrue = X;
[M, N] = size(Xtrue);
r = 40;

% create mask to sample sampProb percent of entries
sampProb = 0.5;
mask = rand(M,N) < sampProb;
X = Xtrue.*mask + (1-mask).*rand(M,N);    % observed data

Xhat = lrmc_grouse(X, mask, r, 0.1);
Xhat = real(Xhat);
estErr = norm(Xhat-Xtrue,'fro')/norm(Xtrue,'fro')    % estimation error

%%
figure('Position', [100, 100, 800, 210]);
subplot(1,3,1);
imagesc(Xtrue);
colormap('gray');
axis equal
xlabel('Original Image', 'Interpreter', 'Latex', 'FontSize', 14);
xticks([]); yticks([]);
subplot(1,3,2);
imagesc(X);
colormap('gray');
xlabel('Corrupted Image', 'Interpreter', 'Latex', 'FontSize', 14);
axis equal
xticks([]); yticks([]);
subplot(1,3,3);
imagesc(Xhat);
colormap('gray');
xlabel(sprintf('Recovered Image (rank = %d)', r), 'Interpreter', 'Latex', 'FontSize', 14);
axis equal
xticks([]); yticks([]);
saveas(gcf, 'image_recovery_cameraman.eps', 'epsc');
