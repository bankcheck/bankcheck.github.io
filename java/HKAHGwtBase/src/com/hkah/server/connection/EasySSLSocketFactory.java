/*
 * Created on November 18, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.server.connection;

import java.io.IOException;
import java.net.InetAddress;
import java.net.Socket;
import java.net.UnknownHostException;
import java.security.SecureRandom;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;

import javax.net.SocketFactory;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSocketFactory;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;

import org.apache.log4j.Logger;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
/**
 * @author ibsadmin1
 *
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 * 
 * reference page
 * http://www.javaworld.com.tw/jute/post/view?bid=5&id=49347&sty=3
 */
public class EasySSLSocketFactory extends SSLSocketFactory {

	private Logger logger = Logger.getLogger(EasySSLSocketFactory.class);

	private SSLSocketFactory factory;

	public EasySSLSocketFactory() {
		TrustManager[] trustAllCerts = new TrustManager[] { new X509TrustManager() {
			public X509Certificate[] getAcceptedIssuers() {
				return new X509Certificate[0];
			}
		
			public void checkClientTrusted(X509Certificate[] chain, String authType) throws CertificateException {
			}
		
			public void checkServerTrusted(X509Certificate[] chain, String authType) throws CertificateException {
			}
		}};

		try {
			SSLContext sslcontext = SSLContext.getInstance("SSL");
			sslcontext.init(null, trustAllCerts, new SecureRandom());
			this.factory = (SSLSocketFactory) sslcontext.getSocketFactory();
		} catch (Exception e) {
			logger.error(e.getMessage() + "  Error in Creating new EasySSLSocketFactory");
			e.printStackTrace();
		}
	}

	/**
	 * createSocket method comment.
	 */
	public Socket createSocket(String host, int port)
	throws IOException, UnknownHostException {
		return factory.createSocket(host, port);
	}

	/**
	 * createSocket method comment.
	 */
	public Socket createSocket(String host, int port, InetAddress localhost, int localport)
		throws IOException, UnknownHostException {
		return factory.createSocket(host, port, localhost, localport);
	}

	/**
	 * createSocket method comment.
	 */
	public Socket createSocket(InetAddress host, int port) throws IOException {
		return factory.createSocket(host, port);
	}

	/**
	 * createSocket method comment.
	 */
	public Socket createSocket(InetAddress host, int port, InetAddress localaddr, int localport)
	throws IOException {
		return factory.createSocket(host, port, localaddr, localport);
	}

	/**
	 * createSocket method comment.
	 */
	public Socket createSocket(Socket socket, String host, int port, boolean isbuffered)
	throws IOException {
		return factory.createSocket(socket, host, port, isbuffered);
	}

	public static SocketFactory getDefault() {
		return new EasySSLSocketFactory();
	}

	/**
	 * getDefaultCipherSuites method comment.
	 */
	public String[] getDefaultCipherSuites() {
		return factory.getSupportedCipherSuites();
	}

	/**
	 * getSupportedCipherSuites method comment.
	 */
	public String[] getSupportedCipherSuites() {
		return factory.getSupportedCipherSuites();
	}
}