function [projected_data,c1_mean_remove,c2_mean_remove,v] = LDA_on_two_object(object1,object2,f1,f2)



data1 = samplePVT(object1);
data2 = samplePVT(object2);

% preasure_vibration
% LDA step 1: 计算 每一类 特征属性的 mean
% exteact feature column
c1 = data1(:,[f1,f2]);
c2 = data2(:,[f1,f2]);
[n1,~] = size(c1);
[n2,~] = size(c2);

mu_1 = mean(c1); mu_2 = mean(c2);
s1 = (n1-1) .* cov(c1);  s2 = (n2-1) .* cov(c2);

SB = (mu_1 - mu_2)*(mu_1 - mu_2)';
SW = s1 + s2;

M = inv(SW)  * SB;

[V, J]= eig(M);
V
J
v = V(:,2);

c1_mean_remove = c1-mu_1;
c2_mean_remove = c2-mu_2;

% plot 投影之后的 data
projected_data = [c1;c2]*v;
end
