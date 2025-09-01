package com.hkah.shared.model;
/*
 * Created on July 3, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import com.hkah.client.util.TextUtil;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
@SuppressWarnings("serial")
public class MessageQueue implements Serializable {

	public final static int NUM_HEADER_FIELD = 5;

	protected String[] mQueueContent = null;
	protected String text = null;
	protected boolean hasHeader = true;

	protected String txCode = null;
	protected String sysDate = null;
	protected String sysTime = null;
	protected String returnCode = null;
	protected String returnMsg = null;
	protected boolean isSuccess = false;
	protected int contentNum = -1;

	public MessageQueue() {
	}

	public MessageQueue(MessageQueue mQueue) {
		setMessageQueue(mQueue);
	}

	public MessageQueue(String dbResult) {
		this(dbResult, true);
	}

	public MessageQueue(String dbResult, boolean hasHeader) {
		this.hasHeader = hasHeader;
		this.setText(dbResult);
	}

	public MessageQueue(String[] mQueueContent) {
		this.hasHeader = false;
		this.mQueueContent = mQueueContent;
	}

	public void setMessageQueue(MessageQueue mQueue) {
		// copy constructor
		this.hasHeader = mQueue.hasHeader;
		this.text = mQueue.text;
		this.mQueueContent = mQueue.mQueueContent;
		this.txCode = mQueue.txCode;
		this.sysDate = mQueue.sysDate;
		this.sysTime = mQueue.sysTime;
		this.returnCode = mQueue.returnCode;
		this.returnMsg = mQueue.returnMsg;
		this.isSuccess = mQueue.isSuccess;
		this.contentNum = mQueue.contentNum;
	}

	public boolean success() {
		return isSuccess;
	}

	public String getText() {
		return text;
	}

	public void setText(String ptext) {
		this.text = ptext;

		String[] queueElements = null;
		queueElements = TextUtil.split(getText());

		if (hasHeader && queueElements.length >= NUM_HEADER_FIELD) {
			contentNum = queueElements.length - NUM_HEADER_FIELD;
			mQueueContent = new String[contentNum];
			System.arraycopy(queueElements, NUM_HEADER_FIELD, mQueueContent, 0, contentNum);

			txCode = queueElements[0].trim();
			sysDate = queueElements[1].trim();
			sysTime = queueElements[2].trim();
			returnCode = queueElements[3].trim();
			returnMsg = queueElements[4].trim();
			isSuccess = true;
			try {
				isSuccess = (Integer.parseInt(returnCode) >= 0);
			} catch (Exception e) {}
		} else if (!hasHeader) {
			contentNum = queueElements.length;
			mQueueContent = queueElements;

			txCode = "";
			sysDate = "";
			sysTime = "";
			returnCode = "";
			returnMsg = "";
			isSuccess = true;
		}

		// remove last char if last char is "^"
		if (mQueueContent != null && mQueueContent.length > 0) {
			int last = mQueueContent.length - 1;
			String tmp = mQueueContent[last];
			if (tmp.length() > 0 && tmp.charAt(tmp.length() - 1) == '^') {
				mQueueContent[last] = tmp.substring(0, tmp.length() - 1);
			}
		}
	}
	
	public int getContentLineCount() {
		int ret = 0;
		if (getContentAsQueue() != null) {
			String[] line = TextUtil.split(
					getContentAsQueue(), TextUtil.LINE_DELIMITER);
			if (line != null) {
				ret = line.length;
			}
		}
		return ret;
	}

	public boolean isEmptyText() {
		return mQueueContent.length == 0;
	}

	public int getContentNum() {
		return contentNum;
	}

	public String[] getContentField() {
		return mQueueContent;
	}

	public String getContentAsQueue() {
		return TextUtil.combine(getContentField());
	}

	public String getTxCode() {
		// 1
		return txCode;
	}

	public String getSysDate() {
		// 2
		return sysDate;
	}

	public String getSysTime() {
		// 3
		return sysTime;
	}

	public String getReturnCode() {
		// 4
		return returnCode;
	}

	public String getReturnMsg() {
		// 5
		return returnMsg;
	}
	
	public List<String[]> getContentAsArray() {
		String[] record = TextUtil.split(getContentAsQueue(), TextUtil.LINE_DELIMITER);
		String[] fields = null;
		String[] content = null;
		int numOfCol = 0;
		int colCount = 0;
		List<String[]> results = new ArrayList<String[]>();
		
		for (int i = 0; i < record.length; i++) {
			fields = TextUtil.split(record[i]);

			if (i == 0) {
				numOfCol = fields.length;
			}
			content = new String[numOfCol];
			colCount = 0;
			
			if (!TextUtil.FIELD_DELIMITER.equals(record[i])) {
				for (int n=0; n<fields.length; n++) {
					content[colCount++] = fields[n];
				}
			}
			results.add(content);
		}
		
		return results;
	}
}