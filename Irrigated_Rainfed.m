clear
clc
filename = 'C:\Users\venka\Documents\CommandAreas.xlsx';
classes = readmatrix(filename);
Initial = classes(:, 1);
Final = classes(:, 2);

info_LULC = geotiffinfo('D:\D\Clipped\classification6\merge6.tif');
% info_LULCCMD = geotiffinfo('C:\D\Clipped\CommandAreas.tif');

LULC = imread('D:\D\New Folder\LULC_clip.tif');
con1= (LULC==127) | (LULC==255);
LULC(con1) = 0;
%s=LULC;

LULCCMD = imread('D:\D\New Folder\LULC_cmd.tif');
con2= (LULCCMD==127) | (LULCCMD==255);
LULCCMD(con2)=0;
for m=1:size(Initial,1)
    for i=1:size(LULC,1)
    for j=1:size(LULC,2)
        if LULC(i,j)==Initial(m,1) && LULCCMD(i,j)==Initial(m,1)
            LULC(i,j)=Final(m,1);
        else
            LULC(i,j)=LULC(i,j);
        end
    end
    end
end
% for m=1:size(Final,1)
%     l=(LULC==Final(m,1));
%     count(m)=sum(l(:));
% end
% for n=1:size(Initial,1)
%     l=(LULC==Initial(n,1));
%     c(n)=sum(l(:));
% end
% Specify the output TIFF file
[~, baseFileName, ~] = fileparts('D:\D\Clipped\classification6\merge6.tif');
outputFolder = 'D:\D\Clipped\classification6';
outputTiffFile = fullfile(outputFolder, sprintf('%s_New.tif', baseFileName));

% Write the georeferenced raster data with spatial reference information
geotiffwrite(outputTiffFile, LULC, info_LULC.SpatialRef, 'GeoKeyDirectoryTag', info_LULC.GeoTIFFTags.GeoKeyDirectoryTag);

% Append all the properties to the output geotiff

disp('LULC RECLASSIFICATION COMPLETED')

%% Reclassifying Areas less than 0.1 % as Fallow
clc
clearvars -except outputTiffFile
info=geotiffinfo(outputTiffFile);
s=imread(outputTiffFile);
% Sample matrix
originalValues=load("C:\Users\venka\Documents\cropsToRemove.mat");
% Sample set of values
set_of_values = originalValues.originalValues;

% Iterate through the matrix and replace matching values with 6
for i = 1:size(s, 1)
    for j = 1:size(s, 2)
        if ismember(s(i, j), set_of_values)
            s(i, j) = 6;
        end
    end
end

% Specify the output TIFF file
[~, baseFileName, ~] = fileparts(outputTiffFile);
outputFolder = 'D:\D\Clipped\classification6';
outputTiffFile = fullfile(outputFolder, sprintf('%s_Final.tif', baseFileName));

% Write the georeferenced raster data with spatial reference information
geotiffwrite(outputTiffFile, s, info.SpatialRef, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);

% Append all the properties to the output geotiff

disp('LULC RECLASSIFICATION COMPLETED')


