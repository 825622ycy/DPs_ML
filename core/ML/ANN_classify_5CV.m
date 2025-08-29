
clc; clear
load('')

X_CV = sample;
Y_CV = label; 

rng(42)

cv = cvpartition(size(X_CV,1), 'KFold', 5);

acc_all = zeros(5,1);
sens_all = zeros(5,1);
spec_all = zeros(5,1);
auc_all = zeros(5,1);

for i = 1:5
    idxTr = training(cv, i);
    idxVal = test(cv, i);

    XTrain = X_CV(idxTr, :);
    YTrain = Y_CV(idxTr);
    XVal   = X_CV(idxVal, :);
    YVal   = Y_CV(idxVal);

 
    YTrain_categorical = categorical(YTrain);
    YVal_categorical = categorical(YVal);


    layers = [
        featureInputLayer(362)
        fullyConnectedLayer(10)
        reluLayer
        fullyConnectedLayer(10)
        reluLayer
        fullyConnectedLayer(10)
        reluLayer
        fullyConnectedLayer(2)   
        softmaxLayer
        classificationLayer];

    options = trainingOptions('adam', ...
        'MaxEpochs', 100, ...
        'MiniBatchSize', 128, ...
        'Shuffle', 'every-epoch', ...
        'Verbose', false, ...
        'Plots', 'training-progress');

    
    net = trainNetwork(XTrain, YTrain_categorical, layers, options);


    YPred_prob = predict(net, XVal);  
    [~, YPred_class] = max(YPred_prob, [], 2);
    YPred_class = YPred_class - 1;  


    TP = sum((YVal == 1) & (YPred_class == 1));
    TN = sum((YVal == 0) & (YPred_class == 0));
    FP = sum((YVal == 0) & (YPred_class == 1));
    FN = sum((YVal == 1) & (YPred_class == 0));


    acc_all(i)    = (TP + TN) / length(YVal);
    recall_all(i) = TP / (TP + FN + eps);            % Sensitivity
    prec_all(i)   = TP / (TP + FP + eps);            % Precision
    f1_all(i)     = 2 * (prec_all(i) * recall_all(i)) / (prec_all(i) + recall_all(i) + eps);

  
    [~, score_pos] = max(YPred_prob, [], 2);
    [~,~,~,auc_all(i)] = perfcurve(YVal, score_pos, 1);
end

fprintf('5-Fold Cross-Validation (Classification Metrics):\n');
fprintf('Accuracy (ACC):    %.4f ± %.4f\n', mean(acc_all), std(acc_all));
fprintf('Recall (Sensitivity): %.4f ± %.4f\n', mean(recall_all), std(recall_all));
fprintf('Precision (PRE):   %.4f ± %.4f\n', mean(prec_all), std(prec_all));
fprintf('F1 Score:          %.4f ± %.4f\n', mean(f1_all), std(f1_all));
