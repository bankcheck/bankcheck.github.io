/*
 * Created on March 11, 2009
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.util.file;

import java.util.Hashtable;

/**
 * To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Generation - Code and Comments
 */
public class UploadMonitor {
	public static Hashtable uploadTable = new Hashtable();

	public static void set(String fName, UplInfo info) {
		uploadTable.put(fName, info);
	}

	public static void remove(String fName) {
		uploadTable.remove(fName);
	}

	public static UplInfo getInfo(String fName) {
		UplInfo info = (UplInfo) uploadTable.get(fName);
		return info;
	}
}
