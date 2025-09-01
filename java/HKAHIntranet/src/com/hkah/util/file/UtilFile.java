/*
 * Created on March 11, 2009
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.util.file;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FilenameFilter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.sql.Blob;
import java.text.DateFormat;
import java.util.Date;
import java.util.StringTokenizer;
import java.util.Vector;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import jcifs.smb.NtlmPasswordAuthentication;
import jcifs.smb.SmbException;
import jcifs.smb.SmbFile;
import jcifs.smb.SmbFileInputStream;
import jcifs.smb.SmbFileOutputStream;
import jcifs.smb.SmbFilenameFilter;

import com.hkah.util.ServerUtil;
import com.hkah.web.db.CMSDB;

/**
 * To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Generation - Code and Comments
 */
public class UtilFile {
	// FEATURES
	public static final boolean NATIVE_COMMANDS = true;

	/**
	 * If true, all operations (besides upload and native commands) which change
	 * something on the file system are permitted
	 */
	public static final boolean READ_ONLY = false;

	// If true, uploads are allowed even if READ_ONLY = true
	public static final boolean ALLOW_UPLOAD = true;

	// Allow browsing and file manipulation only in certain directories
	public static final boolean RESTRICT_BROWSING = false;

	// If true, the user is allowed to browse only in RESTRICT_PATH,
	// if false, the user is allowed to browse all directories besides
	// RESTRICT_PATH
	public static final boolean RESTRICT_WHITELIST = false;

	// Paths, sperated by semicolon
	// public static final String RESTRICT_PATH = "C:\\CODE;E:\\"; //Win32:
	// Case important!!
	public static final String RESTRICT_PATH = "/etc;/var";

	// The refresh time in seconds of the upload monitor window
	public static final int UPLOAD_MONITOR_REFRESH = 2;

	// The number of colums for the edit field
	public static final int EDITFIELD_COLS = 85;

	// The number of rows for the edit field
	public static final int EDITFIELD_ROWS = 30;

	// Open a new window to view a file
	public static final boolean USE_POPUP = true;

	/**
	 * If USE_DIR_PREVIEW = true, then for every directory a tooltip will be
	 * created (hold the mouse over the link) with the first DIR_PREVIEW_NUMBER
	 * entries. This can yield to performance issues. Turn it off, if the
	 * directory loads to slow.
	 */
	public static final boolean USE_DIR_PREVIEW = false;

	public static final int DIR_PREVIEW_NUMBER = 10;

	/**
	 * The name of an optional CSS Stylesheet file
	 */
	public static final String CSS_NAME = "Browser.css";

	/**
	 * The compression level for zip file creation (0-9) 0 = No compression 1 =
	 * Standard compression (Very fast) ... 9 = Best compression (Very slow)
	 */
	public static final int COMPRESSION_LEVEL = 1;

	/**
	 * The FORBIDDEN_DRIVES are not displayed on the list. This can be usefull,
	 * if the server runs on a windows platform, to avoid a message box, if you
	 * try to access an empty removable drive (See KNOWN BUGS in Readme.txt).
	 */
	public static final String[] FORBIDDEN_DRIVES = { "a:\\" };

	/**
	 * Command of the shell interpreter and the parameter to run a programm
	 */
	public static final String[] COMMAND_INTERPRETER = { "cmd", "/C" }; // Dos,Windows

	// public static final String[] COMMAND_INTERPRETER = {"/bin/sh","-c"}; // Unix

	/**
	 * Max time in ms a process is allowed to run, before it will be terminated
	 */
	public static final long MAX_PROCESS_RUNNING_TIME = 30 * 1000; // 30 seconds

	// Button names
	public static final String SAVE_AS_ZIP = "Download selected files as (z)ip";

	public static final String RENAME_FILE = "(R)ename File";

	public static final String DELETE_FILES = "(Del)ete selected files";

	public static final String CREATE_DIR = "Create (D)ir";

	public static final String CREATE_FILE = "(C)reate File";

	public static final String MOVE_FILES = "(M)ove Files";

	public static final String COPY_FILES = "Cop(y) Files";

	public static final String LAUNCH_COMMAND = "(L)aunch external program";

	public static final String UPLOAD_FILES = "Upload";

	// Normally you should not change anything after this line
	// ----------------------------------------------------------------------------------
	// Change this to locate the tempfile directory for upload (not longer
	// needed)
	public static String tempdir = ".";

	public static String VERSION_NR = "1.2";

	public static DateFormat dateFormat = DateFormat.getDateTimeInstance();

	public static Vector expandFileList(String[] files, boolean inclDirs) {
		Vector v = new Vector();
		if (files == null)
			return v;
		for (int i = 0; i < files.length; i++)
			v.add(new File(URLDecoder.decode(files[i])));
		for (int i = 0; i < v.size(); i++) {
			File f = (File) v.get(i);
			if (f.isDirectory()) {
				File[] fs = f.listFiles();
				for (int n = 0; n < fs.length; n++)
					v.add(fs[n]);
				if (!inclDirs) {
					v.remove(i);
					i--;
				}
			}
		}
		return v;
	}

	/**
	 * Method to build an absolute path
	 * 
	 * @param dir
	 *            the root dir
	 * @param name
	 *            the name of the new directory
	 * @return if name is an absolute directory, returns name, else returns
	 *         dir+name
	 */
	public static String getDir(String dir, String name) {
		if (!dir.endsWith(File.separator))
			dir = dir + File.separator;
		File mv = new File(name);
		String new_dir = null;
		if (!mv.isAbsolute()) {
			new_dir = dir + name;
		} else
			new_dir = name;
		return new_dir;
	}

	/**
	 * This Method converts a byte size in a kbytes or Mbytes size, depending on
	 * the size
	 * 
	 * @param size
	 *            The size in bytes
	 * @return String with size and unit
	 */
	public static String convertFileSize(long size) {
		int divisor = 1;
		String unit = "bytes";
		if (size >= 1024 * 1024) {
			divisor = 1024 * 1024;
			unit = "MB";
		} else if (size >= 1024) {
			divisor = 1024;
			unit = "KB";
		}
		if (divisor == 1)
			return size / divisor + " " + unit;
		String aftercomma = "" + 100 * (size % divisor) / divisor;
		if (aftercomma.length() == 1)
			aftercomma = "0" + aftercomma;
		return size / divisor + "." + aftercomma + " " + unit;
	}

	/**
	 * Copies all data from in to out
	 * 
	 * @param in
	 *            the input stream
	 * @param out
	 *            the output stream
	 * @param buffer
	 *            copy buffer
	 */
	public static void copyStreams(InputStream in, OutputStream out,
			byte[] buffer) throws IOException {
		copyStreamsWithoutClose(in, out, buffer);
		in.close();
		out.close();
	}

	/**
	 * Copies all data from in to out
	 * 
	 * @param in
	 *            the input stream
	 * @param out
	 *            the output stream
	 * @param buffer
	 *            copy buffer
	 */
	public static void copyStreamsWithoutClose(InputStream in,
			OutputStream out, byte[] buffer) throws IOException {
		int b;
		while ((b = in.read(buffer)) != -1)
			out.write(buffer, 0, b);
	}

	/**
	 * Returns the Mime Type of the file, depending on the extension of the
	 * filename
	 */
	public static String getMimeType(String fName) {
		fName = fName.toLowerCase();
		if (fName.endsWith(".jpg") || fName.endsWith(".jpeg")
				|| fName.endsWith(".jpe"))
			return "image/jpeg";
		else if (fName.endsWith(".gif"))
			return "image/gif";
		else if (fName.endsWith(".pdf"))
			return "application/pdf";
		else if (fName.endsWith(".htm") || fName.endsWith(".html")
				|| fName.endsWith(".shtml"))
			return "text/html";
		else if (fName.endsWith(".avi"))
			return "video/x-msvideo";
		else if (fName.endsWith(".mov") || fName.endsWith(".qt"))
			return "video/quicktime";
		else if (fName.endsWith(".mpg") || fName.endsWith(".mpeg")
				|| fName.endsWith(".mpe"))
			return "video/mpeg";
		else if (fName.endsWith(".zip"))
			return "application/zip";
		else if (fName.endsWith(".tiff") || fName.endsWith(".tif"))
			return "image/tiff";
		else if (fName.endsWith(".rtf"))
			return "application/rtf";
		else if (fName.endsWith(".mid") || fName.endsWith(".midi"))
			return "audio/x-midi";
		else if (fName.endsWith(".xl") || fName.endsWith(".xls")
				|| fName.endsWith(".xlv") || fName.endsWith(".xla")
				|| fName.endsWith(".xlb") || fName.endsWith(".xlt")
				|| fName.endsWith(".xlm") || fName.endsWith(".xlk"))
			return "application/excel";
		else if (fName.endsWith(".doc") || fName.endsWith(".dot"))
			return "application/msword";
		else if (fName.endsWith(".png"))
			return "image/png";
		else if (fName.endsWith(".xml"))
			return "text/xml";
		else if (fName.endsWith(".svg"))
			return "image/svg+xml";
		else if (fName.endsWith(".mp3"))
			return "audio/mp3";
		else if (fName.endsWith(".ogg"))
			return "audio/ogg";
		else
			return "text/plain";
	}

	/**
	 * Converts some important chars (int) to the corresponding html string
	 */
	public static String conv2Html(int i) {
		if (i == '&')
			return "&amp;";
		else if (i == '<')
			return "&lt;";
		else if (i == '>')
			return "&gt;";
		else if (i == '"')
			return "&quot;";
		else
			return "" + (char) i;
	}

	/**
	 * Converts a normal string to a html conform string
	 */
	public static String conv2Html(String st) {
		StringBuffer buf = new StringBuffer();
		for (int i = 0; i < st.length(); i++) {
			buf.append(conv2Html(st.charAt(i)));
		}
		return buf.toString();
	}

	/**
	 * Starts a native process on the server
	 * 
	 * @param command
	 *            the command to start the process
	 * @param dir
	 *            the dir in which the process starts
	 */
	public static String startProcess(String command, String dir)
			throws IOException {
		StringBuffer ret = new StringBuffer();
		String[] comm = new String[3];
		comm[0] = COMMAND_INTERPRETER[0];
		comm[1] = COMMAND_INTERPRETER[1];
		comm[2] = command;
		long start = System.currentTimeMillis();
		try {
			// Start process
			Process ls_proc = Runtime.getRuntime().exec(comm, null,
					new File(dir));
			// Get input and error streams
			BufferedInputStream ls_in = new BufferedInputStream(ls_proc
					.getInputStream());
			BufferedInputStream ls_err = new BufferedInputStream(ls_proc
					.getErrorStream());
			boolean end = false;
			while (!end) {
				int c = 0;
				while ((ls_err.available() > 0) && (++c <= 1000)) {
					ret.append(conv2Html(ls_err.read()));
				}
				c = 0;
				while ((ls_in.available() > 0) && (++c <= 1000)) {
					ret.append(conv2Html(ls_in.read()));
				}
				try {
					ls_proc.exitValue();
					// if the process has not finished, an exception is thrown
					// else
					while (ls_err.available() > 0)
						ret.append(conv2Html(ls_err.read()));
					while (ls_in.available() > 0)
						ret.append(conv2Html(ls_in.read()));
					end = true;
				} catch (IllegalThreadStateException ex) {
					// Process is running
				}
				// The process is not allowed to run longer than given time.
				if (System.currentTimeMillis() - start > MAX_PROCESS_RUNNING_TIME) {
					ls_proc.destroy();
					end = true;
					ret.append("!!!! Process has timed out, destroyed !!!!!");
				}
				try {
					Thread.sleep(50);
				} catch (InterruptedException ie) {
				}
			}
		} catch (IOException e) {
			ret.append("Error: " + e);
		}
		return ret.toString();
	}

	/**
	 * Converts a dir string to a linked dir string
	 * 
	 * @param dir
	 *            the directory string (e.g. /usr/local/httpd)
	 * @param browserLink
	 *            web-path to Browser.jsp
	 */
	public static String dir2linkdir(String dir, String browserLink,
			int sortMode) {
		File f = new File(dir);
		StringBuffer buf = new StringBuffer();
		while (f.getParentFile() != null) {
			if (f.canRead()) {
				String encPath = URLEncoder.encode(f.getAbsolutePath());
				buf.insert(0, "<a href=\"" + browserLink + "?sort=" + sortMode
						+ "&amp;dir=" + encPath + "\">"
						+ conv2Html(f.getName()) + File.separator + "</a>");
			} else
				buf.insert(0, conv2Html(f.getName()) + File.separator);
			f = f.getParentFile();
		}
		if (f.canRead()) {
			String encPath = URLEncoder.encode(f.getAbsolutePath());
			buf.insert(0, "<a href=\"" + browserLink + "?sort=" + sortMode
					+ "&amp;dir=" + encPath + "\">"
					+ conv2Html(f.getAbsolutePath()) + "</a>");
		} else
			buf.insert(0, f.getAbsolutePath());
		return buf.toString();
	}

	/**
	 * Returns true if the given filename tends towards a packed file
	 */
	public static boolean isPacked(String name, boolean gz) {
		return (name.toLowerCase().endsWith(".zip")
				|| name.toLowerCase().endsWith(".jar")
				|| (gz && name.toLowerCase().endsWith(".gz")) || name
				.toLowerCase().endsWith(".war"));
	}

	/**
	 * If RESTRICT_BROWSING = true this method checks, whether the path is
	 * allowed or not
	 */
	public static boolean isAllowed(File path, boolean write)
			throws IOException {
		if (READ_ONLY && write)
			return false;
		if (RESTRICT_BROWSING) {
			StringTokenizer stk = new StringTokenizer(RESTRICT_PATH, ";");
			while (stk.hasMoreTokens()) {
				if (path != null
						&& path.getCanonicalPath().startsWith(stk.nextToken()))
					return RESTRICT_WHITELIST;
			}
			return !RESTRICT_WHITELIST;
		} else
			return true;
	}
	
	public static String fileTypeImage(String fileName) {
		if (fileName != null) {
			if (fileName.endsWith(".doc") 
					|| fileName.endsWith(".docm")
					|| fileName.endsWith(".docx")
					|| fileName.endsWith(".dot")) {
				return "word.gif";
			} else if (fileName.endsWith(".pdf") 
					|| fileName.endsWith(".docm")
					|| fileName.endsWith(".docx")
					|| fileName.endsWith(".dot")) {
				return "pdf.gif";
			} else if (fileName.endsWith(".pot") 
					|| fileName.endsWith(".ppt")
					|| fileName.endsWith(".pps")
					|| fileName.endsWith(".ppa")
					|| fileName.endsWith(".pptx")
					|| fileName.endsWith(".pptm")
					|| fileName.endsWith(".potx")
					|| fileName.endsWith(".potm")				
					|| fileName.endsWith(".ppsx")
					|| fileName.endsWith(".ppsm")) {
				return "powerpoint.gif";
			} else if (fileName.endsWith(".xls") 
					|| fileName.endsWith(".xlt")
					|| fileName.endsWith(".xlw")
					|| fileName.endsWith(".xlsa")
					|| fileName.endsWith(".xlsx")
					|| fileName.endsWith(".xlsb")
					|| fileName.endsWith(".xlsm")
					|| fileName.endsWith(".xltx")				
					|| fileName.endsWith(".xltm")
					|| fileName.endsWith(".xlam")) {
				return "excel.gif";
			}
		}
		
		return "file.png";
	}

	public static void getServerImage(HttpServletRequest request, HttpServletResponse response, String directory, final String searchKey)
	throws Exception {
		FileInputStream inStream = null;
		SmbFileInputStream smbInStream = null;
		ServletOutputStream outStream = null;
		HttpSession session = request.getSession();
		boolean useSamba = false;
		File[] matchingFiles  = null;
		SmbFile[] matchingSmbFiles = null;
		
		try {
			if (ServerUtil.isUseSamba(directory)) {
				useSamba = true;
				SmbFile smbFolder = new SmbFile("smb:" + directory.replace("\\", "/"), 
						new NtlmPasswordAuthentication("",CMSDB.sysparams.get("smb_username"), CMSDB.sysparams.get("smb_password")));
				matchingSmbFiles = smbFolder.listFiles(new SmbFilenameFilter() {
					@Override
					public boolean accept(SmbFile dir, String name)
							throws SmbException {
						return name.startsWith(searchKey);
					}
				});
			} else {
				File f = new File(directory);
				matchingFiles = f.listFiles(new FilenameFilter() {
				    public boolean accept(File dir, String name) {
				        return name.startsWith(searchKey);
				    }
				});
			}

			File file = null;
			SmbFile smbFile = null;
			if ((!useSamba && matchingFiles.length >= 1) || (useSamba && matchingSmbFiles.length >= 1)) {
				session.setAttribute("progress-download", 0l);
				if (useSamba) {
					smbFile = matchingSmbFiles[0];
				} else {
					file = matchingFiles[0];
				}
				
				String fileName = (useSamba ? smbFile.getName() : file.getName());
				long fileLength = (useSamba ? smbFile.length() : file.length());
				
				response.setContentType(getMimeType(fileName));
				String encodedFileName = fileName;
				if (encodedFileName != null) {
					encodedFileName = URLEncoder.encode(fileName, "UTF-8");
					encodedFileName = encodedFileName.replace("+", " ");
				}
				response.setHeader("Content-disposition", "attachment; filename=\"" + encodedFileName + "\"");
				response.setHeader("Content-Length", String.valueOf(fileLength));

				int byteRead;
				int inStreamAva = 0;
				if (useSamba) {
					smbInStream = new SmbFileInputStream(smbFile);
					inStreamAva = smbInStream.available();
				} else {
					inStream = new FileInputStream(file);
					inStreamAva = inStream.available();
				}
				
				byte []  buf = new byte [ 4 * 1024 ] ; // 4K buffer
				outStream = response.getOutputStream();

				int readCount = 0;
				long progressPerc = 0;
				while ((byteRead = (useSamba ? smbInStream.read(buf) : inStream.read(buf))) != -1) {
					outStream.write(buf, 0, byteRead);

					readCount += byteRead;
					progressPerc = Math.round(((double) readCount / inStreamAva) * 100);
					// store the progress % value (0 - 100) in a session attribute 'progress-download'
					session.setAttribute("progress-download", progressPerc);
				}

				if (useSamba) {
					smbInStream.close();
					smbInStream = null;	
				} else {
					inStream.close();
					inStream = null;
				}

				outStream.flush();
				outStream.close();
				outStream = null;
			} else {
				throw new IOException("File not found");
			}
		} catch (ArrayIndexOutOfBoundsException e) {
		    e.printStackTrace();
		} finally {
			if (inStream != null) {
				try { inStream.close(); } catch (Exception e) {}
			}	
			if (smbInStream != null) {
				try { smbInStream.close(); } catch (Exception e) {}
			}
			if (outStream != null) {
				try { outStream.close(); } catch (Exception e) {}
			}
		}
	}
	
	public static void getServerImage(HttpServletRequest request, HttpServletResponse response, String filePath)
	throws Exception {
		FileInputStream inStream = null;
		SmbFileInputStream smbInStream = null;
		ServletOutputStream outStream = null;
		HttpSession session = request.getSession();
		boolean useSamba = false;
		File file  = null;
		SmbFile smbFile = null;

		try {	
			if (ServerUtil.isUseSamba(filePath)) {
				useSamba = true;
				smbFile = new SmbFile("smb:" + filePath.replace("\\", "/"), 
						new NtlmPasswordAuthentication("",CMSDB.sysparams.get("smb_username"), CMSDB.sysparams.get("smb_password")));
			} else {
				file = new File(filePath);
			}
			
			file = new File(filePath);
			if((!useSamba && file.exists() && !file.isDirectory()) ||
					(useSamba && smbFile.exists() && !smbFile.isDirectory())	
					) { 
				session.setAttribute("progress-download", 0l);

				String fileName = (useSamba ? smbFile.getName() : file.getName());
				long fileLength = (useSamba ? smbFile.length() : file.length());
				
				response.setContentType(getMimeType(fileName));
				String encodedFileName = fileName;
				if (encodedFileName != null) {
					encodedFileName = URLEncoder.encode(fileName, "UTF-8");
					encodedFileName = encodedFileName.replace("+", " ");
				}
				response.setHeader("Content-disposition", "attachment; filename=\"" + encodedFileName + "\"");
				response.setHeader("Content-Length", String.valueOf(fileLength));

				int byteRead;
				int inStreamAva = 0;
				if (useSamba) {
					smbInStream = new SmbFileInputStream(smbFile);
					inStreamAva = smbInStream.available();
				} else {
					inStream = new FileInputStream(file);
					inStreamAva = inStream.available();
				}
				byte []  buf = new byte [ 4 * 1024 ] ; // 4K buffer
				outStream = response.getOutputStream();

				int readCount = 0;
				long progressPerc = 0;
				while ((byteRead = inStream.read(buf)) != -1) {
					outStream.write(buf, 0, byteRead);

					readCount += byteRead;
					progressPerc = Math.round(((double) readCount / inStreamAva) * 100);
					// store the progress % value (0 - 100) in a session attribute 'progress-download'
					session.setAttribute("progress-download", progressPerc);
				}

				if (useSamba) {
					smbInStream.close();
					smbInStream = null;	
				} else {
					inStream.close();
					inStream = null;
				}

				outStream.flush();
				outStream.close();
				outStream = null;
			} else {
				throw new IOException("File not found");
			}
		} catch (ArrayIndexOutOfBoundsException e) {
		    e.printStackTrace();
		} finally {
			if (inStream != null) {
				try { inStream.close(); } catch (Exception e) {}
			}
			if (smbInStream != null) {
				try { smbInStream.close(); } catch (Exception e) {}
			}
			if (outStream != null) {
				try { outStream.close(); } catch (Exception e) {}
			}
		}
	}	
	
	public static boolean blobToFile(String path, String filename, Blob blob) {
		File targetPath = null;
		File blobFile = null;
		SmbFile smbTargetPath = null;
		SmbFile smbBlobFile = null;
		boolean useSamba = false;
		boolean success = true;
		
		try {
			if (ServerUtil.isUseSamba(path)) {
				useSamba = true;
				NtlmPasswordAuthentication auth = new NtlmPasswordAuthentication("",CMSDB.sysparams.get("smb_username"), CMSDB.sysparams.get("smb_password"));
				smbTargetPath = new SmbFile("smb:" + path.replace("\\", "/"), auth);
				smbBlobFile = new SmbFile("smb:" + (path+filename).replace("\\", "/"), auth);
			} else {
				useSamba = false;
				targetPath = new File(path);
				blobFile = new File(path+filename);
			}
		
			if (useSamba) {
				if (!smbTargetPath.exists()) {
					smbTargetPath.mkdirs();
				}
			} else {
				if (!targetPath.exists()) {
					targetPath.mkdirs();
				}
			}

			if ((useSamba && !smbTargetPath.exists()) ||
					(!useSamba && !targetPath.exists())) {
				System.out.println("---------(UtilFile) blobToFile---------");
				System.out.println(new Date() +" Cannot create directory.");
				return false;
			}
			
			if (useSamba) {
				if (!smbBlobFile.exists()) {
					smbBlobFile.createNewFile();
				}
			} else {
				if (!blobFile.exists()) {
					blobFile.createNewFile();
				}
			}
			
			if ((useSamba && !smbBlobFile.exists()) ||
					(!useSamba && !blobFile.exists())) {
				System.out.println("---------(UtilFile) blobToFile---------");
				System.out.println(new Date() +" Cannot create new file.");
				return false;
			}
			
			FileOutputStream outStream = null;
			SmbFileOutputStream smbOutStream = null;
			if (useSamba) {
				smbOutStream = new SmbFileOutputStream(smbBlobFile);
			} else {
				outStream = new FileOutputStream(blobFile);
			}
			InputStream inStream = blob.getBinaryStream();
			
			int length = -1;
			int size = (int)blob.length();
			byte[] buffer = new byte[size];
		 
			while ((length = inStream.read(buffer)) != -1) {
				if (useSamba) {
					smbOutStream.write(buffer, 0, length);
					smbOutStream.flush();
				} else {
					outStream.write(buffer, 0, length);
			        outStream.flush();
				}
		    }
			
			inStream.close();
			if (useSamba) {
				smbOutStream.close(); 
			} else {
				outStream.close(); 
			}
		}
		catch (Exception e) {
			e.printStackTrace();
			success = false;
		}
		finally {
			return success;
		}
	}
	
	public static byte[] getBytesFromFile(File file) throws IOException {
	    InputStream is = new FileInputStream(file);

	    // Get the size of the file
	    long length = file.length();

	    if (length > Integer.MAX_VALUE) {
	        // File is too large
	    }

	    // Create the byte array to hold the data
	    byte[] bytes = new byte[(int)length];

	    // Read in the bytes
	    int offset = 0;
	    int numRead = 0;
	    while (offset < bytes.length
	           && (numRead=is.read(bytes, offset, bytes.length-offset)) >= 0) {
	        offset += numRead;
	    }

	    // Ensure all the bytes have been read in
	    if (offset < bytes.length) {
	        throw new IOException("Could not completely read file "+file.getName());
	    }

	    // Close the input stream and return bytes
	    is.close();
	    return bytes;
	}
}
