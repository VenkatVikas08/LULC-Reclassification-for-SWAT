clear
clc
inputFolder1='D:\D\DistrictsLULC_2122'; % original LULC of each District
inputFolder2='D:\D\Command_Areas\CommandAreas_Raster'; % LULC Rasters clipped to command areas for each district
outputFolder='D:\D\Command_Areas\Reclassified_CMD'; % Folder to store LULC of districts with command areas and rainfed areas together
outputFolder2 = 'D:\D\WaterIntensiveCrops\classification6'; % Folder to store rasters assigning pixels to water intensive crops (Rice, cotton Sugarcane in this case) 
% Specify the input folder containing GeoTIFF files
inputFolder = outputFolder2;
RESULT1=commandAreas(inputFolder1,inputFolder2,outputFolder); % Function to execute command Areas allocation
RESULT2=waterIntCrops(outputFolder,outputFolder2); % Function to assign pixels to water intensive crops
excelFilePath = 'C:\Users\venka\Documents\CropPixels.xlsx'; % Excel sheet containing pixels to be allocated for each district
sheetNames = {'Kharif', 'Rabi', 'Zaid', 'Plantation'};
sortedData = cropData(excelFilePath, sheetNames); % Function to sort crop data

% List all GeoTIFF files in the input folder
fileList = dir(fullfile(inputFolder, '*.tif'));

% search values
searchValues=[19,22,2,5,6; 20,22,3,5,6; 21,4,5,6,6; 7,6,6,6,6];
% Loop through each GeoTIFF file
for fileIdx = 1:numel(fileList)
    % Construct the full file path
    filename = fullfile(inputFolder, fileList(fileIdx).name);

    % Retrieve geotiff information and read raster data
    info = geotiffinfo(filename);
    raster_data = imread(filename);
    s = raster_data; % Copy of raster data for modification
    % Loop through each sheet and column in the Excel file
    
        for rows = 1:size(sortedData, 1)
            sortedDataTable = sortedData(rows, fileIdx);
            extractedTable = sortedDataTable{1};
            % Convert a table to a cell array and extract the first two rows
            dataCell = table2cell(extractedTable);
            firstTwoRows = dataCell(1:2, :);
            matrixFirstTwoRows = cell2mat(firstTwoRows);

            % Extract replacement values and counts from the matrix
            n = matrixFirstTwoRows(2, :);
            replacementValues = matrixFirstTwoRows(1, :);

            % Loop through replacement values and perform conditional replacement
            for j = 1:length(replacementValues)
                searchValue1 = searchValues(rows,1); searchValue2 = searchValues(rows,2); searchValue3 = searchValues(rows,3); searchValue4 = searchValues(rows,4);searchValue5 = searchValues(rows,5);

                % Count occurrences of each search value
                logicalIndices1 = (s == searchValue1);
                logicalIndices2 = (s == searchValue2);
                logicalIndices3 = (s == searchValue3);
                logicalIndices4 = (s == searchValue4);
                logicalIndices5 = (s == searchValue5);

                count1 = sum(logicalIndices1(:));
                count2 = sum(logicalIndices2(:));
                count3 = sum(logicalIndices3(:));
                count4 = sum(logicalIndices4(:));
                count5 = sum(logicalIndices5(:));

                % Perform replacement based on counts and conditions
                if count1 >= n(1, j)
                    disp('count1 is more')
                    [rowIndices, colIndices] = find(s == searchValue1);
                    x = length(rowIndices);
                    y = round(n(1, j));
                    selectedIndices = randperm(x, y);

                    for i = 1:n(1, j)
                        row = rowIndices(selectedIndices(i));
                        col = colIndices(selectedIndices(i));
                        s(row, col) = replacementValues(1, j);
                    end
                elseif count2 >= (n(1, j) - count1)
                    disp('count2 is more')
                    s(s == searchValue1) = replacementValues(1, j);
                    [rowIndices, colIndices] = find(s == searchValue2);
                    x = length(rowIndices);
                    y = round(n(1, j) - count1);
                    selectedIndices = randperm(x, y);

                    for i = 1:(n(1, j) - count1)
                        row = rowIndices(selectedIndices(i));
                        col = colIndices(selectedIndices(i));
                        s(row, col) = replacementValues(1, j);
                    end
                elseif count3 >= (n(1, j) - count1 - count2)
                    disp('count3 is more')
                    s(s == searchValue2) = replacementValues(1, j);
                    [rowIndices, colIndices] = find(s == searchValue3);
                    x = length(rowIndices);
                    y = round(n(1, j) - count1 - count2);
                    selectedIndices = randperm(x, y);

                    for i = 1:(n(1, j) - count1 - count2)
                        row = rowIndices(selectedIndices(i));
                        col = colIndices(selectedIndices(i));
                        s(row, col) = replacementValues(1, j);
                    end
                    elseif count4 >= (n(1, j) - count1 - count2-count3)
                    disp('count4 is more')
                    s(s == searchValue3) = replacementValues(1, j);
                    [rowIndices, colIndices] = find(s == searchValue4);
                    x = length(rowIndices);
                    y = round(n(1, j) - count1 - count2-count3);
                    selectedIndices = randperm(x, y);

                    for i = 1:(n(1, j) - count1 - count2-count3)
                        row = rowIndices(selectedIndices(i));
                        col = colIndices(selectedIndices(i));
                        s(row, col) = replacementValues(1, j);
                    end
                else
                    conditions = s == searchValue1 | s == searchValue2 | s == searchValue3 | s == searchValue4;
                    s(conditions) = replacementValues(1, j);
                    [rowIndices, colIndices] = find(s == searchValue5);
                    x = length(rowIndices);
                    y = round(n(1, j) - count1 - count2 - count3 - count4);
                    selectedIndices = randperm(x, y);

                    for i = 1:(n(1, j) - count1 - count2 - count3 - count4)
                        row = rowIndices(selectedIndices(i));
                        col = colIndices(selectedIndices(i));
                        s(row, col) = replacementValues(1, j);
                    end
                end
            end
            sprintf('row%f completed',rows)
        end
    con=s==19|s==20|s==21|s==22|s==7|s==2|s==3|s==4|s==5;
    s(con)=6;

    % Specify the output folder
    outputFolder3 = 'D:\D\outputReclassified\classification6';

    % Specify the output TIFF file
    [~, baseFileName, ~] = fileparts(filename);
    outputTiffFile = fullfile(outputFolder3, sprintf('reclassified_%s.tif', baseFileName));

    % Write the georeferenced raster data with spatial reference information
    geotiffwrite(outputTiffFile, s, info.SpatialRef, "GeoKeyDirectoryTag", info.GeoTIFFTags.GeoKeyDirectoryTag);

    sprintf('Classification Completed for %s\n',baseFileName)
end
disp('Classification Process completed')