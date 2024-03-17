clear all;
close all;
addpath ./data/
filenames = dir(fullfile('./data', '*.IMA'));

for i = 1:numel(filenames)
    data(i).ima = dicomread(filenames(i).name);
    data(i).info = dicominfo(filenames(i).name);
    data(i).series = data(i).info.SeriesDescription;
end
%%


oil = [];
perf = [];
BIRN = [];
for i = 1:size(data,2)
    if contains(data(i).series,'OilPhan') == 1
        oil = [oil i];
    elseif contains(data(i).series,'Perfusion_Weighted') == 1
        perf = [perf i];
    elseif contains(data(i).series,'BIRNPhan') == 1
        BIRN = [BIRN i];
    end
end

oilphan = data(oil); perfusion = data(perf); birnphan = data(BIRN);



a = 1;
for i = 8:3:47
    oil_sech(a).img = oilphan(i).ima;
    oil_sech(a).info = oilphan(i).info;
    a = a+1;
end




for i = 1:2:13
    figure;
    subplot(1,2,1);
    imshow(oil_sech(i).img,[]);
    subplot(1,2,2);
    imshow(oil_sech(i+1).img,[]);
end






