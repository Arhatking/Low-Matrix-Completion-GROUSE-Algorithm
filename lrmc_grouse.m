function Xhat = lrmc_grouse(X, mask, r, eta0, niter)
% GROUSE algorithm for matrix completion
% 
% Syntax:       Xhat = lrmc_grouse(X,mask,r)
%
% Inputs:       X is a matrix of size (M x N)
%               mask is a logical-valued matrix of sampling locations of size (M x N)
%               r is the rank of completed matrix
%               eta0 is the initial step-size
%               niter is the number of times to go over the matrix
%
% Outputs:      Xhat is a completed estimate of X of size (M x N)

%% assign default values to parameters

h_wb = waitbar(0, 'Starting', 'Name', 'GROUSE LRMC');

% number of passes through the given matrix
if ~exist('niter', 'var')
    niter = 16; 
end

% initial step size
if ~exist('eta0', 'var')
    eta0 = 1; 
end


%% initializations
[M,N] = size(X);

% make sure that the data is tall, i.e. M > N
do_transpose = M < N;
if do_transpose
    X = X';
    mask = mask';
    [M, N] = deal(N, M); % swap M and N
end

% initialize the basis to a random orthonormal set
[U, ~, ~] = svds(rand(M,r), r);

kk = 1; % step counter

%% GROUSE algorithm steps
for ii = 1:niter % make multiple passes over the data
    waitbar(ii/niter, h_wb, sprintf('Iteration %d of %d', ii, niter));
    
    % choose a sequence in which to process the columns of the matrix
    colseq = randperm(N);
    
    % process one column at a tume
    for jj = 1:N
        col = colseq(jj); % the column to be processed
        rows = find(mask(:,col)); 

        % Estimate weights: w = \argmin_a \norm(\Delta_\Omega_t (U_t a - v_t))^2
        v = X(:, col);
        U_Omega = U(rows, :);
        v_Omega = v(rows);
        w = U_Omega\v_Omega;
        
        % Predict full vector: p = U_t w
        p = U*w;
        
        % Compute residual: r = \Delta_\Omega_t (vt - p)
        p_Omega = p(rows);
        r_Omega = v_Omega - p_Omega;
        r = zeros(M, 1);
        r(rows) = r_Omega;
        
        % Update subspace: U_{t+1} = U_t + \left((cos(\sigma \eta_t) - 1)
        % p/norm(p) + sin(\sigma \eta_t) r / norm(r)\right) w^T / norm(w),
        % where \sigma = \norm(r) \norm(p)
        sigma = norm(r) * norm(p);
        eta_t = eta0 / kk;
        U = U + ( (cos(sigma*eta_t)-1)*p/norm(p) + sin(sigma*eta_t)*r/norm(r) ) * w' / norm(w);
        kk = kk + 1;
    end
end

% project the input on the low-rank basis
Xhat = nan(size(X));
for jj = 1:N
    rows = find(mask(:,jj));
    v = X(:, jj);
    U_Omega = U(rows, :);
    v_Omega = v(rows);
    w = U_Omega\v_Omega;
    Xhat(:,jj) = U * w;
end

% untranspose the data if it was trasnposed at the beginning
if do_transpose
    Xhat = Xhat';
end

close(h_wb);

