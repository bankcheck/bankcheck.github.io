package com.hkah.server.servlet;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.ByteBuffer;
import java.nio.channels.Channels;
import java.nio.channels.FileChannel;
import java.nio.channels.WritableByteChannel;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import jcifs.smb.SmbFile;
import jcifs.smb.SmbFileInputStream;

import com.hkah.server.config.ClientConfig;
import com.hkah.server.util.AuthUtil;
import com.hkah.shared.model.UserInfo;
import com.hkah.shared.util.UrlUtil;

public class DownloadServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		service(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		service(req, resp);
	}
	
	private boolean isAccessible(HttpSession ses) {
		UserInfo userInfo = (UserInfo) ses.getAttribute("userInfo");
		
		return true;
	}

	@Override
	protected void service(HttpServletRequest req, HttpServletResponse res)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		String path = UrlUtil.parseStrUTF8(req.getParameter("path"));
		String dispositionType = req.getParameter("dispositionType");
		dispositionType = dispositionType == null ? "inline" : dispositionType;
		String basePath = ClientConfig.getObject().getServerFileBasePath();
		basePath = basePath == null ? "" : basePath;
		String directPath = req.getParameter("directPath");
		if (directPath != null) {
			directPath = URLDecoder.decode(directPath);
		}
		String os = System.getProperty("os.name").toLowerCase();
		
		HttpSession session = null;
		File file = null;
		SmbFile smbFile = null;
		FileInputStream inStream = null;
		ServletOutputStream outStream = null;
		FileChannel rbc = null;
		WritableByteChannel wbc = null;
		boolean isLinux = os.indexOf("nix") >= 0 || os.indexOf("nux") >= 0 || os.indexOf("aix") > 0;
		
		//System.out.println("[DownloadServlet] Start downloading.....");
		try {
			session = req.getSession();
			session.setAttribute("progress-download", 0l);
			
			if (directPath != null && directPath.length() > 0) {
				if (isLinux) {
					directPath = directPath.replace("\\", "/");
					
					//System.out.println("[DownloadServlet] directPath: "+directPath);
					//System.out.println("[DownloadServlet] New smb file....");
					smbFile = new SmbFile("smb://"+directPath, AuthUtil.getDefaultSmbAuth());
					//System.out.println("[DownloadServlet] smbFile is exists: "+smbFile.exists());
				}
				else {
					file = new File(directPath);
				}
				path = directPath;
			}
			else {
				if (isLinux) {
					path = path.replace("\\", "/");
					//System.out.println("[DownloadServlet] path: "+path);
					//System.out.println("[DownloadServlet] New smb file....");
					smbFile = new SmbFile("smb:"+path, AuthUtil.getDefaultSmbAuth());
					//System.out.println("[DownloadServlet] smbFile is exists: "+smbFile.exists());
				}
				else {
					file = new File(basePath + path);
				}
			}
			
			String encodedFileName = isLinux?smbFile.getName():file.getName();
			//System.out.println("[DownloadServlet] encodedFileName before: "+encodedFileName);
			
			if (encodedFileName != null) {
				encodedFileName = URLEncoder.encode(isLinux?smbFile.getName():file.getName(), "UTF-8");
				encodedFileName = encodedFileName.replace("+", " ");
			}
			//System.out.println("[DownloadServlet] encodedFileName after: "+encodedFileName);
			
			res.reset();
			res.setContentType(getMimeType(path));
			res.setHeader("Content-disposition", dispositionType + "; filename=\"" + encodedFileName + "\"");
			res.setHeader("Content-Length", String.valueOf(isLinux?smbFile.length():file.length()));

			if (isVideo(encodedFileName)) {
				if (isLinux) {
					SmbFileInputStream sfis = new SmbFileInputStream(smbFile);
					final byte[] buf = new byte[16 * 1024 * 1024];
					int len;
					while ((len = sfis.read(buf)) > 0) {
						res.getOutputStream().write(buf, 0, len);
					}
					
					sfis.close();
					res.getOutputStream().flush();
					res.getOutputStream().close();
				}
				else {
					rbc = new FileInputStream(file).getChannel();
					rbc.position(0);
					wbc = Channels.newChannel(res.getOutputStream());

					ByteBuffer bb = ByteBuffer.allocateDirect(11680);

					while (rbc.read(bb) != -1) {
						bb.flip();
						wbc.write(bb);
						bb.clear();
					}
					wbc.close();
					rbc.close();
				}
			} else {
				//System.out.println("[DownloadServlet] write file......");
				if (isLinux) {
					SmbFileInputStream sfis = new SmbFileInputStream(smbFile);
					final byte[] buf = new byte[16 * 1024 * 1024];
					int len;
					while ((len = sfis.read(buf)) > 0) {
						res.getOutputStream().write(buf, 0, len);
					}
					
					sfis.close();
					res.getOutputStream().flush();
					res.getOutputStream().close();
				}
				else {
					int byteRead;
	
					inStream = new FileInputStream(file);
					int inStreamAva = inStream.available();
					byte []  buf = new byte [ 4 * 1024 ] ; // 4K buffer
					outStream = res.getOutputStream();
					
					int readCount = 0;
					long progressPerc = 0;
					while ((byteRead = inStream.read(buf)) != -1) {
						outStream.write(buf, 0, byteRead);
						
						readCount += byteRead;
						progressPerc = Math.round(((double) readCount / inStreamAva) * 100);
						// store the progress % value (0 - 100) in a session attribute 'progress-download'
						session.setAttribute("progress-download", progressPerc);
					}
					outStream.flush();
					outStream.close();
				}
			}
		} catch (Exception e) {
			System.out.println("[DownloadServlet] Fail......");
			//System.out.println("[DownloadServlet] "+e.getMessage());
			//for(StackTraceElement er : e.getStackTrace()) {
			//	System.out.println("[DownloadServlet] "+er.toString());
			//}
			/*
			out.clearBuffer();
			res.setContentType("text/html; charset=big5");
			res.setHeader("Content-disposition", "inline");
			out.println("<HTML><BODY><P>");
			out.println(e.toString());
			out.println("</P></BODY></HTML>");
			*/
			e.printStackTrace();
		} finally {
			if (inStream != null) {
				try { inStream.close(); } catch (Exception e) {}
			}
			if (outStream != null) {
				try { outStream.close(); } catch (Exception e) {}
			}
			if (wbc != null) {
				try { wbc.close(); } catch (Exception e) {}
			}
			if (rbc != null) {
				try { rbc.close(); } catch (Exception e) {}
			}
		}
	}
	
	/**
	 * Returns the Mime Type of the file, depending on the extension of the filename
	 */
	private static String getMimeType(String fName) {
		fName = fName.toLowerCase();
		if (fName.endsWith(".jpg") || fName.endsWith(".jpeg") || fName.endsWith(".jpe")) return "image/jpeg";
		else if (fName.endsWith(".gif")) return "image/gif";
		else if (fName.endsWith(".pdf")) return "application/pdf";
		else if (fName.endsWith(".htm") || fName.endsWith(".html") || fName.endsWith(".shtml")) return "text/html";
		else if (fName.endsWith(".avi")) return "video/x-msvideo";
		else if (fName.endsWith(".mov") || fName.endsWith(".qt")) return "video/quicktime";
		else if (fName.endsWith(".mpg") || fName.endsWith(".mpeg") || fName.endsWith(".mpe")) return "video/mpeg";
		else if (fName.endsWith(".zip")) return "application/zip";
		else if (fName.endsWith(".tiff") || fName.endsWith(".tif")) return "image/tiff";
		else if (fName.endsWith(".rtf")) return "application/rtf";
		else if (fName.endsWith(".mid") || fName.endsWith(".midi")) return "audio/x-midi";
		else if (fName.endsWith(".xl") || fName.endsWith(".xls") || fName.endsWith(".xlv")
				|| fName.endsWith(".xla") || fName.endsWith(".xlb") || fName.endsWith(".xlt")
				|| fName.endsWith(".xlm") || fName.endsWith(".xlk")) return "application/excel";
		else if (fName.endsWith(".doc") || fName.endsWith(".dot")) return "application/msword";
		else if (fName.endsWith(".png")) return "image/png";
		else if (fName.endsWith(".xml")) return "text/xml";
		else if (fName.endsWith(".svg")) return "image/svg+xml";
		else if (fName.endsWith(".mp3")) return "audio/mp3";
		else if (fName.endsWith(".ogg")) return "audio/ogg";
		else return "application/octet-stream; charset=utf-8";
	}
	
	/**
	 * Returns whether the file is video
	 */
	private boolean isVideo(String fName) {
		fName = fName.toLowerCase();
		return fName.endsWith(".avi") || fName.endsWith(".mov") || fName.endsWith(".qt")
			|| fName.endsWith(".mpg") || fName.endsWith(".mpeg") || fName.endsWith(".mpe");
	}
}
