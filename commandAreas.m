function RESULT = commandAreas(inputFolder1,inputFolder2,outputFolder)
%inputFolder1='D:\D\DistrictsLULC_2122';
%inputFolder2='C:\D\Command_Areas\CommandAreas_Raster';
fileList1= dir(fullfile(inputFolder1, '*.tif'));
fileList2= dir(fullfile(inputFolder2, '*.tif'));
%outputFolder='D:\D\Command_Areas\Reclassified_CMD';
for fileIdx = 1:numel(fileList1)
    filename1 = fullfile(inputFolder1, fileList1(fileIdx).name);
    filename2 = fullfile(inputFolder2, fileList2(fileIdx).name);
    info1 = geotiffinfo(filename1);
    %info2 = geotiffinfo(filename1);
    raster_data1 = imread(filename1);
    s1 = raster_data1;
    raster_data2 = imread(filename2);
    s2 = raster_data2;
    for i=1:size(s1,1)
        for j=1:size(s1,2)
            if s2(i,j)==2
                s1(i,j)=19;
            elseif s2(i,j)==3
                s1(i,j)=20;
            elseif s2(i,j)==4
                s1(i,j)=21;
            elseif s2(i,j)==5
                s1(i,j)=22;
            else
                s1(i,j)=s1(i,j);
            end
        end
    end
    % Define the conditions
    %conditions = s1 == 22;

    % Replace values based on the conditions
    %s1(conditions) = 6;
    % Specify the output TIFF file
    [~, baseFileName, ~] = fileparts(filename1);
    outputTiffFile = fullfile(outputFolder, sprintf('%s_New.tif', baseFileName));
    
    % Write the georeferenced raster data with spatial reference information
    geotiffwrite(outputTiffFile, s1, info1.SpatialRef, 'GeoKeyDirectoryTag', info1.GeoTIFFTags.GeoKeyDirectoryTag);
    
    % Append all the properties to the output geotiff
    
    disp(['Processing completed for: ', baseFileName])
end
RESULT='Reclassification Completed'; 
end