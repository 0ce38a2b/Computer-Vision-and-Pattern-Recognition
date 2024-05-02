function v = import_data(substring)
    % 将数据用 table 组织管理起来 
    vars = evalin('base', ['who(''-regexp'', ''' substring ''')']);
    numVars = length(vars);

    % 为了保证数据的一致性，需要单独处理一下讨厌的
    % black_foam_110_08_HOLD.mat
    
    v = [];

    for i = 1:numVars
        varName = vars{i};
        values = evalin('base', varName);
        v = [v values];
    end

    % Concatenate all collected variables
    % v = [values{:}];
    v = struct2table(v);
end