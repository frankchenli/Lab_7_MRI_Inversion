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


for i = 1:16:size(birnphan,2)
    figure;
    for j = 1:16
        subplot(4,4,j);
        imshow(birnphan(j+i-1).ima, []);
    end
end




