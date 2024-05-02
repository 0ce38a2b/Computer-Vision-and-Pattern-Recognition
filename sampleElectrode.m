function electordes = sampleElectrode(object)
% dr = 100; % downsample rate
time_instance = 120;
electordes = [];
for  i = 1:10 % 10 次 measurement
    single_measure = [];
    for j = 1:19
       single_electrode =  object.F0Electrodes{i}(j,time_instance);
       single_measure = [single_measure;single_electrode];
    end
    electordes = [electordes;single_measure'];
end

end
