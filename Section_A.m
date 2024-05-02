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


% Load the data
carSpongeData = load('./PR_CW_DATA_2021/car_sponge_101_01_HOLD.mat');
kitchenSpongeData = load('./PR_CW_DATA_2021/kitchen_sponge_114_01_HOLD.mat');
% Create a figure
figure;
set(gcf, 'Position', [100, 100, 1024, 768]); % Width and height are larger than the default.
% Define the number of signal types
numSignalTypes = 6; % To accommodate separate plots for F0 and F1 Electrodes
% Plot combined F0 and F1 series signals in subplots
% F0 PDC and F1 PDC for both sponges
subplot(numSignalTypes, 1, 1);
plot(carSpongeData.F0pdc(1,:), 'b');
hold on;
plot(carSpongeData.F1pdc(1,:), 'b--');
plot(kitchenSpongeData.F0pdc(1,:), 'r');
plot(kitchenSpongeData.F1pdc(1,:), 'r--');
title('PDC - Slow fluid pressure (Car: F0 in solid blue, F1 in dashed blue; Kitchen: F0 in solid red, F1 in dashed red)');
xlabel('Time', 'FontSize', 8, 'FontWeight', 'bold');
ylabel('Pressure', 'FontSize', 8, 'FontWeight', 'bold');
title('PDC - Slow fluid pressure', 'FontSize', 6, 'FontWeight', 'bold');
hold off;
% F0 PAC and F1 PAC for both sponges
subplot(numSignalTypes, 1, 2);
plot(carSpongeData.F0pac(2,:), 'b');
hold on;
plot(carSpongeData.F1pac(2,:), 'b--');
plot(kitchenSpongeData.F0pac(2,:), 'r');
plot(kitchenSpongeData.F1pac(2,:), 'r--');
title('PAC - High-frequency fluid vibration (Car: F0 in solid blue, F1 in dashed blue; Kitchen: F0 in solid red, F1 in dashed red)');
xlabel('Time', 'FontSize', 8, 'FontWeight', 'bold');
ylabel('Pressure', 'FontSize', 8, 'FontWeight', 'bold');
title('PDC - Slow fluid pressure', 'FontSize', 6, 'FontWeight', 'bold');
hold off;
% F0 TDC and F1 TDC for both sponges
subplot(numSignalTypes, 1, 3);
plot(carSpongeData.F0tdc(1,:), 'b');
hold on;
plot(carSpongeData.F1tdc(1,:), 'b--');
plot(kitchenSpongeData.F0tdc(1,:), 'r');
plot(kitchenSpongeData.F1tdc(1,:), 'r--');
title('TDC - Core temperature (Car: F0 in solid blue, F1 in dashed blue; Kitchen: F0 in solid red, F1 in dashed red)');
xlabel('Time');
ylabel('Temperature');
title('PDC - Slow fluid pressure', 'FontSize', 6, 'FontWeight', 'bold');
hold off;
ylim([1000, 3000]);
% F0 TAC and F1 TAC for both sponges
subplot(numSignalTypes, 1, 4);
plot(carSpongeData.F0tac(1,:), 'b');
hold on;
plot(carSpongeData.F1tac(1,:), 'b--');
plot(kitchenSpongeData.F0tac(1,:), 'r');
plot(kitchenSpongeData.F1tac(1,:), 'r--');
title('TAC - Core temperature change (Car: F0 in solid blue, F1 in dashed blue; Kitchen: F0 in solid red, F1 in dashed red)');
xlabel('Time', 'FontSize', 8, 'FontWeight', 'bold');
ylabel('Pressure', 'FontSize', 8, 'FontWeight', 'bold');
title('PDC - Slow fluid pressure', 'FontSize', 6, 'FontWeight', 'bold');
hold off;
% F0 Electrodes for both sponges
subplot(numSignalTypes, 1, 5);
plot(carSpongeData.F0Electrodes', 'b');
hold on;
plot(kitchenSpongeData.F0Electrodes', 'r');
title('Electrodes F0 - Electrode impedance (Car in blue, Kitchen in red)');
xlabel('Time', 'FontSize', 8, 'FontWeight', 'bold');
ylabel('Pressure', 'FontSize', 8, 'FontWeight', 'bold');
title('PDC - Slow fluid pressure', 'FontSize', 6, 'FontWeight', 'bold');
ylim([2000, 5000]);
hold off;
% F1 Electrodes for both sponges
subplot(numSignalTypes, 1, 6);
plot(carSpongeData.F1Electrodes', 'b');
hold on;
plot(kitchenSpongeData.F1Electrodes', 'r');
title('Electrodes F1 - Electrode impedance (Car in blue, Kitchen in red)');
xlabel('Time', 'FontSize', 8, 'FontWeight', 'bold');
ylabel('Pressure', 'FontSize', 8, 'FontWeight', 'bold');
title('PDC - Slow fluid pressure', 'FontSize', 7, 'FontWeight', 'bold');
ylim([2000, 5000]);
hold off;


% plot(black_foam.F0pac{1}');
% Finger F0
% Create dataset F0_PVT
F0_PVT = [];
objects = {acrylic, black_foam,car_sponge,flour_sack,kitchen_sponge,steel_vase}; 

PVT_data = cell(length(objects), 1);

% Define colors for the objects
colors = {[0,0,0.8], [0.0, 0.5019607843137255, 1.0],[0.0, 1.0, 1.0],
            [0.5019607843137255, 1.0, 0.5019607843137255],[1.0, 1.0, 0.0],[1.0, 0.5019607843137255, 0.0]}; 

figure;
h = []; % 画图句柄
for i = 1:length(objects)
    
    PVT_data{i} = samplePVT(objects{i});
    
    % 同时构建 F0_PVT 数据集
    F0_PVT = [F0_PVT; PVT_data{i}];
    ht = scatter3(PVT_data{i}(:,1), PVT_data{i}(:,2), PVT_data{i}(:,3), ...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor',cell2mat(colors(i)));
    h = [h ht];
    hold on;
end
xlabel('Pressure : $P_{DC}$', 'Interpreter', 'latex', 'FontSize', 10);
ylabel('Vibration:$P_{AC}$','Interpreter','latex','FontSize', 10);
zlabel('Temperature :$T_{AC}$','Interpreter','latex','FontSize', 10);


l2 = legend([h(4),h(5),h(6)],'flour sack','kitchen sponge','steel vase');
set(l2,'Orientation','horizon','Box','off');
set(l2,'Location','Northoutside','FontSize',8);
ah = axes('Position',get(l2,'position'),'Visible','off');

l1 = legend(ah,[h(1),h(2),h(3)],'acrylic','black foam','car sponge');
set(l1,'Orientation','horizon','Box','off');
set(l1,'Location','Northoutside','FontSize',8);

hold off;
exportgraphics(gcf,'./figures/3D_scatter_plot_PVT.png','Resolution',600);

% Create dataset F0_Electrodes
F0_Electrodes = [];
objects = {acrylic, black_foam,car_sponge,flour_sack,kitchen_sponge,steel_vase}; 


% 构建 F0_Electrodes 数据集
for i = 1:length(objects)
    
    Electrodes_data = sampleElectrode(objects{i});
    
    F0_Electrodes = [F0_Electrodes; Electrodes_data];
end

% size(F0_Electrodes)

save('./F0_Electrodes.mat', 'F0_Electrodes');
save('./F0_PVT.mat', 'F0_PVT');