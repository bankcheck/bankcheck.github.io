package com.hkah.web.exception;

public class LoginException extends BaseException {
	public static final String MSG_KEY = "message.server.error";
	
	public String getMsgKey() {
		return MSG_KEY;
	}
}
