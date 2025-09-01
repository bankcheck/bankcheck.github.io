package com.hkah.server.services;

import java.io.File;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.io.FileUtils;

import com.google.gwt.user.server.rpc.RemoteServiceServlet;
import com.hkah.client.services.FileIOUtilService;
import com.hkah.server.util.FileUtil;

@SuppressWarnings("serial")
public class FileIOUtilServiceImpl extends RemoteServiceServlet implements FileIOUtilService {

	public Map<Integer, String> getARCardName(String arcCard, String filePath) {
		return FileUtil.getARCardName(arcCard, filePath);
	}

	public Map<String, String> listFile(String filePath, String[] fileExts, boolean recursive) {
		Collection<File> list = null;
		try {
			list = FileUtils.listFiles(new File(filePath), fileExts, false);
		} catch (Exception ex) {}
		Map<String, String> files = new HashMap<String, String>(); 
		if (list != null) {
			for (File f : list) {
				files.put(filePath + "\\" + f.getName(), f.getName());
			}
		}
		return files;
	}
}