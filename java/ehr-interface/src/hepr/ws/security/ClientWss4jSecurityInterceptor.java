package hepr.ws.security;

import org.springframework.ws.soap.security.wss4j.Wss4jSecurityInterceptor;

public class ClientWss4jSecurityInterceptor extends Wss4jSecurityInterceptor {
	public ClientWss4jSecurityInterceptor(){
		this.setSecurementUsername("webservice01");
		this.setSecurementPassword("webservice01");
		this.setSecurementPasswordType("PasswordText");
		this.setSecurementActions("UsernameToken Timestamp");
	}
}