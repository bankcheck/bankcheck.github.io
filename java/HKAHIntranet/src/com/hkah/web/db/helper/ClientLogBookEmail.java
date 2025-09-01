package com.hkah.web.db.helper;

public class ClientLogBookEmail{
	public String emailTo;
	public String message;
	public String title;
	
	public ClientLogBookEmail(String emailTo,String message,String title){
		this.emailTo = emailTo;
		this.message = message;
		this.title = title;
	}
}