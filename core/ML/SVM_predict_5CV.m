clc;clear
load('')

X = sample(1:45000,:); 
Y = label_size; 
rng(42)



K = 5; 
cv = cvpartition(length(Y), 'KFold', K);


rmse_all = zeros(K, 1);
mape_all = zeros(K, 1);

for i = 1:K

    trainIdx = training(cv, i);
    testIdx = test(cv, i);

    XTrain = X(trainIdx, :);
    YTrain = Y(trainIdx);

    XTest = X(testIdx, :);
    YTest = Y(testIdx);

  
    model = fitrsvm(XTrain, YTrain, ...
        'KernelFunction', 'gaussian', ...
        'KernelScale', 19, ...
        'Standardize', true);  

 
    YPred = predict(model, XTest);


    mse = mean((YPred - YTest).^2);
    rmse = sqrt(mse);

  
    mape = mean(abs((YPred - YTest) ./ (YTest + eps))) * 100;


    rmse_all(i) = rmse;
    mape_all(i) = mape;
end


fprintf('\n');
fprintf('RMSE : %.4f\n', mean(rmse_all));
fprintf('MAPE: %.2f %%\n', mean(mape_all));


figure;
bar([rmse_all, mape_all], 'grouped');
legend('RMSE', 'MAPE (%)');
xlabel('Fold');
ylabel('Error');
title('5-Fold Cross-Validation: RMSE & MAPE');








