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



[n,~] = size(F0_PVT);

% step1: Standardise the data
% compute the mean of the data matrix
x_bar = 1/n * F0_PVT' * ones(n,1);

% substract the mean 
global m
[m,~] = size(F0_PVT);
F0_PVT_Standardised = F0_PVT - ones(m,1) * x_bar';


% step 2: compute the covariance matrix of the standardised data

% S = 1/n * F0_PVT'*(eye(n)-1/n*ones(n,1)*ones(n,1)')*F0_PVT
S = 1/n * F0_PVT_Standardised'*(eye(n)-1/n*ones(n,1)*ones(n,1)')*F0_PVT_Standardised

% Eigenvalue and eigen vector 分解 S
[F,V] = eig(S);

eigenvectors = F
eigenvalues = sum(V)

% [P,scrs,~,~,pexp] = pca(F0_PVT); % matlab built-in PCA
% plot the standardised data
figure
for i = 1:6
    if i == 1
        scatter3(F0_PVT_Standardised(1:(m/6),1),F0_PVT_Standardised(1:(m/6),2), F0_PVT_Standardised(1:(m/6),3), ...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor',cell2mat(colors(i)));
        hold on
    else
        scatter3(F0_PVT_Standardised((m/6)*(i-1)+1:(m/6)*i,1), ...
            F0_PVT_Standardised((m/6)*(i-1)+1:(m/6)*i,2), ...
            F0_PVT_Standardised((m/6)*(i-1)+1:(m/6)*i,3), ...
            'MarkerEdgeColor','k',...
                'MarkerFaceColor',cell2mat(colors(i)));
        hold on
    end
end
xlabel('Preasure : $P_{DC}$','Interpreter','latex','FontSize', 10, 'FontWeight', 'bold');
ylabel('Vibration:$P_{AC}$','Interpreter','latex','FontSize', 10, 'FontWeight', 'bold');
zlabel('Temperature :$T_{AC}$','Interpreter','latex','FontSize', 10, 'FontWeight', 'bold');


% plot the eigenvectors
a = 60 ; % scaling factor of the eigenvector
v1 = vector([0 0 0], a*F(:,1)', SphereDiameter=5,ConeWidth=5 ,ShaftWidth =1.5);
vectorupdate(v1,Color=[1 0 0]); % r

v2 = vector([0 0 0], a*F(:,2)', SphereDiameter=5,ConeWidth=5,ShaftWidth =1.5);
vectorupdate(v2,Color=[1 0 0]);

v3 = vector([0 0 0], a*F(:,3)', SphereDiameter=5,ConeWidth=5,ShaftWidth =1.5);
vectorupdate(v3,Color=[1 0 0]);
ylim([-150,150])
% view(-40,20);
% hold off
exportgraphics(gcf,'./figures/Standardised_data_with_PCS.png','Resolution',600);

% Reduce the data to 2-dimensions and replot.
feature_vector = [F(:,1) F(:,2)];
projected_PVT = F0_PVT_Standardised *feature_vector;

% plot the 2D projected standardised data
figure
for i = 1:6
    if i == 1
        scatter(projected_PVT(1:(m/6),1),projected_PVT(1:(m/6),2), ...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor',cell2mat(colors(i)));
        hold on
    else
        scatter(projected_PVT((m/6)*(i-1)+1:(m/6)*i,1), ...
            projected_PVT((m/6)*(i-1)+1:(m/6)*i,2), ...
            'MarkerEdgeColor','k',...
                'MarkerFaceColor',cell2mat(colors(i)));
        hold on
    end
end
xlabel('PC1','Interpreter','latex','FontSize', 10, 'FontWeight', 'bold');
ylabel('PC2','Interpreter','latex','FontSize', 10, 'FontWeight', 'bold');
exportgraphics(gcf,'./figures/projected_to_2D_PVT.png','Resolution',600);

% 投影到每一个 PC 线上
PC1 = F(:,1);
PC2 = F(:,2);
PC3 = F(:,3);

projected_PVT_PC1 = F0_PVT_Standardised *PC1;
projected_PVT_PC2 = F0_PVT_Standardised *PC2;
projected_PVT_PC3 = F0_PVT_Standardised *PC3;

figure

plot_1D(projected_PVT_PC1,-2.5)
hold on
plot_1D(projected_PVT_PC2,-2)
hold on
plot_1D(projected_PVT_PC3,-1.5)
ylim([-3,-1.2]);
grid on;
set(gca, 'YTick');
set(gca, 'YTick', [-2.5 -2 -1.5]);
set(gca, 'YTickLabel', {'PC1', 'PC2', 'PC3'});hold off
exportgraphics(gcf,'./figures/projected_to_1D_PVT.png','Resolution',600);
hold off


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%electrode data PCA%%%%%%%%%%



global n
[n,~] = size(F0_Electrodes);

% step1: Standardise the data
% compute the mean of the data matrix
F0_Electrodes_bar = 1/n * F0_Electrodes' * ones(n,1);

% substract the mean 
F0_Electrodes_Standardised = F0_Electrodes - ones(n,1) * F0_Electrodes_bar';

% step 2: compute the covariance matrix of the standardised data
S_E = 1/n * F0_Electrodes_Standardised'*(eye(n)-1/n*ones(n,1)*ones(n,1)')*F0_Electrodes_Standardised;

% Eigenvalue and eigen vector 分解 S_E
[F_E,V_E,~] = svd(S_E); % 等效于 eig()

% 不用 eig 了, 没有排序
% [F_E,V_E] = eig(S_E);
% F_E = real(F_E)

VE = sum(V_E)

feature_v = [F_E(:,1) F_E(:,2) F_E(:,3)];% 7 8 9 10 17

figure
% 特征贡献
varnames = arrayfun(@(x) sprintf('%d', x), 1:19, 'UniformOutput', false);
h= heatmap(abs(feature_v),...
     "YDisplayLabels",varnames);

% Set the colormap to 'hot' (or you can customize it further if needed)
colormap(h, 'hot');
xlabel("First three principal components")
ylabel("Electrode number")
exportgraphics(gcf,'./figures/electrode_feature_contribution.png','Resolution',600);




% plot the scree plot
figure
p = plot([1:19],VE,'-o','LineWidth',2);
p.MarkerFaceColor = [1 0.2 0];
title("Scree Plot",'fontweight','bold','fontsize',12);
xticks(1:19);xtickangle(0);xlim([0.5,19]);
xlabel("Principle Component",'fontweight','bold')
ylabel("Eigenvalue (= Variance)",'fontweight','bold')
pbaspect([2.5 1 1]); 
exportgraphics(gcf,'./figures/scree_plot.png','Resolution',600);

% plot the cum scree plot 
figure
p = plot([1:19],cumsum(VE/sum(VE)),'-o','LineWidth',2);
p.MarkerFaceColor = [1 0.2 0];
xticks(1:19);xtickangle(0);xlim([0.5,19]);
title("Cumulative fraction of variance",'fontweight','bold','fontsize',12);
xlabel("Principle Component",'fontweight','bold')
ylabel("Fraction of variance",'fontweight','bold')
pbaspect([2.5 1 1]); 
exportgraphics(gcf,'./figures/scree_plot_cum.png','Resolution',600);





projected_ele = F0_Electrodes_Standardised * feature_v;
save('./projected_ele.mat', 'projected_ele');
% plot the 3D projected standardised data
figure
for i = 1:6
    if i == 1
        scatter3(projected_ele(1:(m/6),1),projected_ele(1:(m/6),2), ...
            projected_ele(1:(m/6),3), ...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor',cell2mat(colors(i)));
        hold on
    else
        scatter3(projected_ele((m/6)*(i-1)+1:(m/6)*i,1), ...
            projected_ele((m/6)*(i-1)+1:(m/6)*i,2), ...
            projected_ele(1:(m/6),3),...
            'MarkerEdgeColor','k',...
                'MarkerFaceColor',cell2mat(colors(i)));
        hold on
    end
end

xlabel("PC1",'fontweight','bold')
ylabel("PC2",'fontweight','bold')
zlabel("PC3",'fontweight','bold')

xlim([-936 336])
ylim([-185 112])
zlim([-69.9 7.8])
view([-37.1 80.0])
exportgraphics(gcf,'./figures/electrode_data_projected.png','Resolution',600);