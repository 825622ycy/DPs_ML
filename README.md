# DPs_ML
The dataset used for training and evaluation in this project is fully simulated using finite element solver available in COMSOL Multiphysics 5.6. 
The machine learning models were implemented using MATLAB 2023a's Classification Learner and Regression Learner apps.
The data folder contains only a subset of example data, consisting of S11 parameters exported from COMSOL.
To reconstruct the dielectric properties of the tissue, please run the script main_Sparameter_method.m.
To generate the final training dataset, use the script s11_datanoise.m.
The ML folder includes the code used to evaluate the performance of the ANN, SVM, and Bagging models via five-fold cross-validation.
The paper entitled: "Integrating Dielectric Properties Analysis and Machine Learning for Accurate Liver Cancer Identification and Infiltration Depth Prediction" was submitted to Physical and Engineering Sciences in Medicine (Chunyou Ye & TChunyou Ye et al.).
