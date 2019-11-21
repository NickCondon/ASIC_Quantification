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

## Installing and Running the script
The easiest way to install these scripts is to download this entire Git and place it within the Plugins folder of FIJI. After a re-start you should see a new Plugins Menu called "ASIC Quantification" which will contain the 3 main macros. Alternatively you can download the Git and drag & drop the .ijm files onto the main FIJI window and select Run.

### ASIC_Quantification.ijm
1. Run the script by either navigating to Plugins > ASIC_Quantification > ASIC_Quantification (if installed) or by dragging and dropping the ASIC_Quantification.ijm file onto the main FIJI window and selecting Run.

2. Read the acknowledgements window and select "OK"
<img src = "https://github.com/NickCondon/ASIC_Quantification/blob/master/Screenshots/AQ_Splash.png" width = "803" height = "604">
<br><br>
3. Read the directory warning to take note of your file extension
<img src = "https://github.com/NickCondon/ASIC_Quantification/blob/master/Screenshots/AQ_DirectoryWarning.png" width = "453" height = "169">
<br><br>
4. Navigate to your input directory of choice that contains your image files. (note sometimes FJIJ cannot display files within a directory, but the macro will still run provided there is image files within the directory).
<img src = "https://github.com/NickCondon/ASIC_Quantification/blob/master/Screenshots/AQ_InputDirectory.png" width = "707" height = "405">
<br><br>
5. Next the parameters dialog will open. Confirm your file extension type in the text field. Select whether you wish to have single summary values all nuclei per image (unchecked) or all individual nuclei output values listed (checked). Select either batch mode (runs in background; faster) is on or off.
<img src = "https://github.com/NickCondon/ASIC_Quantification/blob/master/Screenshots/AQ_Parameters.png" width = "288" height = "209">
<br><br>
6. ...
