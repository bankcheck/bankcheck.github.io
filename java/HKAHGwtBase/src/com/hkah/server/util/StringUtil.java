/*
 * Created on July 4, 2008
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.hkah.server.util;

/**
 * @author administrator
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class StringUtil {

	private static final String PERCENTAGE_ORG = "%";
	private static final String PERCENTAGE_NEW = "%25";
	private static final String ADD_ORG = "+";
	private static final String ADD_NEW = "%2B";
	private static final String AND_ORD = "&";
	private static final String AND_NEW1 = "%26";
	private static final String AND_NEW2 = "&amp;";
	private static final String DOUBLE_QUOTE_ORG = "\"";
	private static final String DOUBLE_QUOTE_NEW = "&quot;";
	private static final String DOUBLE_GREATER_THAN_ORG = ">";
	private static final String DOUBLE_GREATER_THAN_NEW = "&gt;";
	private static final String DOUBLE_LESS_THAN_ORG = "<";
	private static final String DOUBLE_LESS_THAN_NEW = "&lt;";

	public static String replaceSpecialChar(String inQueue) {
		int start = 0;
		int counter = 0;
		StringBuffer tmpString = new StringBuffer();

		try {
			if (inQueue.indexOf(PERCENTAGE_ORG, start) >= 0) {
				while ((counter = inQueue.indexOf(PERCENTAGE_ORG, start)) >= 0) {
					tmpString.append(inQueue.substring(start, counter));
					tmpString.append(PERCENTAGE_NEW);
					start = counter + 1;
				}
				tmpString.append(inQueue.substring(start));
				inQueue = tmpString.toString();
			}

			// reset counter
			start = 0;
			counter = 0;
			tmpString.setLength(0);

			if (inQueue.indexOf(ADD_ORG, start) >= 0) {
				while ((counter = inQueue.indexOf(ADD_ORG, start)) >= 0) {
					tmpString.append(inQueue.substring(start, counter));
					tmpString.append(ADD_NEW);
					start = counter + 1;
				}
				tmpString.append(inQueue.substring(start));
				inQueue = tmpString.toString();
			}

			// reset counter
			start = 0;
			counter = 0;
			tmpString.setLength(0);

			if (inQueue.indexOf(AND_ORD, start) >= 0) {
				while ((counter = inQueue.indexOf(AND_ORD, start)) >= 0) {
					tmpString.append(inQueue.substring(start, counter));
					tmpString.append(AND_NEW1);
					start = counter + 1;
				}
				tmpString.append(inQueue.substring(start));
				inQueue = tmpString.toString();
			}
		} catch (Exception e) {}
		return inQueue;
	}

	public static String replaceSpecialChar4HTML(String inQueue) {
		int start = 0;
		int counter = 0;
		StringBuffer tmpString = new StringBuffer();

		try {
			if (inQueue.indexOf(AND_ORD, start) >= 0) {
				while ((counter = inQueue.indexOf(AND_ORD, start)) >= 0) {
					tmpString.append(inQueue.substring(start, counter));
					tmpString.append(AND_NEW2);
					start = counter + 1;
				}
				tmpString.append(inQueue.substring(start));
				inQueue = tmpString.toString();
			}

			// reset counter
			start = 0;
			counter = 0;
			tmpString.setLength(0);

			if (inQueue.indexOf(DOUBLE_QUOTE_ORG, start) >= 0) {
				while ((counter = inQueue.indexOf(DOUBLE_QUOTE_ORG, start)) >= 0) {
					tmpString.append(inQueue.substring(start, counter));
					tmpString.append(DOUBLE_QUOTE_NEW);
					start = counter + 1;
				}
				tmpString.append(inQueue.substring(start));
				inQueue = tmpString.toString();
			}

			// reset counter
			start = 0;
			counter = 0;
			tmpString.setLength(0);

			if (inQueue.indexOf(DOUBLE_LESS_THAN_ORG, start) >= 0) {
				while ((counter = inQueue.indexOf(DOUBLE_LESS_THAN_ORG, start)) >= 0) {
					tmpString.append(inQueue.substring(start, counter));
					tmpString.append(DOUBLE_LESS_THAN_NEW);
					start = counter + 1;
				}
				tmpString.append(inQueue.substring(start));
				inQueue = tmpString.toString();
			}

			// reset counter
			start = 0;
			counter = 0;
			tmpString.setLength(0);

			if (inQueue.indexOf(DOUBLE_GREATER_THAN_ORG, start) >= 0) {
				while ((counter = inQueue.indexOf(DOUBLE_GREATER_THAN_ORG, start)) >= 0) {
					tmpString.append(inQueue.substring(start, counter));
					tmpString.append(DOUBLE_GREATER_THAN_NEW);
					start = counter + 1;
				}
				tmpString.append(inQueue.substring(start));
				inQueue = tmpString.toString();
			}
		} catch (Exception e) {}
		return inQueue;
	}
}