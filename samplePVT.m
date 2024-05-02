function measures = samplePVT(object)
% dr = 100; % downsample rate
time_instance = 520;
pdc = [];
pac = [];
tac = [];

for i = 1:10
    temp = object.F0pdc(i,time_instance);
    pdc = [pdc; temp];
end

for i = 1:10
    % The Pac variable is 22-dimensional, but should be 1-dimensional.
    % Please only use the second row when sampling. 
    object.F0pac{i} = object.F0pac{i}(2,:);
end


pac_mat = cell2mat(object.F0pac);
for i = 1:10
    temp = pac_mat(i,time_instance);
    pac = [pac; temp];
end

for i = 1:10
    temp = object.F0tac(i,time_instance);
    tac = [tac; temp];
end

measures = [pdc pac tac];
end

