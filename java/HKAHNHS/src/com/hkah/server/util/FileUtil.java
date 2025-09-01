package com.hkah.server.util;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;

public class FileUtil   {
	private static Logger logger = Logger.getLogger(FileUtil.class);

	public static Map<Integer, String> getARCardName(String arcCard, String filePath) {
		File file = new File(filePath);
		File[] listOfFiles = file.listFiles();
		Map<Integer, String> fileMap = new HashMap<Integer, String>();
		int j = 0;

		for (int i = 0; i < listOfFiles.length; i++) {
			if (listOfFiles[i].isFile()) {
				if (listOfFiles[i].getName().indexOf(arcCard)+arcCard.length()>0) {		
					if (arcCard.equals(listOfFiles[i].getName().substring(0, listOfFiles[i].getName().indexOf(arcCard)+arcCard.length()))) {
		    			j++;
		    			fileMap.put(new Integer(j), listOfFiles[i].getName());
		    		}		
//				} else if (listOfFiles[i].isDirectory()) {
//						      System.out.println("Directory " + listOfFiles[i].getName());
				}
			}
		}
		return fileMap;
	}
}