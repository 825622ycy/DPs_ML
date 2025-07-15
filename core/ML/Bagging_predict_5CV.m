clc;clear
load('')

X = sample(1:45000,:);
Y = label_size; 
rng(42)

K = 5;
cv = cvpartition(length(Y), 'KFold', K);


rmse_all = zeros(K,1);
mae_all  = zeros(K,1);
mape_all = zeros(K,1);
r2_all   = zeros(K,1);

for i = 1:K
   
    trainIdx = training(cv, i);
    testIdx  = test(cv, i);
    
    XTrain = X(trainIdx, :);
    YTrain = Y(trainIdx);
    
    XTest = X(testIdx, :);
    YTest = Y(testIdx);

  
    model = fitrensemble(XTrain, YTrain, ...
        'Method', 'Bag', ...
        'NumLearningCycles', 30, ...
        'Learners', templateTree('MinLeafSize', 8));

  
    YPred = predict(model, XTest);

 
    rmse_all(i) = sqrt(mean((YTest - YPred).^2));
    mae_all(i)  = mean(abs(YTest - YPred));
    mape_all(i) = mean(abs((YTest - YPred) ./ (YTest + eps))) * 100;


    ss_res = sum((YTest - YPred).^2);
    ss_tot = sum((YTest - mean(YTest)).^2);
    r2_all(i) = 1 - ss_res / (ss_tot + eps);
end


fprintf('\n');
fprintf('RMSE : %.5f\n', mean(rmse_all));
fprintf('MAE  : %.5f\n', mean(mae_all));
fprintf('MAPE : %.2f %%\n', mean(mape_all));
fprintf('R²   : %.4f\n', mean(r2_all));


