# ASIC Quantification

Created by Dr Nicholas Condon from The Institute for Molecular Biosciences, The University of Queensland, Australia. (contact: n.condon@uq.edu.au)

This macro is written in the ImageJ macro language and can be run in [FIJI](http://fiji.sc). 

Details:<br> This script takes 3D images (3ch), sum projects them finds nuclei (DAPI/Ch3) and measures cytoplasm & nuclei intensity. <br><br>
Ch1 images are divided into two types, nuclei and cytoplasm, each regions area, mean and summed intensity are measured.
<br><br> Nuclei measurements can be output individually per row or as a summary of the entire image per row into the Results.xls file
<br><br> Output files are saved into a directory called [Results_date&time]


## Preventing the Bio-formats Importer window from displaying
The Bio-Formats opener window will pop-up for each image file unless you change the following within the Bio-Formats configuration panel.

1. Open FIJI
2. Navigate to Plugins > Bio-Formats > Bio-Formats Plugins Configuration
3. Select Formats
4. Select your desired file format (e.g. “Zeiss CZI”) and select “Windowless”
5. Close the Bio-Formats Plugins Configuration window

Now the importer window won’t open for this file-type. To restore this, simply untick ‘Windowless”

## Installing and Running the scripts
The easiest way to install these scripts is to download this entire Git and place it within the Plugins folder of FIJI. After a re-start you should see a new Plugins Menu called "ASIC QuantificationD" which will contain the 3 main macros. Alternatively you can download the Git and drag & drop the .ijm files onto the main FIJI window and select Run.


