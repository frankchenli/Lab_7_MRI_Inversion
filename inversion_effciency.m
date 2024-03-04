clear all;
close all;
addpath ./data/
filenames = dir(fullfile('./data', '*.IMA'));



for i = 1:numel(filenames)
    data(i).matrix = dicomread(filenames(i).name);
end

