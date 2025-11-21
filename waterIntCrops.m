function result=waterIntCrops(outputFolder,outputFolder2)
inputFolder = outputFolder;
fileList = dir(fullfile(inputFolder, '*.tif'));
for fileIdx = 1:numel(fileList)
filename=fullfile(inputFolder, fileList(fileIdx).name);
info=geotiffinfo(filename);
s=imread(filename);
n=readmatrix("D:\LULC_Paper\CropPixels.xlsx",'Sheet','Water Intensive Crops'); n=n(2:size(n,1),2:size(n,2));
n=n.n;
replacementValues=readmatrix("D:\LULC_Paper\CropPixels.xlsx",'Sheet','Water Intensive Crops'); replacementValues = replacementValues(1,2:size(replacementValues,2));

searchValues=[19,22,2,5,6; 20,22,3,5,6];
for j=1:length(replacementValues)
if replacementValues(j)<53
    rows=1;
else
    rows=2;
end
searchValue1 = searchValues(rows,1); searchValue2 = searchValues(rows,2); searchValue3 = searchValues(rows,3); searchValue4 = searchValues(rows,4);searchValue5 = searchValues(rows,5);
logicalIndices1 = (s == searchValue1);
logicalIndices2 = (s == searchValue2);
logicalIndices3 = (s == searchValue3);
logicalIndices4 = (s == searchValue4);
%logicalIndices5 = (s == searchValue5);

count1 = sum(logicalIndices1(:));
count2 = sum(logicalIndices2(:));
count3 = sum(logicalIndices3(:));
count4 = sum(logicalIndices4(:));
%count5 = sum(logicalIndices5(:));
% Perform replacement based on counts and conditions
                if count1 >= n(fileIdx, j)
                    disp('count1 is more')
                    [rowIndices, colIndices] = find(s == searchValue1);
                    x = length(rowIndices);
                    y = round(n(fileIdx, j));
                    selectedIndices = randperm(x, y);

                    for i = 1:n(fileIdx, j)
                        row = rowIndices(selectedIndices(i));
                        col = colIndices(selectedIndices(i));
                        s(row, col) = replacementValues(1, j);
                    end
                elseif count2 >= (n(fileIdx, j) - count1)
                    disp('count2 is more')
                    s(s == searchValue1) = replacementValues(1, j);
                    [rowIndices, colIndices] = find(s == searchValue2);
                    x = length(rowIndices);
                    y = round(n(fileIdx, j) - count1);
                    selectedIndices = randperm(x, y);

                    for i = 1:(n(fileIdx, j) - count1)
                        row = rowIndices(selectedIndices(i));
                        col = colIndices(selectedIndices(i));
                        s(row, col) = replacementValues(1, j);
                    end
                elseif count3 >= (n(fileIdx, j) - count1 - count2)
                    disp('count3 is more')
                    s(s == searchValue2) = replacementValues(1, j);
                    [rowIndices, colIndices] = find(s == searchValue3);
                    x = length(rowIndices);
                    y = round(n(fileIdx, j) - count1 - count2);
                    selectedIndices = randperm(x, y);

                    for i = 1:(n(fileIdx, j) - count1 - count2)
                        row = rowIndices(selectedIndices(i));
                        col = colIndices(selectedIndices(i));
                        s(row, col) = replacementValues(1, j);
                    end
                      elseif count4 >= (n(fileIdx, j) - count1 - count2-count3)
                    disp('count4 is more')
                    s(s == searchValue3) = replacementValues(1, j);
                    [rowIndices, colIndices] = find(s == searchValue4);
                    x = length(rowIndices);
                    y = round(n(1, j) - count1 - count2-count3);
                    selectedIndices = randperm(x, y);

                    for i = 1:(n(fileIdx, j) - count1 - count2-count3)
                        row = rowIndices(selectedIndices(i));
                        col = colIndices(selectedIndices(i));
                        s(row, col) = replacementValues(1, j);
                    end
                 else
                    conditions = s == searchValue1 | s == searchValue2 | s == searchValue3 | s == searchValue4;
                    s(conditions) = replacementValues(1, j);
                    [rowIndices, colIndices] = find(s == searchValue5);
                    x = length(rowIndices);
                    y = round(n(fileIdx, j) - count1 - count2 - count3 - count4);
                    selectedIndices = randperm(x, y);

                    for i = 1:(n(fileIdx, j) - count1 - count2 - count3 - count4)
                        row = rowIndices(selectedIndices(i));
                        col = colIndices(selectedIndices(i));
                        s(row, col) = replacementValues(1, j);
                    end
                end
end

    % Specify the output TIFF file
    [~, baseFileName, ~] = fileparts(filename);
    outputTiffFile = fullfile(outputFolder2, sprintf('%s.tif', baseFileName));

    % Write the georeferenced raster data with spatial reference information
    geotiffwrite(outputTiffFile, s, info.SpatialRef, "GeoKeyDirectoryTag", info.GeoTIFFTags.GeoKeyDirectoryTag);

    sprintf('Classification Completed for %s\n',baseFileName)
end

result='reclassification of water intensive crops is completed';
