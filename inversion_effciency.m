%%
clear all;
close all;
addpath ./data/
filenames = dir(fullfile('./data', '*.IMA'));

for i = 1:numel(filenames)
    data(i).ima = dicomread(filenames(i).name);
    data(i).info = dicominfo(filenames(i).name);
    data(i).series = data(i).info.SeriesDescription;
end


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
for i = 11:3:47
    oil_sech(a).img = double(oilphan(i).ima);
    oil_sech(a).reference = double(oilphan(i-1).ima);
    oil_sech(a).series = oilphan(i).series;
    oil_sech(a).diff = oil_sech(a).reference-oil_sech(a).img
    a = a+1;
end
oil_sech(14).img = double(oilphan(8).ima);
oil_sech(14).reference = double(oilphan(7).ima);
oil_sech(14).series = oilphan(8).series;
oil_sech(14).diff = oil_sech(14).reference-oil_sech(14).img

a = 1;
for i = 50:3:65

    oil_sinc(a).img = double(oilphan(i).ima);
    oil_sinc(a).reference =  double(oilphan(i+1).ima);
    oil_sinc(a).series = oilphan(i).series;
    oil_sinc(a).diff = oil_sinc(a).reference-oil_sinc(a).img;
    a = a+1;
end

a = 1;
for i = 5:3:41
    birn_sech(a).img =  double(birnphan(i).ima);
    birn_sech(a).reference =  double(birnphan(i-1).ima);
    birn_sech(a).series = birnphan(i).series;
    birn_sech(a).diff = birn_sech(a).reference-birn_sech(a).img;
    a = a+1;
end
birn_sech(14).img = double(oilphan(2).ima);
birn_sech(14).reference = double(oilphan(1).ima);
birn_sech(14).series = oilphan(2).series;
birn_sech(14).diff = oil_sech(14).reference-oil_sech(14).img



a = 1;
for i = 44:3:59
    birn_sinc(a).img =  double(birnphan(i).ima);
    birn_sinc(a).reference = double(birnphan(i+1).ima);
    birn_sinc(a).series = birnphan(i).series;
    birn_sinc(a).diff = birn_sinc(a).reference-birn_sinc(a).img;
    a = a+1;
end



% figure;
% subplot(1,3,1)
% imshow(oil_sech(5).reference,[]);
% title('Non-inverted');
% subplot(1,3,2);
% imshow(oil_sech(5).img,[])
% title('Inverted');
% subplot(1,3,3);
% imshow(oil_sech(5).diff,[]);
% title('Difference (Non inverted-Inverted)');
% hold on
% plot([64 64], [1 128], 'r');
%%
close all
titles = ["B1 = 0.0",'B1 = 0.05','B1 = 0.1','B1 = 0.15','B1 = 0.25','B1 = 0.35','B1 = 0.45','B1 = 0.55','B1 = 0.65','B1 = 0.75','B1 = 0.85','B1 = 0.95','B1 = 1.05','B1 = 1.15'];
for i = 1:size(oil_sech,2)
        figure;
        % subplot(2,7,i);
        % stem(mean(oil_sech(i).img(44:95,41:83),2));
        % subplot(1,3,1)
        % stem(oil_sech(i).diff(:,64))
         % title('Difference(Reference - Inverted)')
        % ylim([0 300])
        % title(titles(i));
        % subplot(1,3,2)
        stem(oil_sech(i).img(:,64))
        title('Inverted')
        % % imshow(oil_sech(i).img,[]);
        % subplot(1,3,3)
        % stem(oil_sech(i).reference(:,64))
        % title('Reference')


end
% sgtitle('Oil phantom Adiabatic Difference(Non inverted - Inverted)')

% figure;
% subplot(3,3,1)
% stem(oil_sech(4).diff(:,64))
% ylim([0 300])
% title('B1 = 0.15 Difference(reference-Inverted)');
% subplot(3,3,2)
% stem(oil_sech(5).diff(:,64));
% ylim([0 300])
% title('B1 = 0.25 Difference(reference-Inverted)');
% subplot(3,3,3)
% stem(oil_sech(6).diff(:,64));
% ylim([0 300])
% title('B1 = 0.35 Difference(reference-Inverted)');
% subplot(3,3,4)
% stem(oil_sech(4).img(:,64));
% ylim([0 500])
% title('B1 = 0.15 Inverted');
% subplot(3,3,5)
% stem(oil_sech(5).img(:,64));
% ylim([0 500])
% title('B1 = 0.25 Inverted');
% subplot(3,3,6)
% stem(oil_sech(6).img(:,64));
% ylim([0 500])
% title('B1 = 0.35 Inverted');
% subplot(3,3,7)
% stem(oil_sech(4).reference(:,64));
% ylim([0 500])
% title('B1 = 0.15 reference');
% subplot(3,3,8)
% stem(oil_sech(5).reference(:,64));
% ylim([0 500])
% title('B1 = 0.25 reference');
% subplot(3,3,9)
% stem(oil_sech(6).reference(:,64));
% ylim([0 500])
% title('B1 = 0.35 reference');



%%
for i = 1:4
    oil_sech(i).corrected = oil_sech(i).img;
    oil_sech(i).correct_diff = oil_sech(i).diff;
end

for i = 5:14
    slice = oil_sech(i).diff(:,64).';
    [I, max1] = max(slice(40:60));
    [I2, max2] = max(slice(80:100));
    oil_sech(i).corrected = oil_sech(i).img;
    oil_sech(i).corrected(40+max1:80+max2-1,:) = -oil_sech(i).corrected(40+max1:80+max2-1,:);
    oil_sech(i).correct_diff = oil_sech(i).reference-oil_sech(i).corrected;
end


% figure;
% for i = 1:14
%     subplot(2,7,i)
%     stem(oil_sech(i).correct_diff(:,64));
%     title(titles(i));
%     ylim([0 600]);
% end
% sgtitle('Oil phantom Adiabatic Corrected Difference')


average = [];
refer = [];
m = [];
for j = 1:14
    for i = 1:128
        a = oil_sech(j).correct_diff(:,i);
        summ = mean(oil_sech(j).correct_diff(:,i));
        ref = mean(oil_sech(j).reference(:,i));
        average = [summ average];
        refer = [refer ref];
    end
    total = mean(average);
    total = total/mean(refer);
    m = [m total];
end


figure;
B1 = [0 0.05 0.1 0.15 0.25 0.35 0.45 0.55 0.65 0.75 0.85 0.95 1.05 1.15];
plot(B1,m);
xlabel('B1')
ylabel('Average Inversion Intensity');
title('Oil-Phantom Adiabatic Inversion Normalized Intensity');




% 
% for i = 1:2:13
%     figure;
%     subplot(1,2,1);
%     imshow(oil_sech(i).img,[]);
%     subplot(1,2,2);
%     imshow(oil_sech(i+1).img,[]);
% end 



close all
titles = ["B1 = 2.0",'B1 = 5.0','B1 = 7.0','B1 = 10.0','B1 = 15.0','B1 = 24.0'];
for i = 1:size(birn_sech,2)
        figure;
        % subplot(2,7,i);
        % stem(mean(oil_sech(i).img(44:95,41:83),2));
        % subplot(1,3,1)
        % stem(oil_sech(i).diff(:,64))
         % title('Difference(Reference - Inverted)')
        % ylim([0 300])
        % title(titles(i));
        % subplot(1,3,2)
        imshow(birn_sech(i).img,[]);
        % stem(birn_sech(i).corrected(:,64));
        title('Inverted')
        % % imshow(oil_sech(i).img,[]);
        % subplot(1,3,3)
        % stem(oil_sech(i).reference(:,64))
        % title('Reference')
end





for i = 1:4
    birn_sech(i).corrected = birn_sech(i).img;
    birn_sech(i).correct_diff = birn_sech(i).diff;
end

for i = 5:14
    slice = birn_sech(i).diff(:,64).';
    birn_sech(i).corrected = birn_sech(i).img;
    birn_sech(i).corrected(47:91,:) = -birn_sech(i).corrected(47:91,:);
    birn_sech(i).correct_diff = birn_sech(i).reference-birn_sech(i).corrected;
end



figure;
titles = ["B1 = 0.0",'B1 = 0.05','B1 = 0.1','B1 = 0.15','B1 = 0.25','B1 = 0.35','B1 = 0.45','B1 = 0.55','B1 = 0.65','B1 = 0.75','B1 = 0.85','B1 = 0.95','B1 = 1.05','B1 = 1.15'];
for i = 1:14
    subplot(2,7,i)
    stem(birn_sech(i).correct_diff(:,64));
    title(titles(i));
    ylim([0 2000]);
end
sgtitle('BIRN phantom Adiabatic Corrected Difference')





average = [];
refer = [];
m = [];
for j = 1:14
    for i = 1:128
        a = birn_sech(j).correct_diff(:,i);
        summ = mean(birn_sech(j).correct_diff(:,i));
        ref = mean(birn_sech(j).reference(:,i));
        average = [summ average];
        refer = [refer ref];
    end
    total = mean(average);
    total = total/mean(refer);
    m = [m total];
end




figure;
B1 = [0 0.05 0.1 0.15 0.25 0.35 0.45 0.55 0.65 0.75 0.85 0.95 1.05 1.15];
plot(B1,m);
xlabel('B1')
ylabel('Average Inversion Intensity');
title('BIRN-Phantom Adiabatic Inversion Normalized Intensity');
ylim([0 1.1]);




