package com.hkah.service;

import java.io.IOException;
import java.util.HashMap;

import javax.websocket.OnClose;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

@ServerEndpoint("/websocket")
public class WebSocketEndpoint {
	private static HashMap<String, Session> allRemote = new HashMap<String, Session>();

	public WebSocketEndpoint getInstance() {
		return this;
	}

	@OnOpen
	public void openConnection(Session session) {
		try {
			allRemote.put(session.getId(), session);
			sendMessage(session, "Return ID:" + session.getId());
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		System.out.printf("@OnOpen:Session {0} has added. Size {1}", session.getId(), allRemote.size());
	}

	@OnMessage
	public void onMessage(Session session, String message) {
		try {
//			sendMessage(session, message);
			sendMessage2All(message);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		System.out.printf("@onMessage:Session {0} sent message {1}", session.getId(), message);
	}

	@OnClose
	public void closedConnection(Session session) {
		try {
			allRemote.remove(session.getId());
			sendMessage(session, "Connection closed");
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		System.out.printf("@OnClose:Session {0} has ended. Size {1}", session.getId(), allRemote.size());
	}

	public static void sendMessage(String id, String message) {
		if (allRemote.containsKey(id)) {
			try {
				sendMessage(allRemote.get(id), message);
			} catch (Throwable e) {
				e.printStackTrace();
			}
		}
	}

	public static void sendMessage2All(String message) {
		for (String ipAddress : allRemote.keySet()) {
			if (allRemote.containsKey(ipAddress)) {
				try {
					sendMessage(allRemote.get(ipAddress), message);
				} catch (Throwable e) {
					e.printStackTrace();
				}
			}
		}
	}

	private static void sendMessage(Session session, String message) throws IOException {
		synchronized (session) {
			if (session.isOpen()) {
				session.getBasicRemote().sendText(message);
			}
		}
	}
}