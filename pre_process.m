function structOut = pre_process(structIn)

% 主要用于处理 black_foam_110_08_HOLD.mat
    fields = fieldnames(structIn);

    for i = 1:length(fields)
        currentField = structIn.(fields{i});

        if ismatrix(currentField)
            if size(currentField, 2) > 1000
                structOut.(fields{i}) = currentField(:, 1:1000);
            end
        end
    end
end

