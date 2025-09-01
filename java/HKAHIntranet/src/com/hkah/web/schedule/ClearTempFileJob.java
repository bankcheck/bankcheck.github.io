package com.hkah.web.schedule;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.hkah.web.db.helper.FsModelHelper;

public class ClearTempFileJob implements Job {

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		// -- Forward Scanning --
		FsModelHelper.clearAllTempImportFiles();
		FsModelHelper.clearAllPreviewImages();
	}
}
