print("\\Clear")

//	MIT License

//	Copyright (c) 2019 Nicholas Condon n.condon@uq.edu.au

//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:

//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.

//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//	SOFTWARE.


//IMB Macro Splash screen (Do not remove this acknowledgement)
scripttitle="ASIC Quantification";
version="1.0";
versiondate="10/09/2019";
description="Details: <br> This script takes 3D images (3ch), sum projects them finds nuclei (DAPI/Ch3) and measures cytoplasm & nuclei intensity. <br><br> "
+"Ch1 images are divided into two types, nuclei and cytoplasm, each regions area, mean and summed intensity are measured."
+"<br><br> Nuclei measurements can be output individually per row or as a summary of the entire image per row into the Results.xls file"
+"<br><br> Output files are saved into a directory called [Results_date&time]"

print("FIJI Macro: "+scripttitle);																//Prints script title to log window
print("Version: "+version+" ("+versiondate+")");												//Prints script version & version date to log window
print("ACRF: Cancer Biology Imaging Facility");													//Prints script acknowledgement to log window								
print("By Nicholas Condon (2019) n.condon@uq.edu.au")											//Prints script acknowledgement to log window
print("");																						//Prints linespace to log window
																	
//IMB script dialog box (Do not remove this acknowledgement).
    showMessage("Institute for Molecular Biosciences ImageJ Script", "<html>" 
    +"<h1><font size=6 color=Teal>ACRF: Cancer Biology Imaging Facility</h1>
    +"<h1><font size=5 color=Purple><i>The Institute for Molecular Bioscience <br> The University of Queensland</i></h1>
    +"<h4><a href=http://imb.uq.edu.au/Microscopy/>ACRF: Cancer Biology Imaging Facility</a><\h4>"
    +"<h1><font color=black>ImageJ Script Macro: "+scripttitle+"</h1> "
    +"<p1>Version: "+version+" ("+versiondate+")</p1>"
    +"<H2><font size=3>Created by Nicholas Condon</H2>"	
    +"<p1><font size=2> contact n.condon@uq.edu.au \n </p1>" 
    +"<P4><font size=2> Available for use/modification/sharing under the "+"<p4><a href=https://opensource.org/licenses/MIT/>MIT License</a><\h4> </P4>"
    +"<h3>   <\h3>"    
    +"<p1><font size=3 \b i>"+description+"</p1>"
   	+"<h1><font size=2> </h1>"  
	+"<h0><font size=5> </h0>"
    +"");


Dialog.create("Choosing your working directory.");												//Directory Warning and Instruction panel     
 	Dialog.addMessage("Use the next window to navigate to the directory of your images.");
		
  	Dialog.addMessage("(Note a sub-directory will be made within this folder) ");
  	Dialog.addMessage("Take note of your file extension (eg .tif, .czi)");
 	Dialog.show(); 
 
run("Set Measurements...", "area mean standard median display redirect=None decimal=3");		//Defines the measurements required for this script
run("Clear Results");																			//Clears any results from the results window
roiManager("Reset");																			//Deletes any ROIs from the manager

	
path = getDirectory("Choose Source Directory ");												//Variable for directory
list = getFileList(path);																		//Variable for file list
xlsVar = 2; 																					//Variable for excel row calculations (excludes title row)



ext = ".czi"; 																					//VAR = file extension[string]
  Dialog.create("Choosing your settings");														//Dialogue requesting user input settings
  	Dialog.addString("File Extension:", ext);													//Dialogue requesting file extension
 	Dialog.addMessage("(For example .czi  .lsm  .nd2  .lif  .ims)");
 	Dialog.addCheckbox("Output individual nuclei intensity", 0)									//Dialogue requesting band spacing size
  	Dialog.addCheckbox("Run in batch mode (Background)", true);									//Dialogue toggle for batch (background mode)
  	Dialog.show();
  	ext = Dialog.getString();																	//VAR = file extension[string]										
	unique = Dialog.getCheckbox();																//VAR = unique nuclei export[boolean]
	batch=Dialog.getCheckbox();																	//VAR = batch mode status[boolean]

	print("**********  Parameters  **********");												//Prints user settings to the log window
	print("Working directory: "+path);															//Prints directory location to the log window
	print("Chosen file extension: "+ext);														//Prints chosen file extension to the log window
	if(unique ==1 ){print("Individual nuclei output: ON");}										//Prints that output file will be 1 line per nuclei
	if(unique ==0 ){print("Individual nuclei output: OFF");}	
								//Prints that output file will have a summary per image
	
if (batch==1){																					//Batch mode conditional run
	setBatchMode(true);																			//Turns on background mode
	print("Running In batch mode.");															//Prints to the log that batch mode is enabled
	}

	
getDateAndTime(year, month, week, day, hour, min, sec, msec);									//Obtaining date and time 
print("Script Run Date: "+day+"/"+(month+1)+"/"+year+"  Time: " +hour+":"+min+":"+sec);			//Prints the script run time and date to the log window
start = getTime();																				//Starts the script timer
print("********************************");														//Prints user settings to the log window

print("");																						//Prints a linespace to the log window	

resultsDir = path+"Results"+year+"-"+(month+1)+"-"+day+"__"+hour+"."+min+"."+sec+"/";			//VAR = location of the results directory within the working directory[string]

File.makeDirectory(resultsDir);																	//Creates an output directory with the name using the VAR=resultsDir
summaryFile = File.open(resultsDir+"Results.xls");												//Creates a results file named Results.xls
print(summaryFile,"Filename \t Nuclei # \t Number of Nuclei \t Total Image Area \t Ch1 Thresholded Area \t Nuclei Intensity \t Total Ch1 Intensity \t Cyto Ch1 Intensity \t \t Normalised Cyto Intensity (CytoI/numNuc) \t Normalised Cyto Area (CytoA/numNuc)");	//Prints title columns into Results.xls



for (z=0; z<list.length; z++) {																	//Main script loop. Repeats for total number of files in working directory
if (endsWith(list[z],ext)){																		//Secondary script loop. Only opens files with the given file extension
 		print("Opening File "+(z+1)+" of "+list.length+" total files");							//Prints the current file number (and total file number) to the log window
 		open(path+list[z]);																		//Opens the zth file in directory
		windowtitle = getTitle();																//VAR = file name [string]
		windowtitlenoext = replace(windowtitle, ext, "");										//VAR = file name with no extension[string]
		getDimensions(width, height, channels, slices, frames);									//Gets Image Dimensions
		if(slices>1){run("Z Project...", "projection=[Sum Slices]");}							//Sum Projection if conditional
			rename("Zprojectwindowtitle");														//Renames window "Zprojectwindowtitle"
			run("Duplicate...", "title=nuc duplicate channels=3");								//Duplicates the 3rd channel (nuclei)
			run("Median...", "radius=2");														//Performs median filter
			setAutoThreshold("Triangle dark");													//Performs Threshold[Triangle]
			//setThreshold(7, 255);
			setOption("BlackBackground", true);													//Defines background
			run("Convert to Mask");																//Converts to binary
			run("Analyze Particles...", "size=50-Infinity show=Masks display exclude clear add");//Analyses Nuclei and adds to ROI manager
			rename("nucMask");																	//Renames Nuclei window name
			saveAs("tiff", resultsDir+windowtitlenoext+"_nuclei-selection.tif");				//Saves Nuclei output mask to outputDir
			rename("nucMask");																	//Renames Nuclei window name
			run("Invert");																		//Inverts binary image
			numNuc = nResults;																	//VAR = variable for the number of nuclei found[number]
			print("The number of nuclei detected = "+numNuc);									//Prints the number of nuclei found

			selectWindow("Zprojectwindowtitle");												//Selects Zprojectwindowtitle image
			run("Duplicate...", "title=ch1 duplicate channels=1");								//Duplicates channel 1

			run("Clear Results");																//Clears the results window
			if (numNuc >= 1) {																	//Loop for if one of more nuclei was found
				nucI = newArray(numNuc);														//ARRAY = array for nuclei intensity (number of nuclei long)

				selectWindow("ch1");															//Selects the Ch1 window (red)
				roiManager("Measure");															//Measures every nuclei found as defined by ROI list	
				for (r=0; r<numNuc; r++){														//Loop for scraping results window into arrays
					nucI[r] = getResult("Mean",r);												//Collects "Mean" (intensity) of the nuclei region and places it into ARRAY
					}
				roiManager("Save", resultsDir+ windowtitlenoext + "_nuclei.zip");				//Saves Nuclei ROIs as a .zip into the results directory with the file name appended
				print("Saving nuclei ROI list");												//Prints ROI of nuclei has saved to the log window
				}
			run("Clear Results");																//Clears the results window

			selectWindow("ch1");																//Selects the Ch1 window (red)
			run("Measure");																		//Performs whole image measurement
			imageA = getResult("Area",0);														//VAR = area measurement of whole image[number]
			totalCh1Int = (getResult("Area",0)*getResult("Mean",0));							//VAR = total Ch1 intensity[number]
			print("The total Ch1 summed intensity = "+totalCh1Int);								//Prints the total summed intensity to log window	
			run("Clear Results");																//Clears the results window

			selectWindow("nucMask");															//Selects nuclei mask
			run("Subtract...", "value=254");													//Converts to 0-1 binary
			imageCalculator("Multiply create", "ch1","nucMask");								//Mask removal of nuclei regions
			rename("ch1cyto");																	//Renames image to "ch1cyto"

			run("Measure");																		//Performs whole image measurement
			cytoCh1Int = (getResult("Area",0)*getResult("Mean",0));								//VAR = Ch1 summed intensity[number]
			print("The cytoplasmic ch1 summed intensity of = "+cytoCh1Int);						//Prints Ch1 summed intensity to log window 
			run("Clear Results");																//Clears the results window

			selectWindow("ch1cyto");															//Selects masked cytoplasm image
			run("Subtract Background...", "rolling=20");										//background subtraction for 'dot selection'
			setAutoThreshold("IsoData dark");													//Performs threshold[IsoData]
			//setThreshold(29, 255);	
			run("Convert to Mask");																//Converts to mask
			run("Measure");																		//Measures Binary image
			ch1area = ((getResult("Area",0)*getResult("Mean",0)/255));							//VAR = number of detected cytoplasm pixels as area[number]
			print("Total Ch1 area = "+ch1area);													//Prints cytoplasm pixel area

			if (unique ==1){																	//Loop if unique nuclei measurements are required
				for (j=0 ; j<numNuc ; j++) {  													//Loop for pulling values from the arrays into single lines for excel output
    				nucInt = nucI[j];															//VAR = temporary placeholder for the output vales from the nuclei intensity ARRAY[number]
    				cytoInt = cytoCh1Int;														//VAR = temporary placeholder for the output vales from the cytoplasm intensity ARRAY[number]
    				totCh1Int = totalCh1Int;													//VAR = temporary placeholder for the output vales from the summed cytoplasm intensity ARRAY[number]
    				CH1Area = ch1area;															//VAR = temporary placeholder for the output vales from the cytoplasm intensity ARRAY[number]
    				nuccount = j+1;																//VAR = temporary placeholder for the output counter (increasing from base 0)[number]
    				print(summaryFile,windowtitle+"\t"+nuccount+"\t"+numNuc+"\t"+imageA+"\t"+CH1Area+"\t"+nucInt+"\t"+totCh1Int+"\t"+cytoCh1Int+"\t"+"\t=G"+xlsVar+"/C"+xlsVar+"\t=E"+xlsVar+"/C"+xlsVar); //Prints the measurements and details into the Results.xls as well as performing two calculations
  	   				xlsVar = xlsVar + 1;														//Updates the VAR = xlsVar to be one higher for the next rows calculations
  	   				}
  	   			}	

			if (unique ==0){																	//Loop for summarised output data
				Array.getStatistics(nucI, min, max, mean, stdDev);	nucInt = mean;				//Performs statistics on Array of nuclei intensities [nuc1]
	  	   		cytoInt = cytoCh1Int;															//VAR = temporary placeholder for the output vales from the cytoplasm intensity ARRAY[number]
	  	   		totCh1Int = totalCh1Int;														//VAR = temporary placeholder for the output vales from the summed cytoplasm intensity ARRAY[number]
	  	   		CH1Area = ch1area;																//VAR = temporary placeholder for the output vales from the cytoplasm intensity ARRAY[number]
    			nuccount = "N/A";																//VAR = temporary placeholder for the output counter (increasing from base 0)
    			print(summaryFile,windowtitle+"\t"+nuccount+"\t"+numNuc+"\t"+imageA+"\t"+CH1Area+"\t"+nucInt+"\t"+totCh1Int+"\t"+cytoCh1Int+"\t"+"\t=G"+xlsVar+"/C"+xlsVar+"\t=H"+xlsVar+"/D"+xlsVar); //Prints the measurements and details into the Results.xls as well as performing two calculations
  	   			xlsVar = xlsVar + 1;															//Updates the VAR = xlsVar to be one higher for the next rows calculations
				}


			selectWindow("Zprojectwindowtitle");												//Selects the Zprojected Image
			saveAs("tiff", resultsDir+windowtitlenoext+"_ZprojectedImage.tif");					//Saves image to OutputDir
 			print("Saving Zprojected image"); 													//Prints saving status to the log window
 			close();																			//Closes image window
 			selectWindow("ch1cyto");															//Selects the masked cytoplasmic image
 			run("Invert");																		//changes LUT
 			saveAs("tiff", resultsDir+windowtitlenoext+"_Ch1-cytoMasked.tif");					//Saving the masked cytoplasmic image
 			print("Saving masked Cytoplasmic image");											//Prints saving status to the log window
 			close();																			//Closes image window

 			while (nImages > 0){close();}														//Closes any remaining open windows
			print("All outputs saved and closed");												//Prints all windows closed to the log window
			print("");																			//Prints a line space to the log window
		}		
		roiManager("reset");																	//Removes any ROIs from the ROI manager
	}																							//End of all file loops

print("Batch Completed");print("Total Runtime was:");print((getTime()-start)/1000); 			//Prints run stats to the log window
selectWindow("Log");																			//Selects the log window
saveAs("Text", resultsDir+"Log.txt");															//Saves the log window
title = "Batch Completed"; msg = "Put down that coffee! Your job is finished";					//VARs = Dialog window text[sting]
waitForUser(title, msg);  																		//Displays dialogue to user
//end of script
										
