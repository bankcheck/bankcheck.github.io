/*
 * Created on July 3, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.server.connection;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;

import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLSocketFactory;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ConnectionFactory {

	public static URLConnection factoryConnection(String urllocation) throws Exception {
		try {
			return factoryConnection(new URL(urllocation));
		} catch (MalformedURLException me) {
			throw new Exception("Invalid URL Location supplied!");
		}
	}

	public static URLConnection factoryConnection(URL url) throws Exception {
		String protocol = url.getProtocol();

		if (protocol == null || !protocol.trim().toLowerCase().startsWith("https")) {
			// Simple Url Connection required
			return openHTTPConnection(url);
		} else {
			// SSL Secure Connection establish
			return openHTTPSConnection(url);
		}
	}

	private static URLConnection openHTTPConnection(URL url) throws Exception {
		if (url != null) {
			try {
				URLConnection urlconn = url.openConnection();

				urlconn.setDoOutput(true);
				urlconn.setDoInput(true);
				urlconn.setAllowUserInteraction(false);
				urlconn.setUseCaches(false);

				return urlconn;
			} catch (IOException e) {
				throw new Exception("Unable to Connect to required URL !");
			}
		} else {
			throw new Exception("No URL is supplied !");
		}
	}

	private static URLConnection openHTTPSConnection(URL url) throws Exception {
		if (url != null) {
			try {
				// The following will try to establish an SSL Connect to the SSL Server
				// If the Connection is fail , Exception will throw
				Object obj = url.openConnection();

				HttpsURLConnection urlconn = (HttpsURLConnection) obj;
				SSLSocketFactory sslfactory = new EasySSLSocketFactory();
				urlconn.setSSLSocketFactory(sslfactory);

				/* ---Set Option of URL Connect ------------------------------------------- */
				urlconn.setDoOutput(true);
				urlconn.setDoInput(true);
				urlconn.setAllowUserInteraction(false);
				urlconn.setUseCaches(false);

				//urlconn.connect();
				return urlconn;
			} catch (IOException ioe) {
				throw new Exception("Unable to Connect to required URL !");
			}
		} else {
			throw new Exception("No URL is supplied !");
		}
	}
}