package com.hkah.web.mobile;

import java.security.SecureRandom;
import java.security.cert.X509Certificate;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;
import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class ClientUtil {
    private static Log log = LogFactory.getLog(ClientUtil.class);
    private static SSLContext sslContext = null;
    private static HostnameVerifier hv = null;
    public static Client sslClient = null;
    public static Client client = null;
    private static TrustManager simpleTrust=null;
    static{
        client = ClientBuilder.newClient();
        try {
            sslContext = SSLContext.getInstance("SSLv3");
            simpleTrust=new X509TrustManager() {
                public X509Certificate[] getAcceptedIssuers() {
                    return new X509Certificate[0];
                }

                public void checkClientTrusted(X509Certificate[] certs, String authType) {
                }

                public void checkServerTrusted(X509Certificate[] certs, String authType) {
                }
            };
            sslContext.init(null, new TrustManager[] { simpleTrust}, new SecureRandom());
        } catch (Exception e) {
            log.error("SSL失败", e);
        }
        hv = new HostnameVerifier() {
            public boolean verify( String arg0, SSLSession arg1 ) { return true; }
        };
        sslClient = ClientBuilder.newBuilder().hostnameVerifier(hv).sslContext(sslContext).build();
    }

    public static Client getSslClient(String protocol)
    {
        try {
            SSLContext sslContextTmp= SSLContext.getInstance(protocol);
            sslContextTmp.init(null, new TrustManager[] { simpleTrust}, new SecureRandom());
            return ClientBuilder.newBuilder().hostnameVerifier(hv).sslContext(sslContextTmp).build();
        }
        catch (Exception ex)
        {
            return ClientBuilder.newBuilder().hostnameVerifier(hv).sslContext(sslContext).build();
        }
    }
}