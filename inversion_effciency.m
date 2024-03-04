clear all;
close all;
addpath ./data/
filenames = dir(fullfile('./data', '*.IMA'));

for i = 1:numel(filenames)
    data(i,1).ima = dicomread(filenames(i).name);
end


for i = 1:16:size(data,1)
    figure;
    for j = 1:16
        subplot(4,4,j);
        imshow(data(j+i-1).ima, []);
    end
end


