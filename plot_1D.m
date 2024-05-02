function plot_1D(data,bias)

global m
m;

% Define colors for the objects
colors = {[0,0,0.8], [0.0, 0.5019607843137255, 1.0],[0.0, 1.0, 1.0],
            [0.5019607843137255, 1.0, 0.5019607843137255],[1.0, 1.0, 0.0],[1.0, 0.5019607843137255, 0.0]}; 

y = bias*ones(m/6,1);
for i = 1:6
    if i == 1
        
        scatter(data(1:(m/6)),y, ...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor', cell2mat(colors(i)));
        hold on
    else
        scatter(data((m/6)*(i-1)+1:(m/6)*i),y, ...
            'MarkerEdgeColor','k',...
                'MarkerFaceColor',cell2mat(colors(i)));
        hold on
    end
end
end

