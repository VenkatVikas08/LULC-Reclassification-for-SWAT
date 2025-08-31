# LULC-Reclassification-for-SWAT
This repository contains the Matlab script for the LULC reclassificatioin using NRSC LULC and Statistical Crop Area Data.
There are 5 five files in the repository, of which the file "LULC_Classification" is the main script. The remaining are files are supporting functions for the main file. 

Data Preparation:
Preparation of the input data involves three main steps:

District-wise LULC Maps:
Generate district-wise Land Use/Land Cover (LULC) maps using the default land use classes and store each district's map in a separate folder.

Clipping LULC Maps:
Clip each district-wise LULC map to the corresponding command area, and save these clipped maps in a distinct folder.

Crop Area Statistics:
Prepare the crop area statistics following the template provided as "CropPixels.xlsx" in the repository. Convert the crop areas to the number of pixels based on the spatial resolution of the LULC maps.

Assign class numbers to the new crop classes as indicated in the second row of the Excel template.

Ensure that crop area statistics are arranged in alphabetical order by district name.

Code Execution:

Set the path to the input folder containing the original district-wise LULC maps (inputFolder1) and the folder containing the clipped maps (inputFolder2).

Create folders to store outputs at each processing step, as specified in the script, and provide their paths in the code.

The final reclassified LULC maps will be saved in outputFolder3.

Ensure that the prepared "CropPixels.xlsx" file is provided as input to the relevant supporting function ("waterIntCrops.m").

Now, you are good to run the script
