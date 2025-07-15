clc;clear
load('')

X = sample; 
Y = label; 

rng(42)

K = 5;
cv = cvpartition(Y, 'KFold', K);


acc_all = zeros(K,1);
prec_all = zeros(K,1);
recall_all = zeros(K,1);
f1_all = zeros(K,1);

for i = 1:K
    trainIdx = training(cv, i);
    testIdx  = test(cv, i);
    
    XTrain = X(trainIdx, :);
    YTrain = Y(trainIdx);
    
    XTest = X(testIdx, :);
    YTest = Y(testIdx);
    
  
    model = fitcensemble(XTrain, YTrain, ...
        'Method', 'Bag', ...
        'NumLearningCycles', 30, ...
        'Learners', templateTree('MinLeafSize', 1));  % GUI 中通常是默认值

 
    YPred = predict(model, XTest);

    
    YTrue = double(YTest);
    YPred = double(YPred);


    TP = sum((YTrue == 1) & (YPred == 1));
    TN = sum((YTrue == 0) & (YPred == 0));
    FP = sum((YTrue == 0) & (YPred == 1));
    FN = sum((YTrue == 1) & (YPred == 0));

    acc_all(i)    = (TP + TN) / (TP + TN + FP + FN);
    prec_all(i)   = TP / (TP + FP + eps);
    recall_all(i) = TP / (TP + FN + eps);
    f1_all(i)     = 2 * prec_all(i) * recall_all(i) / (prec_all(i) + recall_all(i) + eps);
end


fprintf('\n');
fprintf('(Accuracy): %.2f%%\n', mean(acc_all) * 100);
fprintf('(Precision): %.2f%%\n', mean(prec_all) * 100);
fprintf('(Recall)   : %.2f%%\n', mean(recall_all) * 100);
fprintf('(F1-score) : %.2f%%\n', mean(f1_all) * 100);



