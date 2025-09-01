/*
 * Created on March 11, 2009
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.util.file;

/**
 * To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Generation - Code and Comments
 */
public class UplInfo {

	public long totalSize;

	public long currSize;

	public long starttime;

	public boolean aborted;

	public UplInfo() {
		totalSize = 0l;
		currSize = 0l;
		starttime = System.currentTimeMillis();
		aborted = false;
	}

	public UplInfo(int size) {
		totalSize = size;
		currSize = 0;
		starttime = System.currentTimeMillis();
		aborted = false;
	}

	public String getUprate() {
		long time = System.currentTimeMillis() - starttime;
		if (time != 0) {
			long uprate = currSize * 1000 / time;
			return UtilFile.convertFileSize(uprate) + "/s";
		} else
			return "n/a";
	}

	public int getPercent() {
		if (totalSize == 0)
			return 0;
		else
			return (int) (currSize * 100 / totalSize);
	}

	public String getTimeElapsed() {
		long time = (System.currentTimeMillis() - starttime) / 1000l;
		if (time - 60l >= 0) {
			if (time % 60 >= 10)
				return time / 60 + ":" + (time % 60) + "m";
			else
				return time / 60 + ":0" + (time % 60) + "m";
		} else
			return time < 10 ? "0" + time + "s" : time + "s";
	}

	public String getTimeEstimated() {
		if (currSize == 0)
			return "n/a";
		long time = System.currentTimeMillis() - starttime;
		time = totalSize * time / currSize;
		time /= 1000l;
		if (time - 60l >= 0) {
			if (time % 60 >= 10)
				return time / 60 + ":" + (time % 60) + "m";
			else
				return time / 60 + ":0" + (time % 60) + "m";
		} else
			return time < 10 ? "0" + time + "s" : time + "s";
	}
}
