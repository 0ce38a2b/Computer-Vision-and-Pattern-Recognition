function plot_2D_projection_plane(c1,c2,v)
% plot 投影平面
v1 = v(:, 1);
v2 = v(:, 2);
line_length = 100;
ld = 1.5;
ls = '-';
line([0, line_length*v1(1)], [0, line_length*v1(2)], [0, line_length*v1(3)], ...
    'Color', 'red', 'LineWidth', ld, 'LineStyle', ls);
line([0, -line_length*v1(1)], [0, -line_length*v1(2)], [0, -line_length*v1(3)], ...
    'Color', 'red', 'LineWidth', ld, 'LineStyle', ls);

line([0, line_length*v2(1)], [0, line_length*v2(2)], [0, line_length*v2(3)], ...
    'Color', 'blue', 'LineWidth', ld, 'LineStyle', ls);
line([0, -line_length*v2(1)], [0, -line_length*v2(2)], [0, -line_length*v2(3)], ...
    'Color', 'blue', 'LineWidth', ld, 'LineStyle', ls);


scale_factor = 300;
col = [0.5940 0.1840 0.5560];
% 计算四个角点
p1 = [0, 0, 0]; % 原点
p2 = v1';
p3 = v1' + v2';
p4 = v2';

% 使用 patch 绘制平面
patch(scale_factor * [p1(1), p2(1), p3(1), p4(1)], ...
      scale_factor * [p1(2), p2(2), p3(2), p4(2)], ...
      scale_factor * [p1(3), p2(3), p3(3), p4(3)], ...
      col, 'FaceAlpha', 0.5,'EdgeColor', 'none');

hold on
p1 = [0, 0, 0]; % 原点
p2 = v1';
p3 = -v1' - v2';
p4 = v2';

patch(scale_factor * [p1(1), p2(1), p3(1), p4(1)], ...
      scale_factor * [p1(2), p2(2), p3(2), p4(2)], ...
      scale_factor * [p1(3), p2(3), p3(3), p4(3)], ...
      col, 'FaceAlpha', 0.5,'EdgeColor', 'none');
hold on 

xlim([min([c1(:,1);c2(:,1)])-10,max([c1(:,1);c2(:,1)])+10])
ylim([min([c1(:,2);c2(:,2)]),max([c1(:,2);c2(:,2)])])
zlim([min([c1(:,3);c2(:,3)])-10,max([c1(:,3);c2(:,3)])+10])
view(3);
end
