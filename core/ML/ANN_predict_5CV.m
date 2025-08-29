
clc; clear
load('')
sample_tumor = sample(1:45000,:); 
label_depth = label_size;       



X_CV = sample_tumor;
Y_CV = label_depth;

rng(42)

cv = cvpartition(size(X_CV,1), 'KFold', 5);

rmse_all = zeros(5,1);
r2_all = zeros(5,1);
mape_all = zeros(5,1);

for i = 1:5
    idxTr = training(cv, i);
    idxVal = test(cv, i);

    XTrain = X_CV(idxTr, :);
    YTrain = Y_CV(idxTr);
    XVal   = X_CV(idxVal, :);
    YVal   = Y_CV(idxVal);

   
    layers = [
        featureInputLayer(362)
        fullyConnectedLayer(10)
        batchNormalizationLayer
        reluLayer
        fullyConnectedLayer(10)
        batchNormalizationLayer
        reluLayer
        fullyConnectedLayer(10)
        batchNormalizationLayer
        reluLayer
        fullyConnectedLayer(1)
        regressionLayer];

    options = trainingOptions('adam', ...
        'MaxEpochs', 100, ...
        'MiniBatchSize', 128, ...
        'Shuffle', 'every-epoch', ...
        'Verbose', false, ...
        'Plots', 'training-progress');  
 
    net = trainNetwork(XTrain, YTrain, layers, options);


    YPred = predict(net, XVal);
    rmse_all(i) = sqrt(mean((YPred - YVal).^2));
    r2_all(i) = 1 - sum((YPred - YVal).^2) / sum((YVal - mean(YVal)).^2);
    mape_all(i) = mean(abs((YPred - YVal) ./ YVal));
end

fprintf('Cross-Validation Results (5-Fold):\n');
fprintf('RMSE: %.4f ± %.4f\n', mean(rmse_all), std(rmse_all));
fprintf('R²:   %.4f ± %.4f\n', mean(r2_all), std(r2_all));
fprintf('MAPE: %.4f ± %.4f\n\n', mean(mape_all), std(mape_all));
