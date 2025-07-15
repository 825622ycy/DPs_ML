clc;clear
load('')

X = sample; 
Y = label; 
rng(42)

cv = cvpartition(Y, 'KFold', 5);


acc_all    = zeros(5, 1);
prec_all   = zeros(5, 1);
recall_all = zeros(5, 1);
f1_all     = zeros(5, 1);

for i = 1:5
   
    trainIdx = training(cv, i);
    testIdx  = test(cv, i);

    XTrain = X(trainIdx,:);
    YTrain = Y(trainIdx);
    XTest  = X(testIdx,:);
    YTest  = Y(testIdx);


    t = templateSVM('KernelFunction', 'rbf', ...
                    'KernelScale', 76, ...
                    'BoxConstraint', 1, ...
                    'Standardize', true);

  
    model = fitcsvm(XTrain, YTrain, 'KernelFunction', 'rbf', ...
                    'KernelScale', 76, ...
                    'BoxConstraint', 1, ...
                    'Standardize', true, ...
                    'ClassNames', [0, 1]);


    YPred = predict(model, XTest);


    TP = sum((YTest == 1) & (YPred == 1));
    TN = sum((YTest == 0) & (YPred == 0));
    FP = sum((YTest == 0) & (YPred == 1));
    FN = sum((YTest == 1) & (YPred == 0));

    acc_all(i)    = (TP + TN) / length(YTest);
    recall_all(i) = TP / (TP + FN + eps);           % Sensitivity / Recall
    prec_all(i)   = TP / (TP + FP + eps);           % Precision
    f1_all(i)     = 2 * (prec_all(i) * recall_all(i)) / (prec_all(i) + recall_all(i) + eps);

  
    fprintf('Fold %d: Acc = %.2f%%, Prec = %.2f, Recall = %.2f, F1 = %.2f\n', ...
            i, acc_all(i)*100, prec_all(i), recall_all(i), f1_all(i));
end


fprintf('\n=== 5-Fold Cross-Validation Results ===\n');
fprintf('Average Accuracy : %.2f%%\n', mean(acc_all)*100);
fprintf('Average Precision: %.2f\n', mean(prec_all));
fprintf('Average Recall   : %.2f\n', mean(recall_all));
fprintf('Average F1 Score : %.2f\n', mean(f1_all));





