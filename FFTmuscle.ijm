#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "File suffix", value = ".czi") suffix

//setBatchMode(true); 
processFolder(input);

// function to scan folders/subfolders/files to find files with correct suffix
function processFolder(input) {
	list = getFileList(input);
	list = Array.sort(list);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(input + File.separator + list[i]))
			processFolder(input + File.separator + list[i]);
		if(endsWith(list[i], suffix))
			processFile(input, output, list[i]);
	}
}

function processFile(input, output, file) {
	open(input + File.separator + list[i]);
	run("8-bit");
	Title=getTitle();
	run("Median...", "radius=1");
	run("Split Channels");
	selectWindow("C2-" + Title);
	close();
	selectWindow("C3-" + Title);
	saveAs("JPEG", output + "/" + Title + " R.jpeg");
	rename(Title + " Red");
	TitleR=getTitle();
	selectWindow("C1-" + Title);
	saveAs("JPEG", output + "/" + Title + " G.jpeg");
	rename(Title + " Green");
	TitleG=getTitle();
	
	selectWindow(TitleG);
	run("FFT");

	waitForUser;
	setTool("rectangle");
	selectWindow("FFT of " + TitleG);

	run("Inverse FFT");
		selectWindow(TitleG);
		close();
		selectWindow("FFT of " + TitleG);
		close();
	selectWindow("Inverse FFT of " + TitleG);

	saveAs("JPEG", output + "/" + Title + " Green processed.jpeg");
	setAutoThreshold("MaxEntropy dark");
	selectWindow("Inverse FFT of " + TitleG);
	rename(TitleG);
	run("Convert to Mask");
	run("Median...", "radius=1");
	run("Duplicate...", " ");
	run("Green");

	saveAs("JPEG", output + "/" + Title + " Green count.jpeg");
	rename(TitleG + " Green count");	
	Title1=getTitle();
//	close();
	selectWindow(TitleG);
	run("Watershed");

	run("Analyze Particles...", "size=0.05-20000 circularity=0-1.00 show=Outlines summarize");
	saveAs("JPEG", output + "/" + TitleG + ".jpeg");
 	close();	
	
	selectWindow(TitleR);

	run("FFT");
	waitForUser;
	setTool("rectangle");
	selectWindow("FFT of " + TitleR);
	run("Inverse FFT");
		selectWindow(TitleR);
		close();
		selectWindow("FFT of " + TitleR);
		close();
	selectWindow("Inverse FFT of " + TitleR);
	saveAs("JPEG", output + "/" + Title + " Red processed.jpeg");

	setAutoThreshold("MaxEntropy dark");	
	selectWindow("Inverse FFT of " + TitleR);

	rename(TitleR);	
 	run("Convert to Mask");
 	run("Median...", "radius=1");
 	run("Duplicate...", " ");
	run("Red");

	saveAs("JPEG", output + "/" + Title + " Red count.jpeg");
	rename(TitleR + " Red count");	
	Title2=getTitle();
	
	selectWindow(TitleR);
	run("Watershed");
	run("Analyze Particles...", "size=0.05-20000 circularity=0-1.00 show=Outlines summarize");
	saveAs("JPEG", output + "/" + TitleR + ".jpeg");
 	close();	
	
	selectWindow(TitleR);
	
	imageCalculator("AND create", TitleG, TitleR);
	saveAs("JPEG", output + "/" + Title + " overlap.jpeg");
	rename(Title);
	run("Analyze Particles...", "size=0.05-20000 circularity=0-1.00 show=Outlines summarize");
	rename(Title + "overlap");
	saveAs("JPEG", output + "/" + Title + " overlap result.jpeg");

	run("Merge Channels...", "c1=[" + Title2 + "] c2=[" + Title1 + "] create");
	saveAs("JPEG", output + "/" + Title + " overlap merged.jpeg");
	
	run("Close All");
			
		}

//setBatchMode(false); 