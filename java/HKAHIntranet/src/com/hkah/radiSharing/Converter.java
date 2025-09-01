package com.hkah.radiSharing;

import java.awt.image.BufferedImage;
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.rendering.ImageType;
import org.apache.pdfbox.rendering.PDFRenderer;
import org.apache.pdfbox.tools.imageio.ImageIOUtil;
 
public class Converter {
	public static int convertPDF2SWF(String sourcePath,String swfHostSite) throws IOException {
		File source = new File(sourcePath);
		if (!source.exists()) {
			return 0;
		}
		
		String output = swfHostSite+sourcePath.substring(sourcePath.lastIndexOf("\\")+1, sourcePath.lastIndexOf("."))+".swf";
		
		String cmd2swf= "C:\\SWFTools\\pdf2swf.exe -i "+sourcePath+" -o "+output;
		String cmdCombineViewer = "C:\\SWFTools\\swfcombine.exe C:\\SWFTools\\rfxview.swf viewport=\""+output+"\" -o "+output;
		System.out.println("cmd:"+cmd2swf);
		if (runProcess(cmd2swf) == 0) {
			System.out.println("cmd:"+cmdCombineViewer);
		}
		
		runProcess(cmdCombineViewer);
 
		return 1;
	}
	
	private static int runProcess(String cmd) throws IOException {
		Process process = Runtime.getRuntime().exec(cmd); 
		final InputStream is1 = process.getInputStream();
		new Thread(new Runnable() {
			public void run() {
				BufferedReader br = new BufferedReader(new InputStreamReader(is1));
				try {
					while(br.readLine()!= null) ;
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}).start();
		InputStream is2 = process.getErrorStream();
		BufferedReader br2 = new BufferedReader(new InputStreamReader(is2));
		StringBuilder buf = new StringBuilder(); 
		String line = null;
		while((line = br2.readLine()) != null) {
			buf.append(line);
		}
		System.out.println("The output is:" + buf);
 
		// BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(pro.getInputStream()));
		while (br2.readLine() != null);
 
		try {
			process.waitFor();
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return process.exitValue();
	}
	
	public static ArrayList<String> convertPdfToImage(String sourceDir, String destinationDir,int dpi) throws IOException{	
		ArrayList<String> listOfImagePath = new ArrayList<String>();
		String fileName = sourceDir.substring(sourceDir.lastIndexOf("\\")+1, sourceDir.lastIndexOf("."));
		try {

	        PDDocument document = PDDocument.load(new File(sourceDir));
	        PDFRenderer pdfRenderer = new PDFRenderer(document);
	        //String fileName = java.util.UUID.randomUUID().toString();
	        for (int page = 0; page < document.getNumberOfPages(); ++page) { 
	            BufferedImage bim = pdfRenderer.renderImageWithDPI(page, dpi, ImageType.RGB);
	            
	            // suffix in filename will be used as the file format	            
	            if(ImageIOUtil.writeImage(bim, destinationDir + fileName+"_"+(page+1) + ".png", dpi)){
	            	listOfImagePath.add((page+1) + ".png");
	            }
	        }
	        document.close();

	    } catch (Exception e) {
	        e.printStackTrace();		    
	    }	    
		return listOfImagePath;
	}
}
