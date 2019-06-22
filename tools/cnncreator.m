
categories = {'Melanoma','Nevus'};

rootFolder = 'C:\Users\Harry\Desktop\Images\Train';
imds = imageDatastore(fullfile(rootFolder, categories), 'LabelSource', 'foldernames');

varSize = 32;
conv1 = convolution2dLayer(5,varSize,'Padding',2,'BiasLearnRateFactor',2);
conv1.Weights = single(randn([5 5 3 varSize])*0.0001);
fc1 = fullyConnectedLayer(64,'BiasLearnRateFactor',2);
fc1.Weights = single(randn([64 576])*0.1);
fc2 = fullyConnectedLayer(2,'BiasLearnRateFactor',2);
fc2.Weights = single(randn([2 64])*0.1);
layers = [
    imageInputLayer([varSize varSize 3]);
    conv1;
    maxPooling2dLayer(3,'Stride',2);
    reluLayer();
    convolution2dLayer(5,32,'Padding',2,'BiasLearnRateFactor',2);
    reluLayer();
    averagePooling2dLayer(3,'Stride',2);
    convolution2dLayer(5,64,'Padding',2,'BiasLearnRateFactor',2);
    reluLayer();
    averagePooling2dLayer(3,'Stride',2);
    fc1;
    reluLayer();
    fc2;
    softmaxLayer()
    classificationLayer()];



opts = trainingOptions('sgdm', ...
    'InitialLearnRate', 0.002, ...
    'LearnRateSchedule', 'piecewise', ...
    'LearnRateDropFactor', 0.1, ...
    'LearnRateDropPeriod', 8, ...
    'L2Regularization', 0.002, ...
    'MaxEpochs', 70, ... %full passes of the data
    'MiniBatchSize', 150, ...
    'Verbose', true);


[net, info] = trainNetwork(imds, layers, opts);

rootFolder = 'C:\Users\Harry\Desktop\Images\Test';
imds_test = imageDatastore(fullfile(rootFolder, categories), 'LabelSource', 'foldernames');

labels = classify(net, imds_test);

confMat = confusionmat(imds_test.Labels, labels);
confMat = confMat./sum(confMat,2);
mean(diag(confMat))

disscnn = net;
save disscnn;
