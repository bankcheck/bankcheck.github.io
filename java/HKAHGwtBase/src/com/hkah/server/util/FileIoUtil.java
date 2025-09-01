package com.hkah.server.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.Reader;
import java.io.StringWriter;
import java.io.Writer;

import jcifs.smb.SmbFile;
import jcifs.smb.SmbFileOutputStream;

import org.apache.commons.io.FileUtils;

public class FileIoUtil {
	public static final String PROTOCOL_SMB = "smb:";
	private static String sysOSName = System.getProperty("os.name").toLowerCase();
	private static boolean isLinux = sysOSName.indexOf("nix") >= 0 || 
			sysOSName.indexOf("nux") >= 0 || sysOSName.indexOf("aix") > 0;
			
	public static String convertStreamToString(InputStream is) 
	throws IOException {
	//
	// To convert the InputStream to String we use the
	// Reader.read(char[] buffer) method. We iterate until the
	// Reader return -1 which means there's no more data to
	// read. We use the StringWriter class to produce the string.
	//
	if (is != null) {
	    Writer writer = new StringWriter();
	
	    char[] buffer = new char[1024];
	    try {
	        Reader reader = new BufferedReader(
	                new InputStreamReader(is, "UTF-8"));
	        int n;
	        while ((n = reader.read(buffer)) != -1) {
	            writer.write(buffer, 0, n);
	        }
	    } finally {
	        is.close();
	    }
	    return writer.toString();
	} else {        
	    return null;
	}
}
	
	/*
	 * should use apache commons-io ver 2.4  FileUtils.copyInputStreamToFile
	 */
	public static File copyInputStreamToFile(InputStream is, String outFilePath) 
			throws IOException {
		File f = new File(outFilePath);
		if (!f.exists()) {
			FileUtils.touch(f);
		}
		OutputStream out = new FileOutputStream(f);
		byte buf[] = new byte[1024];
		int len;
		while((len = is.read(buf))>0)
			out.write(buf, 0,len);
		out.close();
		is.close();
		 
		return f;
	}
	
	public static OutputStream getOutputStream(String filePath) {
		OutputStream os = null;
		
		boolean isUNCPath = false;
		if (filePath != null && filePath.startsWith("\\\\")) {
			isUNCPath = true;
		}
		//System.out.println("[DEBUG] FileIoUtil.getOutputStream filePath="+filePath+
		//		", isLinux="+isLinux+", isUNCPath="+isUNCPath);
		
		try {
			if (isLinux && isUNCPath) {
				String smbPath = filePath.substring(2, filePath.length());
				smbPath = smbPath.replaceAll("\\\\", "/");
				String dir = null;
				int idx = smbPath.lastIndexOf("/");
				if (idx < 0) {
					idx = smbPath.lastIndexOf("\\");
				}
				if (idx >= 0) {
					dir = smbPath.substring(0, idx);
				}
				String smbDir = PROTOCOL_SMB + "//" + dir+ "/";
				smbPath = PROTOCOL_SMB + "//" + smbPath;
				
				SmbFile destinationDir = null;
				if (dir != null) {
					destinationDir = new SmbFile(smbDir, AuthUtil.getDefaultSmbAuth());
				}
				SmbFile destinationFile = new SmbFile(smbPath, AuthUtil.getDefaultSmbAuth());
				
				if (!destinationFile.exists()) {
					if (destinationDir != null && !destinationDir.isDirectory()) {
						destinationDir.mkdirs();
					}
					destinationFile.createNewFile();
				}
				
				os = new SmbFileOutputStream(destinationFile);
			} else {
				os = new FileOutputStream(filePath);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return os;
	}
	
	public static SmbFile getSmbFile(String filePath, boolean createIfNotExists) {
		SmbFile smbFile = null;
		try {
				String smbPath = filePath.substring(2, filePath.length());
				smbPath = smbPath.replaceAll("\\\\", "/");
				String dir = null;
				int idx = smbPath.lastIndexOf("/");
				if (idx < 0) {
					idx = smbPath.lastIndexOf("\\");
				}
				if (idx >= 0) {
					dir = smbPath.substring(0, idx);
				}
				String smbDir = PROTOCOL_SMB +  "//" + dir+ "/";
				smbPath = PROTOCOL_SMB +  "//" + smbPath;
				
				SmbFile destinationDir = null;
				if (dir != null) {
					destinationDir = new SmbFile(smbDir, AuthUtil.getDefaultSmbAuth());
				}
				smbFile = new SmbFile(smbPath, AuthUtil.getDefaultSmbAuth());
				
				if (!smbFile.exists() && createIfNotExists) {
					if (destinationDir != null && !destinationDir.isDirectory()) {
						destinationDir.mkdirs();
					}
					smbFile.createNewFile();
				}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return smbFile;
	}
}
