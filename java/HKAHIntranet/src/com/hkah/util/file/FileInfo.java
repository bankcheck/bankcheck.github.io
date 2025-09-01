/*
 * Created on March 11, 2009
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.util.file;

import java.io.File;

/**
 * To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Generation - Code and Comments
 */
public class FileInfo {
	public String name = null, clientFileName = null, fileContentType = null;

	private byte[] fileContents = null;

	public File file = null;

	public StringBuffer sb = new StringBuffer(100);

	public void setFileContents(byte[] aByteArray) {
		fileContents = new byte[aByteArray.length];
		System.arraycopy(aByteArray, 0, fileContents, 0, aByteArray.length);
	}
}
