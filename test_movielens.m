clear;

%% import movielens ratings
mldata = importdata('ml-latest-small\ratings.csv');
users = mldata.data(:,1);
movies = mldata.data(:,2);
ratings = mldata.data(:,3);


%% pre-processing

% remove the mean from ratings
mean_ratings = mean(ratings);
ratings = ratings - mean_ratings;

% The database contains 9742 unique movies. It makes sense to denote them
% by integers ranging from 1 to 9742. For some reason, the original
% database does not ensure this. So, we take care of this explicitly in the
% following.
unique_movies = unique(movies);
nmovies = length(unique_movies);
for ii = 1:nmovies
    movies(movies==unique_movies(ii)) = ii;
end



% Partition 80% of the the data in training set and the remainder in test
% set
unique_users = unique(users);
nusers = length(unique_users);
nratings = length(ratings);
ntrain = round(0.8*nratings);
ntest = nratings - ntrain;
rand_order = randperm(nratings)';
idx_train = rand_order(1:ntrain);
idx_test = rand_order(ntrain+1:end);

users_train = users(idx_train);
movies_train = movies(idx_train);
ratings_train = ratings(idx_train);
ratings_train = ratings_train + 0.0*randn(size(ratings_train));

users_test = users(idx_test);
movies_test = movies(idx_test);
ratings_test = ratings(idx_test);

X_test = sparse(users_test, movies_test, ratings_test, nusers, nmovies);
mask_test = sparse(users_test, movies_test, true, nusers, nmovies);

X_train = sparse(users_train, movies_train, ratings_train, nusers, nmovies);
mask_train = sparse(users_train, movies_train, true, nusers, nmovies);

X_full = sparse(users, movies, ratings);
mask_full = sparse(users, movies, true);

% training 
%%
r_range = unique(round(logspace(log10(1), log10(200), 30)));
eta0 = 1;
for ir = 1:length(r_range)
    Xhat_full = lrmc_grouse(X_full, mask_full, r_range(ir), eta0);
    estErrFull = norm((Xhat_full-X_full).*mask_full,'fro')/norm(X_full.*mask_full,'fro');    % estimation error
    estErrFullAll(ir) = estErrFull;

    %
    Xhat_train = lrmc_grouse(X_train, mask_train, r_range(ir), eta0);
    Xhat_train = max(0.5-mean_ratings, min(5-mean_ratings, Xhat_train));
    estErrTrain = norm((Xhat_train-X_train).*mask_train,'fro')/norm(X_train.*mask_train,'fro');    % estimation error
    estErrTest = norm((Xhat_train-X_test).*mask_test,'fro')/norm(X_test.*mask_test,'fro');    % estimation error
    estErrTrainAll(ir) = estErrTrain;
    estErrTestAll(ir) = estErrTest;
    disp([ir, estErrFull, estErrTrain, estErrTest]);
end
save('movielens_20100609.mat');

%%
