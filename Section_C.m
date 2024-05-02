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

h = []; % 画图句柄
for i = 1:length(objects)
    
    PVT_data{i} = samplePVT(objects{i});
    
    % 构建 F0_PVT 数据集
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



[bc_projected_PV,a,b,v1] = LDA_on_two_object(objects{2},objects{3},1,2);
[bc_projected_PT,c,d,v2] = LDA_on_two_object(objects{2},objects{3},1,3);
[bc_projected_VT,e,f,v3] = LDA_on_two_object(objects{2},objects{3},2,3);

n_fig = 3;
figure
subplot(n_fig,2,1)
scatter(a(1:10),a(11:20),16, ...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor', cell2mat(colors(2)))
hold on
scatter(b(1:10),b(11:20),16,...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor', cell2mat(colors(3)))
hold on
plot([0, 10*v1(1)], [0, 10*v1(2)], 'm-',LineWidth=1.2); % 'b-' 指定为蓝色实线
plot([0, -10*v1(1)], [0, -10*v1(2)], 'm-',LineWidth=1.2); % 'b-' 指定为蓝色实线
xlabel('Pressure : $P_{DC}$', 'Interpreter', 'latex', 'FontSize', 10);
ylabel('Vibration:$P_{AC}$','Interpreter','latex','FontSize', 10);




subplot(n_fig,2,3)
scatter(c(1:10),c(11:20),16, ...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor', cell2mat(colors(2)))
hold on
scatter(d(1:10),d(11:20),16, ...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor', cell2mat(colors(3)))
hold on
plot([0, 10*v2(1)], [0, 10*v2(2)], 'm-',LineWidth=1.2); % 'b-' 指定为蓝色实线
plot([0, -10*v2(1)], [0, -10*v2(2)], 'm-',LineWidth=1.2); % 'b-' 指定为蓝色实线
xlabel('Pressure : $P_{DC}$', 'Interpreter', 'latex', 'FontSize', 10);
ylabel('Temperature :$T_{AC}$','Interpreter','latex','FontSize', 10);

subplot(n_fig,2,5)

scatter(e(1:10),e(11:20),16, ...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor', cell2mat(colors(2)))
hold on
scatter(f(1:10),f(11:20),16, ...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor', cell2mat(colors(3)))
hold on
plot([0, 10*v3(1)], [0, 10*v3(2)], 'm-',LineWidth=1.2); % 'b-' 指定为蓝色实线
plot([0, -10*v3(1)], [0, -10*v3(2)], 'm-',LineWidth=1.2); % 'b-' 指定为蓝色实线
xlabel('Vibration:$P_{AC}$','Interpreter','latex','FontSize', 10);
ylabel('Temperature :$T_{AC}$','Interpreter','latex','FontSize', 10);

% ----------------------------------------------%
subplot(n_fig,2,2)
scatter(bc_projected_PV(1:10),0*ones(10,1), ...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor', cell2mat(colors(2)))
hold on
scatter(bc_projected_PV(11:20),0*ones(10,1),15, ...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor', cell2mat(colors(3)))
yticks([]); xlabel('Distribution of projected data','Interpreter','latex','FontSize', 10)


subplot(n_fig,2,4)
scatter(bc_projected_PT(1:10),1*ones(10,1), ...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor', cell2mat(colors(2)))
hold on
scatter(bc_projected_PT(11:20),1*ones(10,1),15, ...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor', cell2mat(colors(3)))
yticks([]); xlabel('Distribution of projected data','Interpreter','latex','FontSize', 10)

subplot(n_fig,2,6)
scatter(bc_projected_VT(1:10),1*ones(10,1), ...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor', cell2mat(colors(2)))
hold on
scatter(bc_projected_VT(11:20),1*ones(10,1),15, ...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor', cell2mat(colors(3)))
yticks([]); xlabel('Distribution of projected data','Interpreter','latex','FontSize', 10)

exportgraphics(gcf,'./figures/LDA_feature_pairs.png','Resolution',600);

% 3D LDA
% PVT 差异最大的两类物体: 1,4 
c1 = samplePVT(objects{2});
c2 = samplePVT(objects{3});
[n1,~] = size(c1);
[n2,~] = size(c2);

mu_1 = mean(c1); mu_2 = mean(c2);
% standarized the data
c1 = c1 - mu_1; c2 = c2 - mu_2;
s1 = (n1-1) .* cov(c1); s2 = (n2-1) .* cov(c2);
SB = (mu_1 - mu_2)*(mu_1 - mu_2)';
SW = s1 + s2;

M = inv(SW)  * SB;
[V, J]= eig(M);

v = [V(:,2),V(:,3)];

projected_PVT = [c1+mu_1;c2+mu_2] * v;

% plot 投影之前的 data
figure
scatter3(c1(:,1),c1(:,2),c1(:,3), ...
            'MarkerEdgeColor', 'k',...
            'MarkerFaceColor', cell2mat(colors(2)))
hold on
scatter3(c2(:,1),c2(:,2),c2(:,3), ...
            'MarkerEdgeColor', 'k',...
            'MarkerFaceColor', cell2mat(colors(3)))
plot_2D_projection_plane(c1,c2,v);
xlabel('Pressure : $P_{DC}$', 'Interpreter', 'latex', 'FontSize', 10, 'FontWeight', 'bold');
ylabel('Vibration:$P_{AC}$','Interpreter','latex','FontSize', 10, 'FontWeight', 'bold');
zlabel('Temperature :$T_{AC}$','Interpreter','latex','FontSize', 10, 'FontWeight', 'bold');
exportgraphics(gcf,'./figures/LDA_PVT_3D.png','Resolution',600);



% 2D 投影之后的
figure
scatter(projected_PVT(1:10,1),projected_PVT(1:10,2), ...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor', cell2mat(colors(2)))

hold on
scatter(projected_PVT(11:20,1),projected_PVT(11:20,2), ...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor', cell2mat(colors(3)))
xlabel('LD1','Interpreter','latex','FontSize', 10, 'FontWeight', 'bold');
ylabel('LD2','Interpreter','latex','FontSize', 10, 'FontWeight', 'bold');
exportgraphics(gcf,'./figures/LDA_PVT_2D_projected.png','Resolution',600);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% My choice of objects%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


idx1 = 1;
idx2 = 4;
[bc_projected_PV,a,b,v1] = LDA_on_two_object(objects{idx1},objects{idx2},1,2);
[bc_projected_PT,c,d,v2] = LDA_on_two_object(objects{idx1},objects{idx2},1,3);
[bc_projected_VT,e,f,v3] = LDA_on_two_object(objects{idx1},objects{idx2},2,3);

n_fig = 3;
figure
subplot(n_fig,2,1)
scatter(a(1:10),a(11:20),16, ...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor', cell2mat(colors(idx1)))
hold on
scatter(b(1:10),b(11:20),16,...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor', cell2mat(colors(idx2)))
hold on
plot([0, 10*v1(1)], [0, 10*v1(2)], 'm-',LineWidth=1.2); % 'b-' 指定为蓝色实线
plot([0, -10*v1(1)], [0, -10*v1(2)], 'm-',LineWidth=1.2); % 'b-' 指定为蓝色实线
xlabel('Pressure : $P_{DC}$', 'Interpreter', 'latex', 'FontSize', 10);
ylabel('Vibration:$P_{AC}$','Interpreter','latex','FontSize', 10);




subplot(n_fig,2,3)
scatter(c(1:10),c(11:20),16, ...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor', cell2mat(colors(idx1)))
hold on
scatter(d(1:10),d(11:20),16, ...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor', cell2mat(colors(idx2)))
hold on
plot([0, 10*v2(1)], [0, 10*v2(2)], 'm-',LineWidth=1.2); % 'b-' 指定为蓝色实线
plot([0, -10*v2(1)], [0, -10*v2(2)], 'm-',LineWidth=1.2); % 'b-' 指定为蓝色实线
xlabel('Pressure : $P_{DC}$', 'Interpreter', 'latex', 'FontSize', 10);
ylabel('Temperature :$T_{AC}$','Interpreter','latex','FontSize', 10);

subplot(n_fig,2,5)

scatter(e(1:10),e(11:20),16, ...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor', cell2mat(colors(idx1)))
hold on
scatter(f(1:10),f(11:20),16, ...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor', cell2mat(colors(idx2)))
hold on
plot([0, 10*v3(1)], [0, 10*v3(2)], 'm-',LineWidth=1.2); % 'b-' 指定为蓝色实线
plot([0, -10*v3(1)], [0, -10*v3(2)], 'm-',LineWidth=1.2); % 'b-' 指定为蓝色实线
xlabel('Vibration:$P_{AC}$','Interpreter','latex','FontSize', 10);
ylabel('Temperature :$T_{AC}$','Interpreter','latex','FontSize', 10);

% ----------------------------------------------%
subplot(n_fig,2,2)
scatter(bc_projected_PV(1:10),0*ones(10,1), ...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor', cell2mat(colors(idx1)))
hold on
scatter(bc_projected_PV(11:20),0*ones(10,1),15, ...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor', cell2mat(colors(idx2)))
yticks([]); xlabel('Distribution of projected data','Interpreter','latex','FontSize', 10)


subplot(n_fig,2,4)
scatter(bc_projected_PT(1:10),1*ones(10,1), ...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor', cell2mat(colors(idx1)))
hold on
scatter(bc_projected_PT(11:20),1*ones(10,1),15, ...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor', cell2mat(colors(idx2)))
yticks([]); xlabel('Distribution of projected data','Interpreter','latex','FontSize', 10)

subplot(n_fig,2,6)
scatter(bc_projected_VT(1:10),1*ones(10,1), ...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor', cell2mat(colors(idx1)))
hold on
scatter(bc_projected_VT(11:20),1*ones(10,1),15, ...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor', cell2mat(colors(idx2)))
yticks([]); xlabel('Distribution of projected data','Interpreter','latex','FontSize', 10)

exportgraphics(gcf,'./figures/LDA_feature_pairs_my_objects.png','Resolution',600);

% 3D LDA
% PVT 差异最大的两类物体: 1,4 
c1 = samplePVT(objects{1});
c2 = samplePVT(objects{4});
[n1,~] = size(c1);
[n2,~] = size(c2);

mu_1 = mean(c1); mu_2 = mean(c2);
% standarized the data
c1 = c1 - mu_1; c2 = c2 - mu_2;
s1 = (n1-1) .* cov(c1); s2 = (n2-1) .* cov(c2);
SB = (mu_1 - mu_2)*(mu_1 - mu_2)';
SW = s1 + s2;

M = inv(SW)  * SB;
[V, J]= eig(M);

v = [V(:,2),V(:,3)];

projected_PVT = [c1+mu_1;c2+mu_2] * v;

% plot 投影之前的 data
figure
scatter3(c1(:,1),c1(:,2),c1(:,3), ...
            'MarkerEdgeColor', 'k',...
            'MarkerFaceColor', cell2mat(colors(1)))
hold on
scatter3(c2(:,1),c2(:,2),c2(:,3), ...
            'MarkerEdgeColor', 'k',...
            'MarkerFaceColor', cell2mat(colors(4)))
plot_2D_projection_plane(c1,c2,v);
xlabel('Pressure : $P_{DC}$', 'Interpreter', 'latex', 'FontSize', 10, 'FontWeight', 'bold');
ylabel('Vibration:$P_{AC}$','Interpreter','latex','FontSize', 10, 'FontWeight', 'bold');
zlabel('Temperature :$T_{AC}$','Interpreter','latex','FontSize', 10, 'FontWeight', 'bold');
exportgraphics(gcf,'./figures/LDA_PVT_3D_my_object.png','Resolution',600);



% 2D 投影之后的
figure
scatter(projected_PVT(1:10,1),projected_PVT(1:10,2), ...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor', cell2mat(colors(1)))

hold on
scatter(projected_PVT(11:20,1),projected_PVT(11:20,2), ...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor', cell2mat(colors(4)))
xlabel('LD1','Interpreter','latex','FontSize', 10, 'FontWeight', 'bold');
ylabel('LD2','Interpreter','latex','FontSize', 10, 'FontWeight', 'bold');
exportgraphics(gcf,'./figures/LDA_PVT_2D_projected_my_object.png','Resolution',600);


