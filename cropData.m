function sortedTablesAllSheets = cropData(excelFilePath, sheetNames)
    % Initialize a cell array to store the sorted tables for each sheet
    sortedTablesAllSheets = cell(length(sheetNames), 10);

    for sheetIndex = 1:length(sheetNames)
        sheetName = sheetNames{sheetIndex};
        
        % Read the data from the specified sheet
        DataSheet = readtable(excelFilePath, 'Sheet', sheetName);
        DataSheet = DataSheet(:, 2:end);
        headersSheet = DataSheet.Properties.VariableNames;

        for i = 1:10
            % Extract the first two rows
            dataCellSheet = table2cell(DataSheet);
            firstTwoRowsSheet = dataCellSheet([1, i+1], :);
            newTableSheet = cell2table(firstTwoRowsSheet, 'VariableNames', headersSheet);

            % Extract data from the second row
            secondRowDataSheet = dataCellSheet(i+1, :);

            % Sort the second row in descending order and get sorted indices
            [sortedSecondRowSheet, sortIndicesSheet] = sort(cell2mat(secondRowDataSheet), 'descend');

            % Sort headers and the first two rows based on the sorted indices
            sortedHeadersSheet = headersSheet(sortIndicesSheet);
            sortedFirstTwoRowsSheet = firstTwoRowsSheet(:, sortIndicesSheet);

            % Create a new table with the sorted data for the current sheet
            sortedDataTableSheet = cell2table(sortedFirstTwoRowsSheet, 'VariableNames', sortedHeadersSheet);

            % Store the sorted table in the cell array
            sortedTablesAllSheets{sheetIndex, i} = sortedDataTableSheet;
        end
    end
end
% excelFilePath = 'C:\Users\venka\Documents\CropPixels.xlsx';
% sheetNames = {'Kharif', 'Rabi', 'Zaid', 'Plantation'};
% sortedData = cropData(excelFilePath, sheetNames);
% clearvars except sortedData;