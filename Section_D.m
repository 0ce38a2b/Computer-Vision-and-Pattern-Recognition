clc;clear;
folderPath = './PR_CW_DATA_2021'; 
filePattern = fullfile(folderPath, '*.mat');
matFiles = dir(filePattern);

for k = 1:length(matFiles)
    baseFileName = matFiles(k).name;
    fullFileName = fullfile(folderPath, baseFileName);
    [~, baseFileName, ~] = fileparts(fullFileName);
    s = load(fullFileName);
    eval([baseFileName ' = s;']);
end
black_foam_110_08_HOLD = pre_process(black_foam_110_08_HOLD);

acrylic = import_data('acrylic');
black_foam = import_data('black_foam');
car_sponge = import_data('car_sponge');
flour_sack  = import_data('flour_sack');
kitchen_sponge = import_data('kitchen_sponge');
steel_vase = import_data('steel_vase');
%-----------------------------------------------------------%
% example: visit object , finger 0 --> preasure(pdc) --> measure 1
black_foam.F0pdc(1,:);

% example: visit object ,  finger 0 --> vibation(pac) --> measure 1
black_foam.F0pac{1};

% plot(black_foam.F0pac{1}');

% Finger F0
% Create dataset F0_PVT
F0_PVT = [];
objects = {acrylic, black_foam,car_sponge,flour_sack,kitchen_sponge,steel_vase}; 

PVT_data = cell(length(objects), 1);

% Define colors for the objects
colors = {[0,0,0.8], [0.0, 0.5019607843137255, 1.0],[0.0, 1.0, 1.0],
            [0.5019607843137255, 1.0, 0.5019607843137255],[1.0, 1.0, 0.0],[1.0, 0.5019607843137255, 0.0]}; 

for i = 1:length(objects)
    PVT_data{i} = samplePVT(objects{i});
    F0_PVT = [F0_PVT; PVT_data{i}];
end

% Create dataset F0_Electrodes
F0_Electrodes = [];
objects = {acrylic, black_foam,car_sponge,flour_sack,kitchen_sponge,steel_vase}; 


% 构建 F0_Electrodes 数据集
for i = 1:length(objects)
    
    Electrodes_data = sampleElectrode(objects{i});
    
    F0_Electrodes = [F0_Electrodes; Electrodes_data];
end



projected_ele = load('./projected_ele.mat')
X = projected_ele.projected_ele; % PCA 之后的 electrode data

labels = {'acrylic', 'black foam', 'car sponge', 'flour sack', 'kitchen sponge', 'steel vase'};
repeatedLabels = repmat(labels, 10, 1);
repeatedLabels = repeatedLabels(:); % Convert from matrix to vector
Y = categorical(repeatedLabels);

splitRatio = 0.6; 
totalSamples = size(X, 1);
idx = randperm(totalSamples);

rng("default"); % Set the random number generator to default for reproducibility.
numTrainSamples = floor(splitRatio * totalSamples); % Calculate the number of training samples

% Split the data into training and test sets
XTrain = X(idx(1:numTrainSamples), :);
XTest = X(idx(numTrainSamples+1:end), :);
YTrain = Y(idx(1:numTrainSamples));
YTest = Y(idx(numTrainSamples+1:end));

% Continue with the TreeBagger model training using the training data
Mdl = TreeBagger(200, XTrain, YTrain, 'Method', 'classification', ...
                'OOBPrediction', 'On');


% Visualize one of the trees in the model

view(Mdl.Trees{1}, 'Mode', 'graph')
view(Mdl.Trees{2}, 'Mode', 'graph');

[YTestPredicted, scores] = predict(Mdl, XTest);

YTestPredicted = categorical(YTestPredicted);

confusionMatrix = confusionmat(YTest, YTestPredicted);

figure;
confusionMatrix = confusionmat(YTest, YTestPredicted); 
imagesc(confusionMatrix);
colormap(sky); colorbar;
xlabel('Predicted label'); ylabel('True label');

set(gca, 'XTick', 1:length(labels), 'XTickLabel', labels, 'YTick', 1:length(labels), 'YTickLabel', labels);

% 为每个单元格添加文本
numClasses = size(confusionMatrix, 1);
for i = 1:numClasses
    for j = 1:numClasses
        text(j, i, num2str(confusionMatrix(i,j)), ...
            'HorizontalAlignment', 'center', 'Color', 'black');
    end
end
exportgraphics(gcf,'./figures/confusion_matrix_PCA_tree.png','Resolution',300)

% Optionally, calculate additional performance metrics such as accuracy
accuracy = sum(diag(confusionMatrix)) / sum(confusionMatrix, 'all');
disp(['Test Accuracy with PCA: ', num2str(accuracy)]);


% Decision Tree without PCA
X = F0_Electrodes; %F0_Electrodes(:,[7,8,9,10,17]) % F0_Electrodes %F0_PVT % F0_Electrodes;
labels = {'acrylic', 'black foam', 'car sponge', 'flour sack', 'kitchen sponge', 'steel vase'};
repeatedLabels = repmat(labels, 10, 1);
repeatedLabels = repeatedLabels(:); % Convert from matrix to vector
Y = categorical(repeatedLabels);

splitRatio = 0.6; 
totalSamples = size(X, 1);
idx = randperm(totalSamples);

rng("default"); % Set the random number generator to default for reproducibility.
numTrainSamples = floor(splitRatio * totalSamples); % Calculate the number of training samples

% Split the data into training and test sets
XTrain = X(idx(1:numTrainSamples), :);
XTest = X(idx(numTrainSamples+1:end), :);
YTrain = Y(idx(1:numTrainSamples));
YTest = Y(idx(numTrainSamples+1:end));

% Continue with the TreeBagger model training using the training data
Mdl = TreeBagger(200, XTrain, YTrain, 'Method', 'classification', ...
                'OOBPrediction', 'On', 'OOBPredictorImportance', 'On');


[YTestPredicted, scores] = predict(Mdl, XTest);

YTestPredicted = categorical(YTestPredicted);

confusionMatrix = confusionmat(YTest, YTestPredicted);

figure;
confusionMatrix = confusionmat(YTest, YTestPredicted); 
imagesc(confusionMatrix);
colormap(sky); colorbar;
xlabel('Predicted label'); ylabel('True label');

set(gca, 'XTick', 1:length(labels), 'XTickLabel', labels, 'YTick', 1:length(labels), 'YTickLabel', labels);

% 为每个单元格添加文本
numClasses = size(confusionMatrix, 1);
for i = 1:numClasses
    for j = 1:numClasses
        text(j, i, num2str(confusionMatrix(i,j)), ...
            'HorizontalAlignment', 'center', 'Color', 'black');
    end
end
exportgraphics(gcf,'./figures/confusion_matrix_baseline_tree.png','Resolution',300)

% Optionally, calculate additional performance metrics such as accuracy
accuracy = sum(diag(confusionMatrix)) / sum(confusionMatrix, 'all');
disp(['Test Accuracy without PCA: ', num2str(accuracy)]);

importance = Mdl.OOBPermutedPredictorDeltaError;

% Optionally, to visualize the importance scores:
% figure;
% bar(importance);
% title('Feature Importance');
% xlabel('Predictor Variable');
% ylabel('Importance');
% xticklabels(Mdl.PredictorNames);
% xtickangle(45);

