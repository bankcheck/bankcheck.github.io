/*
 * Created on July 29, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.servlet;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.hkah.constant.ConstantsServerSide;

/**
 * To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Generation - Code and Comments
 */
public class HKAHFileUploadServlet extends HttpServlet implements Runnable {

	// ======================================================================
	private static Logger logger = Logger.getLogger(HKAHFileUploadServlet.class);

	private static final int bufsize = 4096;

	private ServerSocket serversocket = null;
	private boolean isRunning;
	private static Thread thread = null;
	private String path = ConstantsServerSide.UPLOAD_FOLDER;
	private int port = 9080;

	public HKAHFileUploadServlet() {
		if (thread == null) {
			isRunning = true;
			thread = new Thread(this);
			thread.start();
		}
	}

	public void destroy() {
		super.destroy();

		isRunning = false;
		if (serversocket != null) {
			try {
				serversocket.close();
				serversocket = null;
			} catch (Exception e) {
			}
			logger.debug("stopped");
		}
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws IOException, ServletException {
		response.setStatus(HttpServletResponse.SC_OK);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws IOException, ServletException {
		doGet(request, response);
	}

	public void run() {
		File logpath = new File(path);
		if (!logpath.exists()) {
			logger.error("Error: " + path + " does not exist.");
			return;
		}

		try {
			serversocket = new ServerSocket(port);
			logger.info("Started, port: " + port + ", path: " + path);

			while (isRunning) {
				try {
					// accept connection
					Socket socket = serversocket.accept();

					// new FileUploadServerThread(socket).start();
					handleConnection(socket);
				} catch (Exception e) {
					logger.error("Exception: " + e.getMessage());
				}

				// wait a moment
				try {
					Thread.sleep(100);
				} catch (InterruptedException ie) {
				}
			}

			if (serversocket != null) {
				serversocket.close();
			}
		} catch (Exception e) {
			logger.error("Exception: " + e.getMessage());
			return;
		} finally {
			serversocket = null;
		}
	}

	private void handleConnection(Socket socket) {
		BufferedInputStream bin = null;
		FileOutputStream fout = null;

		try {
			if (socket != null) {
				bin = new BufferedInputStream(socket.getInputStream());

				byte[] buffer = new byte[bufsize];
				int len = bin.read(buffer);

				// get file name, assume first line is filename
				String firstline = new String(buffer);
				String header = "CLIENT LOG:";
				int pos1 = firstline.indexOf(header);
				int pos2 = firstline.indexOf('\n');
				int start = pos2 + 1;
				if (pos1 >= 0 && pos1 < pos2 && pos2 < 100) {
					String filename = firstline.substring(pos1
							+ header.length(), pos2);
					filename.replaceAll(" ", "");
					String savepath = path + filename.trim();

					// show file name
					logger.debug("File: " + filename + ", store path:"
							+ savepath);

					// write file
					fout = new FileOutputStream(savepath);
					while (len >= 0) {
						fout.write(buffer, start, len - start);
						start = 0;
						len = bin.read(buffer);
					}

					// completed
					logger.info("File completed: " + filename + ", store path:" + savepath);
				}
			}
		} catch (IOException e) {
			logger.error("[HKAHFileUploadServlet] exception: " + e.getMessage());
		} finally {
			if (fout != null)
				try {
					fout.close();
				} catch (IOException ioe) {
				}
			if (bin != null)
				try {
					bin.close();
				} catch (IOException ioe) {
				}
			if (socket != null)
				try {
					socket.close();
				} catch (IOException ioe) {
				}
			fout = null;
			bin = null;
			socket = null;
		}
	}
}