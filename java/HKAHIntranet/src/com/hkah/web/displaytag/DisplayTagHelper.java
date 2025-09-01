package com.hkah.web.displaytag;

import java.util.Enumeration;

import javax.servlet.http.HttpServletRequest;

public class DisplayTagHelper {
	public static String getPage(HttpServletRequest request) {
		int page = 0;
		String pageValue = null;
		Enumeration<String> paramNames = request.getParameterNames();
		while (paramNames.hasMoreElements()) {
			String name = paramNames.nextElement();
			if (name != null && name.startsWith("d-") && name.endsWith("-p")) {
				pageValue = request.getParameter(name);
				if (pageValue != null) {
					page = Integer.parseInt(pageValue) - 1;
				}
			}
		}
		return pageValue; // return String value
	}

	public static String getPageRequestParaName(HttpServletRequest request) {
		Enumeration<String> paramNames = request.getParameterNames();
		while (paramNames.hasMoreElements()) {
			String name = paramNames.nextElement();
			if (name != null && name.startsWith("d-") && name.endsWith("-p")) {
				return name;
			}
		}
		return null;
	}
}